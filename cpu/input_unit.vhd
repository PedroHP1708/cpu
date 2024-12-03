-- Comando de input funcionando

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity input_unit is
    Port (
		  clk : in std_logic;
        enable  : in  STD_LOGIC;            -- Sinal de controle para ativar a leitura
        input   : in  STD_LOGIC_VECTOR(7 downto 0);
        reg_in  : out STD_LOGIC_VECTOR(7 downto 0)
    );
end input_unit;

architecture Behavioral of input_unit is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if enable = '1' then             -- Verifica se o sinal de enable está ativo
                reg_in <= input;             -- Realiza a leitura
            end if;
        end if;
    end process;
end Behavioral;
