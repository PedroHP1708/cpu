library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity display_7seg is
    port (
        input_disp : in STD_LOGIC_VECTOR (3 downto 0);
        output_disp : out STD_LOGIC_VECTOR (6 downto 0)
    );
end entity display_7seg;

architecture Behaviour of display_7seg is

begin
    process (input_disp)
    begin
        case input_disp is
            when "0000" => output_disp <= "1000000";     
				when "0001" => output_disp <= "1111001";  
				when "0010" => output_disp <= "0100100";  
				when "0011" => output_disp <= "0110000";  
				when "0100" => output_disp <= "0011001";  
				when "0101" => output_disp <= "0010100"; 
				when "0110" => output_disp <= "0000100"; 
				when "0111" => output_disp <= "1111000";  
				when "1000" => output_disp <= "0000000";      
				when "1001" => output_disp <= "0010000"; 
				when "1010" => output_disp <= "0100000"; 
				when "1011" => output_disp <= "0000011"; 
				when "1100" => output_disp <= "1000110"; 
				when "1101" => output_disp <= "0100001"; 
				when "1110" => output_disp <= "0000110"; 
				when "1111" => output_disp <= "0001110";
				when others => output_disp <= "0000000";
            end case;
    end process;
end architecture;