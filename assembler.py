OPCODES = {
    "ADD": "0000",
    "SUB": "0001",
    "AND": "0010",
    "OR": "0011",
    "NOT": "0100",
    "CMP": "0101",
    "JMP": "0110",
    "JEQ": "0111",
    "JGR": "1000",
    "LOAD": "1001",
    "STORE": "1010",
    "MOV": "1011",
    "IN": "1100",
    "OUT": "1101",
    "WAIT": "1110"
}

REGISTRADORES = {
    "A": "00",
    "B": "01",
    "R": "10",
    "L": "11"
}

# Função para ler um arquivo de código assembly e ignorar comentários
def ler_arquivo_assembly(caminho_arquivo):
    try:
        with open(caminho_arquivo, 'r') as arquivo:
            linhas = arquivo.readlines()
        # Remove comentários e linhas vazias
        codigo = [
            linha.split(';')[0].strip()  # Ignora comentários após ';'
            for linha in linhas
            if linha.strip() and not linha.strip().startswith(';')  # Ignora linhas vazias e comentários
        ]
        return codigo
    except FileNotFoundError:
        print(f"Erro: O arquivo '{caminho_arquivo}' não foi encontrado.")
        return []
    except Exception as e:
        print(f"Erro ao ler o arquivo: {e}")
        return []

# Função para fazer a escrita em um arquivo .hex (somente valores hexadecimais)
def escrever_arquivo_hex(codigo_hex, caminho_hex):
    try:
        with open(caminho_hex, 'w') as arquivo:
            for linha in codigo_hex:
                arquivo.write(f"{linha}\n")  # Escreve apenas o valor hexadecimal por linha
        print(f"Arquivo '{caminho_hex}' criado com sucesso.")
    except Exception as e:
        print(f"Erro ao criar o arquivo .hex: {e}")


def identificar_labels(codigo):
    labels = {}
    num_linha = 0
    for line in codigo:
        line = line.split(";")[0].strip()  # Remove comentários e espaços extras
        if not line:
            continue
        # Se for uma label, armazenar o endereço atual
        if ":" in line:
            label = line.replace(":", "")
            labels[label] = num_linha
        else:
            tokens = line.split()
            opcode = tokens[0]
            num_linha += 1  # Instrução ocupa uma linha
            # Adicionar linha extra para literais
            if opcode in ["JMP", "JEQ", "JGR"]:
                num_linha += 1
            if opcode in ["ADD", "SUB", "AND", "OR", "MOV", "CMP", "LOAD", "STORE"]:
                if len(tokens) > 2 and (tokens[2].isdigit() or tokens[1].isdigit()):  # Algum 
                    num_linha += 1
                elif len(tokens) > 1 and tokens[1].isdigit():  # Primeiro argumento é literal
                    num_linha += 1
    return labels


def assemble_line(line, num_linha, labels):
    line = line.split(";")[0].strip()  # Remove comentários e espaços extras
    if not line:
        return [], num_linha

    # Remover todas as vírgulas da linha
    line = line.replace(",", "")

    tokens = line.split()
    opcode = tokens[0]  # Primeira palavra é a instrução
    binary_output = []

    if opcode in OPCODES:
        binary_instruction = OPCODES[opcode]
        
        # Se for um rótulo (e.g., LOOP_START:), ignore
        if line.endswith(":"):
            return [], num_linha
        
        # Agora os parâmetros estão sem vírgulas
        primeiro = tokens[1] if len(tokens) > 1 else ""
        segundo = tokens[2] if len(tokens) > 2 else ""
        
        # WAIT: sem argumentos
        if opcode == "WAIT":
            binary_output.append(binary_instruction + "0000")
        
        # ADD, SUB, AND, OR, MOV, CMP: 1 ou 2 registradores, podendo um ser literal
        elif opcode in ["ADD", "SUB", "AND", "OR", "MOV", "CMP"]:
            if primeiro.isdigit():
                literal = int(primeiro)
                reg = REGISTRADORES.get(segundo, None)
                binary_output.append(binary_instruction + "11" + reg)
                binary_output.append(format(literal, "08b"))
                num_linha += 1  # Literal ocupa uma linha extra
            elif segundo.isdigit():
                literal = int(segundo)
                reg = REGISTRADORES.get(primeiro, None)
                binary_output.append(binary_instruction + reg + "11")
                binary_output.append(format(literal, "08b"))
                num_linha += 1  # Literal ocupa uma linha extra
            else:
                reg1 = REGISTRADORES.get(primeiro, None)
                reg2 = REGISTRADORES.get(segundo, None)
                if ((not reg1) or (not reg2)):
                    raise ValueError(f"Erro na linha {num_linha}: registrador inválido.")
                binary_output.append(binary_instruction + reg1 + reg2)
        
        # LOAD, STORE: 2 registradores, sendo um obrigatoriamente literal
        elif opcode in ["LOAD", "STORE"]:
            reg = REGISTRADORES.get(primeiro, None)
            binary_output.append(binary_instruction + reg + "11")
            # Se o número for realmente um inteiro
            if len(segundo) == 8 and all(c in "01" for c in segundo):
                # Já é binário: usar diretamente
                binary_output.append(segundo)
            # Se o número estiver como um vetor binário "00001101", por exemplo
            else:
                binary_output.append(format(int(segundo), "08b"))
            num_linha += 1  # Literal ocupa uma linha extra
        
        # NOT, IN, OUT: apenas 1 registrador, obrigatoriamente não-literal
        elif opcode in ["NOT", "IN", "OUT"]:
            reg = REGISTRADORES.get(tokens[1], None)
            binary_output.append(binary_instruction + "00" + reg)
        
        # JMP, JEQ, JGR: Operações que usam endereço literal
        elif opcode in ["JMP", "JEQ", "JGR"]:
            address_label = tokens[1]
            if address_label in labels:
                address = labels[address_label]
                binary_output.append(binary_instruction + "0011")  # Literal
                binary_output.append(format(address, "08b"))
                num_linha += 1  # Literal ocupa uma linha extra
            else:
                raise ValueError(f"Erro na linha {num_linha}: rótulo '{address_label}' não encontrado.")

    return binary_output, num_linha

def converter_assembly_para_binario(codigo):
    # Primeira passagem para identificar labels
    labels = identificar_labels(codigo)

    binary_code = []
    num_linha = 0
    for line in codigo:
        try:
            linha_binaria, num_linha = assemble_line(line, num_linha, labels)
            binary_code.extend(linha_binaria)
        except ValueError as e:
            print(e)
    
    return binary_code


# Função para converter binário em hexadecimal
def binario_para_hex(binario):
    return hex(int(binario, 2))[2:].zfill(2).upper()  # Retorna em formato hexadecimal, com 2 caracteres

# Entrada para o nome de um arquivo fornecido pelo usuário
caminho = "/home/pedro/Downloads/"  
nome_arquivo = input("Qual o nome do arquivo? ")
caminho_entrada = caminho + nome_arquivo
# Saída por padrão para o nome do arquivo .hex
caminho_saida = caminho + "/ram256x8.hex" 
codigo_assembly = ler_arquivo_assembly(caminho_entrada)

codigo_binario = converter_assembly_para_binario(codigo_assembly)

# Gerar os valores hexadecimais
codigo_hex = [binario_para_hex(linha) for linha in codigo_binario]

# Completar até 256 linhas com 'F0'
while len(codigo_hex) < 256:
    codigo_hex.append("F0")

if codigo_hex:
    escrever_arquivo_hex(codigo_hex, caminho_saida)
else:
    print("Nenhum código foi lido ou o arquivo está vazio.")
