
--Group 19
--Frank Luong 260481340
--Jeffrey Leung 260402139


Library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
library lpm;
use lpm.lpm_components.all;



entity g19_note_timer is 
port ( 
	clk, reset : in std_logic;
	note_duration : in std_logic_vector(2 downto 0);
	triplet : in std_logic;
	tempo_enable : in std_logic;
	GATE : out std_logic);
end g19_note_timer;

 architecture g19_timer of g19_note_timer is
 signal count, half :integer;
 signal n :integer:=0;
 
 begin
 
 
 
 -- the transfer table of note duration to tempo enable pulse 
count <= 
	3 when (note_duration = "000" and triplet = '0') else
	6 when note_duration = "001" and triplet = '0' else
	12 when note_duration = "010" and triplet = '0' else
	24 when note_duration = "011"and triplet = '0' else
	48 when note_duration = "100"and triplet = '0' else
	96 when note_duration = "101"and triplet = '0' else
	192 when note_duration = "110"and triplet = '0' else
	384 when note_duration = "111"and triplet = '0' else
	----------Triple = 1-------------------------------
	2 when note_duration = "000" and triplet = '1' else
	4 when note_duration = "001" and triplet = '1' else
	8 when note_duration = "010" and triplet = '1' else
	16 when note_duration = "011"and triplet = '1' else
	32 when note_duration = "100"and triplet = '1' else
	64 when note_duration = "101"and triplet = '1' else
	128 when note_duration = "110"and triplet = '1' else
	256 when note_duration = "111"and triplet = '1';

half <= count/2; -- half of the count
counter1: process(clk,reset)
begin
--note n is the count within the process block
if reset = '1'then
	GATE <= '1'; -- when reset = 1, gate = 1 and count = 0
	n <= 0;
elsif clk = '1' and clk'event then

	if(tempo_enable = '1') then
		n <= n+1;	-- adding on to the count 
	end if;

	if(n >= (count-1) ) then
		GATE <= '1'; --when count reach the top
		n <= 0;
	elsif(n >= half) then
		GATE <= '0'; -- when the count reach half of itself
	else
		GATE <= '1';
	end if;
	
	
	
end if;
end process;	

	
 
 end g19_timer;