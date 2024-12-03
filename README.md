# Relatório Processador Digital
O relatório a seguir detalha o funcionamento de um processador simples, que lê e executa operações de um arquivo texto, a partir das instruções contidas nele (de acordo com o padrão especificado).

## Funcionamento geral
Inicialmente, o arquivo texto passa pelo processamento do código python contido neste projeto, que basicamente lê o arquivo e converte cada instrução para um número binário de 8 bits. As instruções são dadas no padrão: ```COMANDO REGISTRADOR1 REGISTRADOR2```. O código então as converte seguindo o padrão de 4 bits para armazenar o comando e 2 bits para armazenar o indicativo de qual registrador está sendo usado a (00), b (01) ou r (10). Caso o valor lido seja um número imediato, que não seja acessado via registrador, o código guardado é 11 e o valor do número é armazenado na linha seguinte do arquivo. **citar casos que a formatação foge disso**
Esse código binário então é convertido para número hexadecimal, e guardado em um arquivo ```.hex```. Essa conversão foi precisa pela necessidade de simular o processador usando o Modelsim, e esse programa não lê arquivos ```.mif```, que guardariam os valores em binário, apenas arquivos ```.hex```.
Tendo o arquivo estruturado nesse padrão, podemos executar nossa CPU.

## Arquitetura
O processador está modularizado em 4 componentes: ```cpu```, ```control_unit```, ```ula``` e ```memory```.

### Cpu

### Control_unit

### Ula
Esse componente consiste em uma máquina de estados que realiza operações numéricas com os registradores passados por parâmetro:
1. vdvdvdf
   vdbdbvvdb

2.
### Memory
