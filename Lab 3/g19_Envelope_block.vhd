
--Lab3
--Frank Luong 260481340
--Jeffrey Leung 260402139
--The entity is from the description of lab3 (page 19)
Library ieee;
use ieee.std_logic_1164.all;
Library lpm;
use lpm.lpm_components.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;


entity g19_Envelope is
	port(
		RISE_RATE, FALL_RATE : in std_logic_vector(7 downto 0);
		clk, reset	: in std_logic;
		--UPDATE_ENABLE 
		GATE : in std_logic;
		ENVELOP : out std_logic_vector(7 downto 0);
		UPDATE_ENABLE, l0,l1,l2,l3,l4,l5,l6,l7,l8,l9 : out std_logic);
end g19_Envelope;

architecture part2 of g19_Envelope is
signal mux2_out :std_logic_vector(7 downto 0);
signal mux1_out, envelope, sub_res: std_logic_vector(7 downto 0);
signal  mult_out, env_unsign:std_logic_vector (23 downto 0);
signal env_out,env_out2, new2, env: std_LOGIC_VECTOR(23 downto 0);
signal m :std_LOGIC_VECTOR(23 downto 0);
signal countDown, count_out : std_logic_vector (10 downto 0);
signal UPDATE_ENABLE1, ncount : std_logic;
signal mult_outTEST: std_logic_vector (2 downto 0);
signal r_out : std_logic_vector (0 downto 0);
--busMux1
component mux1
	PORT
	(
		clken		: IN STD_LOGIC  := '1';
		clock		: IN STD_LOGIC ;
		data0x		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		data1x		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		sel		: IN STD_LOGIC ;
		result		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
end component;
begin
GATE <= not GATE;
--countDown <= "10000000000";

-- frequency divider
	--counter
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

	-- TFF
--lpm_ff_component : lpm_ff
--	GENERIC MAP (
--		lpm_fftype => "TFF",
--		lpm_type => "LPM_FF",
--		lpm_width => 1
--	)
--	PORT MAP (
--		enable => s,
--		aclr => reset,
--		clock => clk,
--		q => r_out
--	);


--mux1
Gate1: mux1 port map(
	clken => '1',
	clock => clk,
	data0x => envelope,
	data1x => sub_res,
	sel => GATE,
	result => mux1_out);



--substraction
	lpm_sub_component : lpm_add_sub
	GENERIC MAP (
		lpm_direction => "SUB",
		lpm_hint => "ONE_INPUT_IS_CONSTANT=NO,CIN_USED=NO",
		lpm_pipeline => 1,
		lpm_representation => "UNSIGNED",
		lpm_type => "LPM_ADD_SUB",
		lpm_width => 8
	)
	
	PORT MAP (
		dataa => "11111111",--255
		datab => envelope,
		clock => clk,
		result => sub_res
	);
	


--Mux for rise and fall rate
Gate2: mux1 port map(
	clken => '1',
	clock => clk,
	data0x => FALL_RATE,
	data1x => RISE_RATE,
	sel => GATE,
	result => mux2_out );

--multiplication
	lpm_mult_component : lpm_mult
	GENERIC MAP (
		lpm_hint => "MAXIMIZE_SPEED=5",
		lpm_pipeline => 1,
		lpm_representation => "UNSIGNED",
		lpm_type => "LPM_MULT",
		lpm_widtha => 8,
		lpm_widthb => 8,
		lpm_widthp => 24
	)
	PORT MAP (
		dataa => mux1_out,
		datab => mux2_out,
		clock => clk,
		result => mult_out
	);
	
--addition
	lpm_add_sub_component : lpm_add_sub
	GENERIC MAP (
		lpm_direction => "UNUSED",
		lpm_hint => "ONE_INPUT_IS_CONSTANT=NO,CIN_USED=NO",
		lpm_pipeline => 1,
		lpm_representation => "UNSIGNED",
		lpm_type => "LPM_ADD_SUB",
		lpm_width => 24
	)
	PORT MAP (
		dataa => env_out,
		add_sub => GATE,
		datab => mult_out,
		clock => clk,
		result => env_out
	);
	
	new2 <= env_out;
	
--	with GATE select
--		new2 <= (not env_out) when '0',
--				env_out when '1';
				
				
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
		data => new2,
		q => env_out2
	);
	


