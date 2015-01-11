Library ieee;
use ieee.std_logic_1164.all;
Library lpm;
use lpm.lpm_components.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;


entity compares is
   port (env_24: in std_logic_vector(7 downto 0);
		 L0, L1, L2,L3,L4,L5,L6,L7,L8,L9: out std_logic);
end compares;

architecture compare_19 of compares is

begin 

L0 <= '1' when env_24 > "00011001" else '0';
L1 <= '1' when env_24 > "00110010" else '0';
L2 <= '1' when env_24 > "01001011" else '0';
L3 <= '1' when env_24 > "01100100" else '0';
L4 <= '1' when env_24 > "01111101" else '0';
L5 <= '1' when env_24 > "10010110" else '0';
L6 <= '1' when env_24 > "10101111" else '0';
L7 <= '1' when env_24 > "11001000" else '0';
L8 <= '1' when env_24 > "11100001" else '0';
L9 <= '1' when env_24 > "11111010" else '0';


end compare_19;