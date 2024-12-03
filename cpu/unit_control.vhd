library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unit_control is
    port (
        options    : in  std_logic_vector(3 downto 0);  -- Comando de 4 bits para a ULA
        inputs		 : in  std_logic_vector(7 downto 0);
		  reg1       : in  std_logic_vector(1 downto 0);  -- Sinal de controle (ex: valor do primeiro operando)
        reg2       : in  std_logic_vector(1 downto 0);  -- Outro sinal de controle (ex: valor do segundo operando)
        imNu		 : in  std_logic_vector(7 downto 0);
		  addr       : in  std_logic_vector(7 downto 0) := "00000000";  -- Endereço de memória e questão
        clk        : in  std_logic;                     -- Sinal de controle (ex: clock ou start)
        previousOp : out std_logic_vector(3 downto 0);  -- Operação anterior (para controle)
        -- Registradores para serem atualizados
        regA       : out std_logic_vector(7 downto 0);  -- Registrador A
        regB       : out std_logic_vector(7 downto 0);  -- Registrador B
        regR       : out std_logic_vector(7 downto 0);  -- Registrador R
        regImmediate : out std_logic_vector(7 downto 0); -- Registrador Immediate
		  outputs	 : out std_logic_vector(7 downto 0)
    );
end unit_control;

architecture Behavioral of unit_control is
    -- Definindo as operações da ULA
    constant oADD   : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    constant oSUB   : STD_LOGIC_VECTOR (3 downto 0) := "0001";
    constant oAND   : STD_LOGIC_VECTOR (3 downto 0) := "0010";
    constant oOR    : STD_LOGIC_VECTOR (3 downto 0) := "0011";
    constant oNOT   : STD_LOGIC_VECTOR (3 downto 0) := "0100";
    constant oCMP   : STD_LOGIC_VECTOR (3 downto 0) := "0101";
    constant oJMP   : STD_LOGIC_VECTOR (3 downto 0) := "0110";
    constant oJEQ   : STD_LOGIC_VECTOR (3 downto 0) := "0111";
    constant oJGR   : STD_LOGIC_VECTOR (3 downto 0) := "1000";
    constant oLOAD  : STD_LOGIC_VECTOR (3 downto 0) := "1001";
    constant oSTORE : STD_LOGIC_VECTOR (3 downto 0) := "1010";
    constant oMOV   : STD_LOGIC_VECTOR (3 downto 0) := "1011";
    constant oIN    : STD_LOGIC_VECTOR (3 downto 0) := "1100";
    constant oOUT   : STD_LOGIC_VECTOR (3 downto 0) := "1101";

    -- Sinais internos para operandos e resultado da ULA
    signal r1, r2 	: std_logic_vector(7 downto 0);  -- operandos de 8 bits para a ULA
    signal res 		: std_logic_vector(7 downto 0);  -- Resultado da ULA
    signal operation : std_logic_vector(3 downto 0); -- Operação a ser realizada pela ULA
    signal overflow, carry_out : std_logic;         -- Sinais de overflow e carry_out

	 signal auxAddr	: std_logic_vector(7 downto 0) := addr;
	 signal data, q     : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	 signal wren : STD_LOGIC;
	 
    signal a, b, r  : std_logic_vector(7 downto 0) := "00000000"; -- Registradores internos

    -- Instanciando a ULA
    component ula is
        Port (
            a           : in  STD_LOGIC_VECTOR(7 downto 0);
            b           : in  STD_LOGIC_VECTOR(7 downto 0);
            operation   : in  STD_LOGIC_VECTOR(3 downto 0);
            result      : out STD_LOGIC_VECTOR(7 downto 0);
            flagOverflow : out STD_LOGIC;                     
            flagCarry   : out STD_LOGIC  
        );
    end component;
    
    -- Instanciando a memória
    component Memory is
			Port (
				clock			: IN STD_LOGIC  := '1';
				data			: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
				address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
				wren			: IN STD_LOGIC  := '1';
				q				: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
			);
		end component;
	 
	 component input_unit is
    Port (
		  clk : in std_logic;
        enable  : in  STD_LOGIC;            -- Sinal de controle para ativar a leitura
        input   : in  STD_LOGIC_VECTOR(7 downto 0);
        reg_in  : out STD_LOGIC_VECTOR(7 downto 0)
    );
	end component;

