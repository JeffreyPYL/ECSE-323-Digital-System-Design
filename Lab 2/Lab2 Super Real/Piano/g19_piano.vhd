library ieee; -- allows use of the std_logic_vector type
use ieee.std_logic_1164.all;
library lpm; -- allows use of the Altera library modules
use lpm.lpm_components.all;
entity g19_piano is
port ( note_number : in std_logic_vector(3 downto 0);
pitch_period : out std_logic_vector(19 downto 0));
end g19_piano;

architecture implementation1 of g19_piano is

begin
with note_number select
	pitch_period <= 
		
"10111010101000100011" when "0000",
"10110000001010001001" when "0001",
"10100110010001011000" when "0010",
"10011100111100001000" when "0011",
"10010100001000011001" when "0100",
"10001011110100010011" when "0101",
"10000011111110000100" when "0110",
"01111100100100000001" when "0111",
"01110101100100100101" when "1000",
"01101110111110010001" when "1001",
"01101000101111101001" when "1010",
"01100010110111011001" when "1011",

"11111111111111111111" when others;


end implementation1;