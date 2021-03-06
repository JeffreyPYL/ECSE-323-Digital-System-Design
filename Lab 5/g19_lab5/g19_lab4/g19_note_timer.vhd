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
 signal count,n :integer;
 
 begin
 
 
 
 
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


counter1: process(clk,reset)
begin
	if(tempo_enable = '1') then
		n <= n+1;
	end if;
	
	if(n >= (count-1)) then
		GATE <= '1';
		n <= 0;
	elsif(n >= (count/2)) then
		GATE <= '0';
	else
		GATE <= '1';
	end if;
	end process;	

	
 
 end g19_timer;