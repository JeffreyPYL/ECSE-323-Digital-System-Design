--27/11/2013
--Group 19
--Frank Luong 260481340
--Jeffrey Leung 260402139
Library ieee;
use ieee.std_logic_1164.all;
Library lpm;
use lpm.lpm_components.all;



entity g19_Envelope is
	port(
		RISE_RATE, FALL_RATE : in std_logic_vector(7 downto 0);
		clk, reset	: in std_logic;
		GATE : in std_logic;
		ENVELOP : out std_logic_vector(7 downto 0)--;
		--UPDATE_ENABLE : in std_logic
		);
		
end g19_Envelope;

architecture part2 of g19_Envelope is
signal mux2_out,mux1_out, envelope, sub_res :std_logic_vector(7 downto 0);
signal  mult_out,env_out,env_out2, new2:std_logic_vector (23 downto 0);
signal UPDATE_ENABLE1, ncount : std_logic;
signal count_out : std_logic_vector(10 downto 0);


--busMux1
component mux7
	PORT
	(
		data0x		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		data1x		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		sel		: IN STD_LOGIC ;
		result		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
end component;

begin


	
	
lpm_counter_component : lpm_counter
	GENERIC MAP (
		lpm_direction => "DOWN",
		lpm_port_updown => "PORT_UNUSED",
		lpm_type => "LPM_COUNTER",
		lpm_width => 11
	)
	PORT MAP (
		sload => UPDATE_ENABLE1,
		aclr => reset,
		clock => clk,
		data => "10000000000",
		cnt_en => '1',
		q => count_out
	);



	-- mux
	
	
with count_out select
	ncount <= '0' when "00000000000",
				 '1' when others;
UPDATE_ENABLE1 <= not ncount;


--mux1
Gate1: mux7 
port map(
	data0x => envelope,
	data1x => sub_res,
	sel =>  GATE,
	result => mux1_out
	);



--substraction
	LPM_SUB_component : LPM_ADD_SUB
	GENERIC MAP (
		lpm_direction => "SUB",
		lpm_hint => "ONE_INPUT_IS_CONSTANT=NO,CIN_USED=NO",
		lpm_representation => "UNSIGNED",
		lpm_type => "LPM_ADD_SUB",
		lpm_width => 8
	)
	
	PORT MAP (
		dataa => "11111111",--255
		datab => envelope,
		result => sub_res
	);
	


--Mux for rise and fall rate
Gate2: mux7 port map(
	
	data0x => FALL_RATE,
	data1x => RISE_RATE,
	sel =>  GATE,
	result => mux2_out );

--multiplication
		lpm_mult_component : lpm_mult
	GENERIC MAP (
		lpm_hint => "MAXIMIZE_SPEED=5",
		lpm_representation => "UNSIGNED",
		lpm_type => "LPM_MULT",
		lpm_widtha => 8,
		lpm_widthb => 8,
		lpm_widthp => 24
	)
	PORT MAP (
		dataa => mux1_out,
		datab => mux2_out,
		result => mult_out
	);
	
--addition

		LPM_ADD_SUB_component : LPM_ADD_SUB
	GENERIC MAP (
		lpm_direction => "UNUSED",
		lpm_hint => "ONE_INPUT_IS_CONSTANT=NO,CIN_USED=NO",
		lpm_representation => "UNSIGNED",
		lpm_type => "LPM_ADD_SUB",
		lpm_width => 24
	)
	PORT MAP (
		dataa => env_out2,
		add_sub =>  GATE,
		datab => mult_out,
		result => env_out
	);
	

				
-- TFF for register

	lpm_ff_component : lpm_ff
	GENERIC MAP (
		lpm_fftype => "DFF",
		lpm_type => "LPM_FF",
		lpm_width => 24
	)
	PORT MAP (
		enable => UPDATE_ENABLE1,
		sclr => reset,
		clock => clk,
		data => env_out,
		q => env_out2
	);
	


ENVELOP <= env_out2(23 downto 16);
envelope <= env_out2(23 downto 16);
end part2;