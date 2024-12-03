-- Leitura da linha
-- XXXX - XX - XX
-- operação - registrador1 - registrador 2 (interpretar número literal como registrador e ler novamente da memória a linha de baixo)

-- Supostamente a CPU está funcionando, falta testar com a memória agora
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cpu is
		Port ( 
			clk   	 					: in   STD_LOGIC;
			reset							: in 	 STD_LOGIC;
			enableRead					: in   STD_LOGIC;
			inputs 						: in   STD_LOGIC_VECTOR(7 downto 0);
			outputs						: out  STD_LOGIC_VECTOR(7 downto 0)
    );
end entity cpu;

architecture Behavioral of cpu is
		
		type state_type is (IDLE, READ_MEM, DECODE, IMMEDIATE_NUMBER);
		signal state: state_type := READ_MEM; --criando a variável estado e atribui­ndo valor inicial para READ_MEM
		
		component unit_control is
			port (
				options      : in  std_logic_vector(3 downto 0);  -- Comando de 4 bits para a ULA
				inputs	    : in  std_logic_vector(7 downto 0);
				reg1         : in  std_logic_vector(1 downto 0);  -- Sinal de controle (ex: valor do primeiro operando)
				reg2         : in  std_logic_vector(1 downto 0);  -- Outro sinal de controle (ex: valor do segundo operando)
				imNu		    : in std_logic_vector(7 downto 0);
				addr         : in  std_logic_vector(7 downto 0);  -- Endereço de memória e questão
				clk          : in  std_logic;                     -- Sinal de controle (ex: clock ou start)
				previousOp   : out std_logic_vector(3 downto 0);  -- Operação anterior (para controle)
				-- Registradores para serem atualizados
				regA         : out std_logic_vector(7 downto 0);  -- Registrador A
				regB         : out std_logic_vector(7 downto 0);  -- Registrador B
				regR       	 : out std_logic_vector(7 downto 0);  -- Registrador R
				outputs		 : out  std_logic_vector(7 downto 0)
			);
		end component;
		 
		component Memory is
			Port (
				clock			: IN STD_LOGIC  := '1';
				data			: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
				address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
				wren			: IN STD_LOGIC  := '1';
				q				: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
			);
		end component;
		
		-- Sinais internos para operações
		signal a, b, r  : STD_LOGIC_VECTOR(7 downto 0);
		
		-- Sinais internos para memória
		signal address, data, q     : STD_LOGIC_VECTOR(7 downto 0) := "00000000"; --inicializar
		signal wren : STD_LOGIC;
		
		-- Registradores para leitura
		signal op					: STD_LOGIC_VECTOR(3 downto 0);
		signal oper1, oper2		: STD_LOGIC_VECTOR(1 downto 0);
		signal immediateNumber	: STD_LOGIC_VECTOR(7 downto 0) := "00000000";
		
		signal instructionRegister	: STD_LOGIC_VECTOR(3 downto 0); -- Armazenar operação anterior
		signal programCounter		: STD_LOGIC_VECTOR(7 downto 0) := "00000000"; -- Indexar arquivo .mif (ou .hex no modelsim)
		
begin

	ram: Memory
		port map(
		  address => address,
		  clock => clk,
		  data => data,
		  wren => wren,
		  q => q
		);
 
	uc: unit_control
		port map(
			options => op,
			addr    => address,
			reg1	  => oper1,
			reg2    => oper2,
			clk     => clk,
			inputs => inputs,
			imNu => immediateNumber,
			previousOp => instructionRegister,
			regA => A,
			regB => B,
			regR => R,
			outputs => outputs
		);

	process(clk, reset)
	begin
    if reset = '0' then
        state <= READ_MEM; -- Inicializa no estado de decodificação
    elsif rising_edge(clk) then
        case state is
            -- Estado de leitura de memória (READ_MEM)
            when READ_MEM =>
                address <= programCounter;
                programCounter <= STD_LOGIC_VECTOR(unsigned(programCounter) + 1);
                state <= DECODE;

            -- Estado de decodificação da instrução (DECODE)
            when DECODE =>
                op <= q(7 downto 4);
                oper1 <= q(3 downto 2);
                oper2 <= q(1 downto 0);
					 state <= IMMEDIATE_NUMBER;

            -- Estado de número imediato (IMMEDIATE_NUMBER)
            when IMMEDIATE_NUMBER =>
					 if oper1 = "11" or oper2 = "11" then
						address <= programCounter;
						programCounter <= STD_LOGIC_VECTOR(unsigned(programCounter) + 1);

						immediateNumber <= q;
					 end if;
                state <= IDLE;

				when IDLE =>
						state <= READ_MEM;
            when others =>
        end case;
    end if;
end process;

end Behavioral;