library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity output_unit is
    Port ( 
        clk     : in  STD_LOGIC;
        reg     : in  STD_LOGIC_VECTOR(7 downto 0);
        output  : out STD_LOGIC_VECTOR(7 downto 0)
    );
end output_unit;

architecture Behavioral of output_unit is
    
begin   
    
    process(clk)
    begin
        if rising_edge(clk) then
            for i in 0 to 7 loop
                output(i) <= reg(i);  -- Atribui o valor de cada bit de reg a output
            end loop;
        end if;
    end process;
    
end Behavioral;
