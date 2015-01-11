
--Group 19
--Frank Luong 260481340
--Jeffrey Leung 260402139



library ieee; 
use ieee.std_logic_1164.all;
library lpm; 
use lpm.lpm_components.all;

entity counter is
port ( 
enable, clk, reset : in std_logic;
up_enable : out std_logic);

end counter;

Architecture g19_counter of counter is
signal count_out : std_logic_vector(10 downto 0);
signal sloadz: std_logic;

begin
	--COUNTER
	lpm_counter_component : lpm_counter
	GENERIC MAP (
		lpm_direction => "DOWN",
		lpm_port_updown => "PORT_UNUSED",
		lpm_type => "LPM_COUNTER",
		lpm_width => 11
	)
	PORT MAP (
		sload => sloadz,
		aclr => reset,
		clock => clk,
		data => "10000000000",
		cnt_en => '1',
		q => count_out
	);
	


	--NOR gate
	With count_out select
		sloadz <= '1' when "00000000000",
				'0' when others;
	
	
		


up_enable<=sloadz;

end g19_counter;
