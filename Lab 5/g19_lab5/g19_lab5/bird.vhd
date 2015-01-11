--27/11/2013
--Group 19
--Frank Luong 260481340
--Jeffrey Leung 260402139

library ieee; -- allows use of the std_logic_vector type
use ieee.std_logic_1164.all;
library lpm; -- allows use of the Altera library modules
use lpm.lpm_components.all;
entity bird is
port ( clock : in std_logic;
input_value : in std_logic_vector(7 downto 0);
out_put : out std_logic_vector(15 downto 0));
end bird;

architecture angry of bird is
begin

crc_table : lpm_rom -- use the altera rom library macrocell
GENERIC MAP(
lpm_widthad => 8, -- sets the width of the ROM address bus
lpm_numwords => 255, -- sets the words stored in the ROM
lpm_outdata => "UNREGISTERED", -- no register on the output
lpm_address_control => "REGISTERED", -- register on the input
lpm_file => "angry_bird.mif", -- the ascii file containing the ROM data
lpm_width => 16) -- the width of the word stored in each ROM location
PORT MAP(inclock => clock, address => input_value, q => out_put);
end angry;