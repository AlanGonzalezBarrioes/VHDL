library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
  
entity siete_segmentos is
    PORT (
        A: IN  STD_LOGIC_VECTOR(3 downto 0);
        Z : OUT STD_LOGIC_VECTOR(6 downto 0)
    );
end siete_segmentos;
  
architecture Behavioral of siete_segmentos is
begin
	process(A)
	begin
		case(A) is
			when "0000" is => Z <= "0000001"; --0
			when "0001" is => Z <= "1001111"; --1
			when "0010" is => Z <= "0010010"; --2
			when "0011" is => Z <= "0000110"; --3
			when "0100" is => Z <= "1001100"; --4
			when "0101" is => Z <= "0100100"; --5
			when "0110" is => Z <= "0100000"; --6
			when "0111" is => Z <= "0001111"; --7
			when "1000" is => Z <= "0000000"; --8
			when "1001" is => Z <= "0000100"; --9
		end case;
	end process;
end behavioral;