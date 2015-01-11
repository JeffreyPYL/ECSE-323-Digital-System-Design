-- this circuit computes the sine(x)
--
-- entity name: g19_sine
--
-- Copyright (C) 2008 James Clark
-- Version 1.0
-- Author: James J. Clark; clark@cim.mcgill.ca
-- Date: September 9, 2013
library ieee; -- allows use of the std_logic_vector type
use ieee.std_logic_1164.all;
library lpm; -- allows use of the Altera library modules
use lpm.lpm_components.all;
entity sine is
port ( clock : in std_logic;
input_value : in std_logic_vector(6 downto 0);
sine : out std_logic_vector(15 downto 0));
end sine;

architecture g19_sinSimulation of sine is
begin

crc_table : lpm_rom -- use the altera rom library macrocell
GENERIC MAP(
lpm_widthad => 7, -- sets the width of the ROM address bus
lpm_numwords => 128, -- sets the words stored in the ROM
lpm_outdata => "UNREGISTERED", -- no register on the output
lpm_address_control => "REGISTERED", -- register on the input
lpm_file => "sine1.mif", -- the ascii file containing the ROM data
lpm_width => 16) -- the width of the word stored in each ROM location
PORT MAP(inclock => clock, address => input_value, q => sine);
end g19_sinSimulation;