begin
    -- Processo de controle da unidade de controle
    process (clk)
    begin
        if rising_edge(clk) then
            -- Determinar a operação com base em 'options' (comando da ULA)
            case options is
                when oADD =>  -- ADD
                    operation <= oADD;
						  if     reg1 = "00" then r1 <= a;
						  elsif  reg1 = "01" then r1 <= b;
						  elsif  reg1 = "10" then r1 <= r;
						  elsif  reg1 = "11" then r1 <= imNu;
						  end if;
						  if     reg2 = "00" then r2 <= a;
						  elsif  reg2 = "01" then r2 <= b;
						  elsif  reg2 = "10" then r2 <= r;
						  elsif  reg2 = "11" then r2 <= imNu;
						  end if;
						  r <= res;
						  auxAddr <= addr;

                when oSUB =>  -- SUB
                    operation <= oSUB;
						  if     reg1 = "00" then r1 <= a;
						  elsif  reg1 = "01" then r1 <= b;
						  elsif  reg1 = "10" then r1 <= r;
						  elsif  reg1 = "11" then r1 <= imNu;
						  end if;
						  if     reg2 = "00" then r2 <= a;
						  elsif  reg2 = "01" then r2 <= b;
						  elsif  reg2 = "10" then r2 <= r;
						  elsif  reg2 = "11" then r2 <= imNu;
						  end if;
						  r <= res;
						  auxAddr <= addr;	
						  
                when oAND =>  -- AND
                    operation <= oAND;
						  if     reg1 = "00" then r1 <= a;
						  elsif  reg1 = "01" then r1 <= b;
						  elsif  reg1 = "10" then r1 <= r;
						  elsif  reg1 = "11" then r1 <= imNu;
						  end if;
						  if     reg2 = "00" then r2 <= a;
						  elsif  reg2 = "01" then r2 <= b;
						  elsif  reg2 = "10" then r2 <= r;
						  elsif  reg2 = "11" then r2 <= imNu;
						  end if;
						  r <= res;
						  auxAddr <= addr;	
						  
                when oOR =>   -- OR
                    operation <= oOR;
						  if     reg1 = "00" then r1 <= a;
						  elsif  reg1 = "01" then r1 <= b;
						  elsif  reg1 = "10" then r1 <= r;
						  elsif  reg1 = "11" then r1 <= imNu;
						  end if;
						  if     reg2 = "00" then r2 <= a;
						  elsif  reg2 = "01" then r2 <= b;
						  elsif  reg2 = "10" then r2 <= r;
						  elsif  reg2 = "11" then r2 <= imNu;
						  end if;
						  r <= res;
						  auxAddr <= addr;	
						  
                when oNOT =>  -- NOT
                    operation <= oNOT;
						  if     reg1 = "00" then r1 <= a;
						  elsif  reg1 = "01" then r1 <= b;
						  elsif  reg1 = "10" then r1 <= r;
						  elsif  reg1 = "01" then r1 <= imNu;
						  end if;
						  r <= res;
						  
                when oCMP =>  -- CMP
                    operation <= oCMP;
                when oJMP =>  -- JMP
                    operation <= oJMP;
						  auxaddr <= addr;
                when oJEQ =>  -- JEQ
                    operation <= oJEQ;
                when oJGR =>  -- JGR
                    operation <= oJGR;
                when oLOAD => -- LOAD
                    operation <= oLOAD;
                when oSTORE => -- STORE
                    operation <= oSTORE;
                when oMOV =>  -- MOV
							operation <= oMOV;
							if reg1 = "00" and reg2 = "00" then
								a <= a;
							elsif reg1 = "00" and reg2 = "01" then
								a <= b;
							elsif reg1 = "00" and reg2 = "10" then
								a <= r;
							elsif reg1 = "00" and reg2 = "11" then
								a <= imNu;
							elsif reg1 = "01" and reg2 = "00" then
								b <= a;
							elsif reg1 = "01" and reg2 = "01" then
								b <= b;
							elsif reg1 = "01" and reg2 = "10" then
								b <= r;
							elsif reg1 = "01" and reg2 = "11" then
								b <= imNu;
							elsif reg1 = "10" and reg2 = "00" then
								r <= a;
							elsif reg1 = "10" and reg2 = "01" then
								r <= b;
							elsif reg1 = "10" and reg2 = "10" then
								r <= r;
							elsif reg1 = "10" and reg2 = "11" then
								r <= imNu;
							end if;	
						  
                when oIN =>  -- IN
                    operation <= oIN;
						  if     reg1 = "00" then a <= inputs;
						  elsif  reg1 = "01" then b <= inputs;
						  elsif  reg1 = "10" then r <= inputs;
						  end if;
						  
                when oOUT =>  -- OUT
                    operation <= oOUT;
						  if     reg1 = "00" then outputs <= a;
						  elsif  reg1 = "01" then outputs <= b;
						  elsif  reg1 = "10" then outputs <= r;
						  end if;
						  
                when others => -- NOP (sem operação)
                    operation <= "1111"; -- No operation
            end case;

            -- Atualiza o sinal de controle 'previousOp' com a operação atual
            previousOp <= options;
				regA <= a;
				regB <= b;
				regR <= r;
        end if;
    end process;

    -- Instanciando a ULA
    ula_inst : ula
        port map (
            a => r1,
            b => r2,
            operation => operation,
            result => res,
            flagOverflow => overflow,
            flagCarry => carry_out
        );
		  
	ram : memory
		port map(
			clock => clk,
			data	=> data,
			address => auxAddr,
			wren => wren,
			q => q
		);

end Behavioral;
