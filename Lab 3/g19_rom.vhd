-- this circuit computes the sine(x)
--
-- entity name: g19_sine
--
-- Copyright (C) 2008 James Clark
-- Version 1.0
-- Author: James J. Clark; clark@cim.mcgill.ca
-- Date: September 9, 2013


--Group 19
--Frank Luong 260481340
--Jeffrey Leung 260402139


library ieee; -- allows use of the std_logic_vector type
use ieee.std_logic_1164.all;
library lpm; -- allows use of the Altera library modules
use lpm.lpm_components.all;
entity g19_rom is
port ( bpm : in std_logic_vector(7 downto 0);
clk : in std_logic;
out_mif : out std_logic_vector(23 downto 0));
end g19_rom;

architecture g19_lab3OutMif of g19_rom is
begin

crc_table : lpm_rom -- use the altera rom library macrocell
GENERIC MAP(
lpm_widthad => 8, -- sets the width of the ROM address bus
lpm_numwords => 256, -- sets the words stored in the ROM
lpm_outdata => "UNREGISTERED", -- no register on the output
lpm_address_control => "REGISTERED", -- register on the input
lpm_file => "g19_lab3.mif", -- the ascii file containing the ROM data
lpm_width => 24) -- the width of the word stored in each ROM location
PORT MAP(inclock => clk, address => bpm, q => out_mif);
end g19_lab3OutMif;