ENVELOP <= env_out2(23 downto 16);
envelope <= env_out2(23 downto 16);
UPDATE_ENABLE <= UPDATE_ENABLE1;

	
--	board-25
	lpm_compare_component : lpm_compare
	GENERIC MAP (
		lpm_hint => "ONE_INPUT_IS_CONSTANT=YES",
		lpm_representation => "UNSIGNED",
		lpm_type => "LPM_COMPARE",
		lpm_width => 8
	)
	PORT MAP (
		dataa => envelope,
		datab => "00011001",
		AgB => l0
	);

lpm_compare_component50 : lpm_compare
	GENERIC MAP (
		lpm_hint => "ONE_INPUT_IS_CONSTANT=YES",
		lpm_representation => "UNSIGNED",
		lpm_type => "LPM_COMPARE",
		lpm_width => 8
	)
	PORT MAP (
		dataa => envelope,
		datab => "00110010",
		AgB => l1
	);

lpm_compare_component75 : lpm_compare
	GENERIC MAP (
		lpm_hint => "ONE_INPUT_IS_CONSTANT=YES",
		lpm_representation => "UNSIGNED",
		lpm_type => "LPM_COMPARE",
		lpm_width => 8
	)
	PORT MAP (
		dataa => envelope,
		datab => "01001011",
		AgB => l2
	);	
	
	lpm_compare_component100 : lpm_compare
	GENERIC MAP (
		lpm_hint => "ONE_INPUT_IS_CONSTANT=YES",
		lpm_representation => "UNSIGNED",
		lpm_type => "LPM_COMPARE",
		lpm_width => 8
	)
	PORT MAP (
		dataa => envelope,
		datab => "01100100",
		AgB => l3
	);	
	
	lpm_compare_component125 : lpm_compare
	GENERIC MAP (
		lpm_hint => "ONE_INPUT_IS_CONSTANT=YES",
		lpm_representation => "UNSIGNED",
		lpm_type => "LPM_COMPARE",
		lpm_width => 8
	)
	PORT MAP (
		dataa => envelope,
		datab => "01111101",
		AgB => l4
	);	
	
	lpm_compare_component150 : lpm_compare
	GENERIC MAP (
		lpm_hint => "ONE_INPUT_IS_CONSTANT=YES",
		lpm_representation => "UNSIGNED",
		lpm_type => "LPM_COMPARE",
		lpm_width => 8
	)
	PORT MAP (
		dataa => envelope,
		datab => "10010110",
		AgB => l5
	);	
	
	lpm_compare_component175 : lpm_compare
	GENERIC MAP (
		lpm_hint => "ONE_INPUT_IS_CONSTANT=YES",
		lpm_representation => "UNSIGNED",
		lpm_type => "LPM_COMPARE",
		lpm_width => 8
	)
	PORT MAP (
		dataa => envelope,
		datab => "10101111",
		AgB => l6
	);	
	
	lpm_compare_component200 : lpm_compare
	GENERIC MAP (
		lpm_hint => "ONE_INPUT_IS_CONSTANT=YES",
		lpm_representation => "UNSIGNED",
		lpm_type => "LPM_COMPARE",
		lpm_width => 8
	)
	PORT MAP (
		dataa => envelope,
		datab => "11001000",
		AgB => l7
	);	
	
	lpm_compare_component225 : lpm_compare
	GENERIC MAP (
		lpm_hint => "ONE_INPUT_IS_CONSTANT=YES",
		lpm_representation => "UNSIGNED",
		lpm_type => "LPM_COMPARE",
		lpm_width => 8
	)
	PORT MAP (
		dataa => envelope,
		datab => "11100001",
		AgB => l8
	);	
	
	lpm_compare_component250 : lpm_compare
	GENERIC MAP (
		lpm_hint => "ONE_INPUT_IS_CONSTANT=YES",
		lpm_representation => "UNSIGNED",
		lpm_type => "LPM_COMPARE",
		lpm_width => 8
	)
	PORT MAP (
		dataa => envelope,
		datab => "11111010",
		AgB => l9
	);	
	
end part2;