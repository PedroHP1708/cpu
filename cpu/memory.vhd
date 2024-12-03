--Leitura do arquivo está funcionando 

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

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

architecture Behaviour OF memory is
	type memory is array(0 to 255) of STD_LOGIC_VECTOR(7 downto 0);

	impure function read_mem return memory is 
		file text_file : text open read_mode is "ram256x8.hex";
		variable ram_content : memory;
		variable text_line : line;
	begin
		for i in 0 to 255 loop
			readline(text_file, text_line);
			hread(text_line, ram_content(i));
		end loop;
		  
		return ram_content;
	end function;

	signal mem : memory := read_mem;
begin

	process (clock)
	begin
		if rising_edge(clock) then
			if wren = '1' then
				mem(to_integer(unsigned(address))) <= data;			
			end if;
		end if;
	end process;

	q <= mem(to_integer(unsigned(address)));
end Behaviour;