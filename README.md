# Relatório Processador Digital
O relatório a seguir detalha o funcionamento de um processador simples, que lê e executa operações de um arquivo texto, a partir das instruções contidas nele (de acordo com o padrão especificado).

## Funcionamento geral
Inicialmente, o arquivo texto passa pelo processamento do código python contido neste projeto, que basicamente lê o arquivo e converte cada instrução para um número binário de 8 bits. As instruções são dadas no padrão: ```COMANDO REGISTRADOR1 REGISTRADOR2```. O código então as converte seguindo o padrão de 4 bits para armazenar o comando e 2 bits para armazenar o indicativo de qual registrador está sendo usado a (00), b (01) ou r (10). Caso o valor lido seja um número imediato, que não seja acessado via registrador, o código guardado é 11 e o valor do número é armazenado na linha seguinte do arquivo. Caso o padrão da instrução não precise da leitura de 2 registradores, o valor da linha seria algo como ```COMANDO REGISTRADOR1 00``` e nas instruções seria tratado apenas o primeiro registrador ou o valor poderia ser ```COMANDO 11``` e na próxima linha seria guardado o valor do número literal (esse último ocorre por exemplo no comando JMP, que precisa de um endereço de memória para o qual "pular").
Esse código binário então é convertido para número hexadecimal, e guardado em um arquivo ```.hex```. Essa conversão foi precisa pela necessidade de simular o processador usando o Modelsim, e esse programa não lê arquivos ```.mif```, que guardariam os valores em binário, apenas arquivos ```.hex```.
Tendo o arquivo estruturado nesse padrão, podemos executar nossa CPU.

## Arquitetura
O processador está modularizado em 4 componentes: ```cpu```, ```control_unit```, ```ula``` e ```memory```. 
1. O primeiro, funciona como um pré-processador das instruções, lendo as linhas do arquivo hexadecimal (interpretado como binário) e separando o que seria um valor de registrador e o que seria a operação especificada
2. Já o segundo componente, ```control_unit```, serve como um distribuidor de tarefas, lendo as instruções pré-processadas enviadas pela cpu e acionando os componentes necessários para executá-las.
3. A ```ula``` realiza as operações da ```control_unit``` de ordem numérica: soma, subtração, multiplicação lógica (AND), soma lógica (OR) e negação (NOT).
4. Por último, a ```memory``` é responsável por efetivamente ler os valores do arquivo ```.hex``` (ou poderia ser ```.mif``` caso estivéssemos simulando pelo Quartus).

### Cpuo
Esse componente possui 4 estados:

| Estado            | Efeito        |
| --------------    |:-------------:|
| READ_MEM          | Leitura de instruções padrão da memória          |
| DECODE            | Decodificação das instruções     |
| IMMEDIATE_NUMBER  | Leitura do número imediato           |
| IDLE              | Estado de espera (adicionado para sincroniza dos registradores)            |

Os valores de operações e operadores lidos (e números imediatos quando houver), são então enviados para a ```control_unit``` realizar as operações com esses valores.

Segue um pequeno esquemático do funcionamento dessa máquina de estados:
![Esquemátic](https://github.com/PedroHP1708/cpu/blob/main/recursos/Diagrama.jpeg)

### Control_unit
Esse é o componente principal do programa, sendo o responsável por acionar os componentes necessários para cada tarefa passada como parâmetro pela ```cpu```.

| Código do estado  | Operação      | Componente    |
| --------------    |:-------------:|:-------------:|
| 0000              | Soma          | ULA           |
| 0001              | Subtração     | ULA           |
| 0010              | And           | ULA           |
| 0011              | Or            | ULA           |
| 0100              | Not           | ULA           |
| 0100              | Not           | ULA           |
| 0101              | Cmp           | ULA           |
| 0110              | Jmp           | Memory        |
| 0111              | Jeq           | Memory        |
| 1000              | Jgr           | Memory        |
| 1001              | Load          | Memory        |
| 1010              | Store         | Memory        |
| 1011              | Mov           | Memory                                     |
| 1100              | In            | Input_unit (feito na própria control_unit) |
| 1101              | Out           | Output_unit (feito na própria control_unit) |

```vhdl
entity unit_control is
    port (
        options    : in  std_logic_vector(3 downto 0); 
        inputs 	   : in  std_logic_vector(7 downto 0);
	reg1       : in  std_logic_vector(1 downto 0);  
        reg2       : in  std_logic_vector(1 downto 0);  
        imNu       : in  std_logic_vector(7 downto 0);
	addr       : in  std_logic_vector(7 downto 0) := "00000000";  
        clk        : in  std_logic;                     
        previousOp : out std_logic_vector(3 downto 0);  
        -- Registradores para serem atualizados
        regA       : out std_logic_vector(7 downto 0);  
        regB       : out std_logic_vector(7 downto 0);  
        regR       : out std_logic_vector(7 downto 0);  
        regImmediate : out std_logic_vector(7 downto 0);
	outputs	 : out std_logic_vector(7 downto 0)
    );
end unit_control;
```
Ela recebe como parâmetros as instruções lidas, já decodificadas em seus respectivos registradores e operação. Além disso, ela possui como saída os valores de 
cada registrador, atualizados conforme instrução passada.

### Ula
Esse componente consiste em uma máquina de estados que realiza operações numéricas com os registradores passados por parâmetro:

| Código do estado  | Operação      |
| --------------    |:-------------:|
| 0000              | Soma          |
| 0001              | Subtração     |
| 0010              | And           |
| 0011              | Or            |
| 0100              | Not           |

A ula possui os seguintes parâmetros:

```vhdl
entity ula is
    Port (
        a               : in  STD_LOGIC_VECTOR(7 downto 0);
        b               : in  STD_LOGIC_VECTOR(7 downto 0);
        operation       : in  STD_LOGIC_VECTOR(3 downto 0);  -- Operation selector
        result          : buffer STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit result
        flagOverflow    : out STD_LOGIC;                     
        flagCarry       : out STD_LOGIC;
        flagZero        : out STD_LOGIC;  -- Flag Zero
        flagSignal      : out STD_LOGIC   -- Flag Signal (Sinal)
    );
end ula;
```
Sendo as entradas, os registradores e a operação passados pela ```control_unit```, e as saídas as flags de overflow, carry, sinal e zero e o resultado da operação especificada com base nos valores dados.

### Memory
Esse último componente é o responsável por ler os valores do arquivo contendo o código em hexadecimal. 
```vhdl
entity memory is
	port
	(
		address	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock : IN STD_LOGIC;
		data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren : IN STD_LOGIC;
		q : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
end memory;
```
Para leitura, usa-se o endereço ```address``` para obter o conteúdo da mesma na saída ```q```. A escrita depende do valor inserido em ```data```.

## Instruções não implementadas
As instruções de desvio de lógica (JMP, JEQ e JGR) e atribuição e recuperação de valores da memória (LOAD e STORE) não conseguiram ser implementadas a tempo da entrega. Durante a apresentação houve uma tentativa de desenvolvimento das mesmas, porém sem obter sucesso. A tentativa de implementação está salva aqui no repositório na pasta ```tentativa```. Na versão final, estes comandos estão com comentários da ideia que seria implementada caso o grupo tivesse conseguido finalizar.
