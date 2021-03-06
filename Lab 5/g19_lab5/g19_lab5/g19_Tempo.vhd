--27/11/2013
--Group 19
--Frank Luong 260481340
--Jeffrey Leung 260402139







Library ieee;
use ieee.std_logic_1164.all;
Library lpm;
use lpm.lpm_components.all;

entity g19_tempo is
port ( bpm : in std_logic_vector(7 downto 0);
clk, reset : in std_logic;
beat_gate : out std_logic_vector(0 downto 0);
tempo_enable : out std_logic);
end g19_tempo;

architecture g19_piano of g19_tempo is
signal out_mif, out_counter: std_logic_vector(23 downto 0);
signal out_12modulo: std_logic_vector(3 downto 0);
signal outNOR,outNOR2, inMux, inMux2, enout: std_logic;
signal beat_gate1, tempo_enable1: std_logic;
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


--counter
	lpm_counter_component1 : lpm_counter
	GENERIC MAP (
		lpm_direction => "DOWN",
		lpm_port_updown => "PORT_UNUSED",
		lpm_type => "LPM_COUNTER",
		lpm_width => 24
	)
	PORT MAP (
		
		sload => enout,
		aclr => not reset,
		clock => clk,
		data => out_mif,--"000000000000000000101001",--out_mif,
		q => out_counter
	);
	
--24 to 1 MUX
	with out_counter select
		inMux <= '0' when "000000000000000000000000",
				 '1' when others;

--NOT gate
	enout <= not inMux;
	
--modulo-12 counter
		lpm_counter_component2 : lpm_counter
	GENERIC MAP (
		lpm_direction => "DOWN",
		--lpm_modulus => 12,
		lpm_port_updown => "PORT_UNUSED",
		lpm_type => "LPM_COUNTER",
		lpm_width => 4
	)
	PORT MAP (
		sload => tempo_enable1,
		aclr => not reset,
		clock => clk,
		data => "1100",
		cnt_en => enout, 
		q => out_12modulo		
	);
	
--24 to 1 MUX
	with out_12modulo select
		inMux2 <= '0' when "0000",
				  '1' when others;

--NOT gate
	tempo_enable1 <= not inMux2;

--Flip-Flop
	lpm_ff_component : lpm_ff
	GENERIC MAP (
		lpm_fftype => "TFF",
		lpm_type => "LPM_FF",
		lpm_width => 1
	)
	PORT MAP (
		enable => tempo_enable1,
		aclr => not reset,
		clock => clk,
		q => beat_gate
	);
	tempo_enable <= enout;

end g19_piano;
