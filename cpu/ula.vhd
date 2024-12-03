-- ULA funcional

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ula is
    Port (
        a               : in  STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit input 'a' (bit 7 é o sinal)
        b               : in  STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit input 'b' (bit 7 é o sinal)
        operation       : in  STD_LOGIC_VECTOR(3 downto 0);  -- Operation selector
        result          : buffer STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit result
        flagOverflow    : out STD_LOGIC;                     
        flagCarry       : out STD_LOGIC;
        flagZero        : out STD_LOGIC;  -- Flag Zero
        flagSignal      : out STD_LOGIC   -- Flag Signal (Sinal)
    );
end ula;

architecture Behavioral of ula is
begin
    process(a, b, operation)
        variable sum     : signed(7 downto 0);   -- Variáveis com 8 bits (incluindo o bit de sinal)
        variable dif     : signed(7 downto 0);   -- Variáveis com 8 bits
        variable res     : STD_LOGIC_VECTOR(7 downto 0);  -- Variável para armazenar o resultado de 8 bits
    begin
        case operation is
            -- ADD operation (Soma)
            when "0000" =>
                sum := signed(a) + signed(b);  -- Soma no formato complemento de dois
                res := std_logic_vector(sum(7 downto 0));  -- Atribui o resultado de 8 bits

                -- Verificação de Overflow na soma
                if (a(7) = '0' and b(7) = '0' and res(7) = '1') or (a(7) = '1' and b(7) = '1' and res(7) = '0') then
                    flagOverflow <= '1';
                else
                    flagOverflow <= '0';
                end if;

                -- Truncando o resultado para 8 bits
                result <= res;

                -- Flag Zero
                if res = "00000000" then
                    flagZero <= '1';
                else
                    flagZero <= '0';
                end if;

                -- Flag Sinal
                flagSignal <= res(7);  -- O bit mais significativo (bit 7) representa o sinal

            -- SUB operation (Subtração)
            when "0001" =>
                dif := signed(a) - signed(b);  -- Subtração de números com sinal

                -- Convertendo o resultado de volta para std_logic_vector
                res := std_logic_vector(dif);  -- Armazena o resultado de 8 bits

                -- Verificação de Carry (borrow) 
                -- Em uma subtração de números naturais, o Carry ocorre se houve "borrow"
                if unsigned(a) < unsigned(b) then
                    flagCarry <= '1';  -- Houve um "borrow"
                else
                    flagCarry <= '0';  -- Não houve borrow
                end if;

                -- Truncando o resultado para 8 bits
                result <= res;

                -- Flag Zero
                if res = "00000000" then
                    flagZero <= '1';  -- Resultado é zero
                else
                    flagZero <= '0';  -- Caso contrário
                end if;

                -- Flag Sinal
                flagSignal <= res(7);  -- O bit mais significativo (bit 7) representa o sinal

            -- AND operation
            when "0010" =>
                res := a and b;  -- AND entre os dois vetores de 8 bits
                flagCarry <= '0';
                flagOverflow <= '0';
                flagZero <= '0';
                result <= res;
                flagSignal <= res(7);  -- Flag Sinal

            -- OR operation
            when "0011" =>
                res := a or b;  -- OR entre os dois vetores de 8 bits
                flagCarry <= '0';
                flagOverflow <= '0';
                flagZero <= '0';
                result <= res;
                flagSignal <= res(7);  -- Flag Sinal

            -- NOT operation
            when "0100" =>
                res := not a;  -- NOT do vetor 'a'
                flagCarry <= '0';
                flagOverflow <= '0';
                flagZero <= '0';
                result <= res;
                flagSignal <= res(7);  -- Flag Sinal

            when others =>
                res := "00000000";  -- Resultado nulo (no operation)
                flagCarry <= '0';
                flagOverflow <= '0';
                flagZero <= '0';
                flagSignal <= '0';
                result <= "00000000";  -- Resultado nulo

        end case;
    end process;
end Behavioral;
