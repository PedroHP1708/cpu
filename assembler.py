def instruction_to_binary(instruction):
    # Mapeamento das operações para seus códigos binários
    operations = {
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

    # Mapeamento dos registradores
    registers = {
        "A": "00",
        "B": "01",
        "R": "10"
    }

    # Dividir a instrução em partes: operação, operando1 e operando2
    parts = instruction.split()
    op = parts[0]      # Operação (como ADD, SUB, etc.)
    operand1 = parts[1]  # Primeiro operando (como A, B, R ou um número)
    operand2 = parts[2] if len(parts) > 2 else None  # Segundo operando (se houver)

    # Verificar e converter a operação
    op_binary = operations.get(op)
    if not op_binary:
        raise ValueError(f"Operação inválida: {op}")

    # Converte o primeiro operando
    if operand1 in registers:
        operand1_binary = registers[operand1]
    else:
        # Se for um número, converter para binário
        try:
            operand1_binary = format(int(operand1), '08b')  # Representação de 8 bits
        except ValueError:
            raise ValueError(f"Registrador ou valor inválido: {operand1}")

    # Converte o segundo operando (se existir)
    if operand2:
        # Verificar se o operando é um número binário (com 0 ou 1)
        if operand2.startswith('0') and all(c in '01' for c in operand2):
            # Se for binário, simplesmente use o valor como está
            operand2_binary = operand2
        elif operand2 in registers:
            operand2_binary = registers[operand2]
        else:
            try:
                operand2_binary = format(int(operand2), '08b')  # Representação de 8 bits
            except ValueError:
                raise ValueError(f"Registrador ou valor inválido: {operand2}")
    else:
        operand2_binary = "00000000"  # Se não houver segundo operando, assume valor zero

    # Monta a instrução binária: operação + operandos
    binary_instruction = op_binary + operand1_binary + operand2_binary

    return binary_instruction


# Função para ler o arquivo de instruções e convertê-las
def process_instructions_from_file(file_path, output_file_path):
    try:
        with open(file_path, 'r') as file:
            instructions = file.readlines()

        with open(output_file_path, 'w') as output_file:
            # Processa cada linha (instrução) do arquivo
            for instruction in instructions:
                instruction = instruction.strip()  # Remove espaços em branco e quebras de linha
                if instruction:  # Evita processar linhas vazias
                    try:
                        binary = instruction_to_binary(instruction)
                        print(f"Instrução: {instruction} -> Binário: {binary}")
                        # Escreve a instrução binária no arquivo de saída
                        output_file.write(binary + '\n')
                    except ValueError as e:
                        print(f"Erro ao processar a instrução '{instruction}': {e}")

    except FileNotFoundError:
        print(f"Erro: Arquivo '{file_path}' não encontrado.")
    except Exception as e:
        print(f"Erro inesperado: {e}")


# Exemplo de uso:
# Substitua 'instrucoes.txt' pelo caminho do seu arquivo de instruções e 'saida.txt' pelo caminho do arquivo de saída
process_instructions_from_file('instrucoes.txt', 'saida.txt')
