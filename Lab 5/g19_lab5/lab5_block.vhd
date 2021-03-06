--27/11/2013
--Group 19
--Frank Luong 260481340
--Jeffrey Leung 260402139
Library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
library lpm;
use lpm.lpm_components.all;


entity lab5_block is
 port (
		RF_change : in std_logic;
		p,l,songSwitch, restart: in std_logic; -- songSwitch when 0 song A else 1 for song B
		bpm: in std_logic_vector(7 downto 0);
		clock,clk24, reset1: in std_logic;
		LA,LB,LC,LD : out std_logic;
		L0, L1, L2,L3,L4,L5,L6,L7,L8,L9: out std_logic;
		beat : out std_logic_vector (0 downto 0);
		one,two,three,four : out std_logic_vector ( 6 downto 0);
		AUD_XCK :              OUT std_logic; -- codec master clock input
		AUD_BCLK :             OUT std_logic; -- digital audio bit clock
		AUD_DACDAT :           OUT std_logic; -- DAC data lines
		AUD_DACLRCK :          OUT std_logic; -- DAC data left/right select
		I2C_SDAT :             OUT std_logic; -- serial interface data line
		I2C_SCLK :             OUT std_logic  -- serial interface clock
  ); 
  end lab5_block;
  
  
 architecture g19_behavior of lab5_block is
signal RISE, FALL: std_logic_vector(7 downto 0);
signal connect_nToE, mute,tempo_enable1, FSM_enable,stop, triplet, reset_state: std_logic;
signal scount : integer;
signal multIn,count_out : std_logic_vector(7 downto 0);
signal outMult: std_logic_vector(22 downto 0);
signal volume : std_logic_vector (22 downto 0);
signal square_out, dec_out: signed(23 downto 0);
signal mif_out,bmif_out, smif_out : std_logic_vector (15 downto 0);
signal Note_Number, Loudness: std_logic_vector (3 downto 0);
signal Octave_Number, Note_Duration: std_logic_vector (2 downto 0);
TYPE State_type IS(A,B,C,D);
SIGNAL y: State_type;
--TEMPO
component g19_tempo 
	port ( bpm : in std_logic_vector(7 downto 0);
		clk, reset : in std_logic;
		beat_gate : out std_logic_vector(0 downto 0);
		tempo_enable : out std_logic);
end component;


--ENVELOPE COMPONENTS
component g19_Envelope
	PORT
	(
		RISE_RATE, FALL_RATE : in std_logic_vector(7 downto 0);
		clk, reset	: in std_logic;
		GATE : in std_logic;
		ENVELOP : out std_logic_vector(7 downto 0));
end component;
--NOTE TIMER COMPONENTS
component g19_note_timer
	PORT
	(clk, reset : in std_logic;
	note_duration : in std_logic_vector(2 downto 0);
	triplet : in std_logic;
	tempo_enable : in std_logic;
	GATE : out std_logic
		);
end component;
--SQUARE WAVE COMPONENTS
component g19_square_wave
	PORT
	(clk, reset : in std_logic; 
	note_number : in std_logic_vector(3 downto 0); 
	octave : in std_logic_vector(2 downto 0);
	volume : in unsigned(22 downto 0); 
	square : out signed(23 downto 0)
		);
end component;

-----------------------------------------
component g19_decimator
PORT
	(
		SR50MHz       : IN signed(23 downto 0);
		SR48KHz       : OUT signed(23 downto 0);
		clk, rst      : IN std_logic -- clk assumed to be 24MHz
	);
end component;



-----------------------------------------
component g19_audio_interface
PORT
	(	
		LDATA, RDATA	:      IN signed(23 downto 0); -- parallel external data inputs
		clk, rst, INIT, W_EN : IN std_logic; -- clk should be 24MHz
		AUD_XCK :              OUT std_logic; -- codec master clock input
		AUD_BCLK :             OUT std_logic; -- digital audio bit clock
		AUD_DACDAT :           OUT std_logic; -- DAC data lines
		AUD_DACLRCK :          OUT std_logic; -- DAC data left/right select
		I2C_SDAT :             OUT std_logic; -- serial interface data line
		I2C_SCLK :             OUT std_logic  -- serial interface clock
	);
end component;

----------------------------------------
-----------Sample mif file component----
----------------------------------------
component lab5_mif
port 
( clock : in std_logic;
input_value : in std_logic_vector(7 downto 0);
out_put : out std_logic_vector(15 downto 0)
);
end component;

----------------------------------------
-----angry_bird mif file component------
----------------------------------------

component bird
port 
( clock : in std_logic;
input_value : in std_logic_vector(7 downto 0);
out_put : out std_logic_vector(15 downto 0)
);
end component;

----------------------------------------
-----------compare component------------
----------------------------------------

component compares
  port 
  (env_24: in std_logic_vector(7 downto 0);
	L0, L1, L2,L3,L4,L5,L6,L7,L8,L9: out std_logic
		 );
end component;

----------------------------------------
--MUX component to choose mif file------
----------------------------------------

component mux3
PORT
	(
		data0x		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		data1x		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		sel		: IN STD_LOGIC ;
		result		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END component;



begin

-----------------------------------------------------------------------
-----------------------Fixed Rise and Fail Rate------------------------
-----------------------------------------------------------------------
with RF_change select 
RISE <= 
	"00000001" when '1',
	"11111111" when others;

with RF_change select 
FALL <= 
	"00000001" when '1',
	"11111111" when others;



------------------------------------------------------------------------
---------------TEMPO----------------------------------------------------
------------------------------------------------------------------------

tempo: g19_tempo
port map(
	bpm => bpm ,
	clk => clock,
	reset => reset1,
	beat_gate => beat,
	tempo_enable => tempo_enable1 
	
	);






------------------------------------------------------------------------
---------------NOTE TIMMER----------------------------------------------
------------------------------------------------------------------------

note: g19_note_timer
port map(
	clk => clock,
	reset => not reset1,
	note_duration => Note_Duration ,
	triplet =>Triplet ,
	tempo_enable => tempo_enable1  ,  
	GATE => connect_nToE
	);



------------------------------------------------------------------------
---------------COUNTER--------------------------------------------------
------------------------------------------------------------------------


	lpm_counter_component : lpm_counter
	GENERIC MAP (
		lpm_direction => "UP",
		lpm_port_updown => "PORT_UNUSED",
		lpm_type => "LPM_COUNTER",
		lpm_width => 8
	)
	PORT MAP (
		sclr => ((not reset1) or (reset_state)), -- the reset_state will reset the counter when it is in State A 
		clock => connect_nToE,
		cnt_en => FSM_enable, -- enable from FSM
		q => count_out-- connect to the selected mif file
	); 


	
----------------------------------------------------------------------
------------------Sample mif------------------------------------------
----------------------------------------------------------------------
mif1 : lab5_mif
port map(
	clock => clock,
	input_value => count_out,
	out_put => smif_out
	);
	
----------------------------------------------------------------------
---------------Angry Bird mif-----------------------------------------
----------------------------------------------------------------------	
	
angry_bird : bird
port map(
	clock => clock,
	input_value => count_out,
	out_put => bmif_out
	);

------------------------------------------------------------------------
---------------MUX for MIF----------------------------------------------
------------------------------------------------------------------------
mux: mux3
	PORT MAP (
		data0x => smif_out,
		data1x => bmif_out,
		sel => songSwitch,
		result => mif_out
	);
	
	
-----------------------------------------------------------------------
------------------Assignment for different varible from mif------------
-----------------------------------------------------------------------

stop <= mif_out(15);
triplet <= mif_out(10);
Note_Number <= mif_out(3 downto 0);
Loudness <= mif_out(14 downto 11);
Octave_Number <= mif_out(6 downto 4);
Note_Duration <= mif_out(9 downto 7);	

------------------------------------------------------------------------
---------------Finite State Machine-------------------------------------
------------------------------------------------------------------------


PROCESS(reset1, clock)

begin
		if reset1 = '0' or restart = '0' then 
			y <= A;
		elsif (clock'EVENT and clock ='1') then 
		if l = '1' then	-- display for loop mode and shot mode
				one <= "1000111";
				two <= "1000000";
				three <= "1000000";
				four <= "0001100";
			else
				one <= "0010010";
				two <= "0001011";
				three <= "0100011";
				four <= "0000111";
			end if;
		CASE y IS
			when A => -- start
				if p= '1'then 
					y <= C;
				elsif p='0' then 
					y <= B; 
				end if;

			when B => -- play
			if restart = '0' then y <= A;
			else
				if p= '1'then y <=C;
				elsif p ='0' and stop ='0' then y <= B;
				elsif stop= '1' then y <= D; -- stop after the last note is played
				end if;
			end if;

			when C => -- pause
			if restart = '0' then y <= A;
			else
		
				if p = '1' then y <= C; --need a if statment for switch song	
				elsif p='0' then y <= B;
				end if;
			end if;	
			when D => -- stop
			if restart = '0' then y <= A;
			else

			if l ='1' and p ='0' then 
					y <= A;
			else
					y <=D;
			end if;
		end if;
		end case;
		end if;
		
END PROCESS;


FSM_enable <=         -- only enable the counter when is in the play state
	'1' when y = B else
	'0';
mute <= 					-- mute when not playing
	'0' when (y = C or y = D) else
	'1';
reset_state <= 		-- reset and playback control when it is in state A
	'1' when y = A or y =D else
	'0';
	
LA <= '1' when y = A else '0';
LB <= '1' when y =B else '0';
LC <= '1' when y=C else '0';
LD <= '1' when y = D else '0';

	

------------------------------------------------------------------------
---------------ENVELOPE-------------------------------------------------
------------------------------------------------------------------------

env: g19_Envelope 
port map(
	RISE_RATE => RISE,
	FALL_RATE => FALL,
	clk =>  clock,
	reset => not reset1,
	GATE => connect_nToE,
	ENVELOP =>multIn
	);
	
----------------------------------------------------------------------
compare : compares
  port map(
	env_24 => multIn,
	L0 => L0, 
	L1 => L1,
	L2 => L2,
	L3 => L3,
	L4 => L4,
	L5 => L5,
	L6 => L6,
	L7 => L7,
	L8 => L8,
	L9 => L9
	);
	
------------------------------------------------------------------------
---------------MATHC FOR LOUDNESS---------------------------------------
------------------------------------------------------------------------	
	
	
with Loudness select    
	volume <= 
		
	"00000000000000011111111" when "0000",
	"00000000000000111111111" when "0001",
	"00000000000001111111111" when "0010",
	"00000000000011111111111" when "0011",
	"00000000000111111111111" when "0100",
	"00000000001111111111111" when "0101",
	"00000000011111111111111" when "0110",
	"00000000111111111111111" when "0111",
	"00000001111111111111111" when "1000",
	"00000011111111111111111" when "1001",
	"00000111111111111111111" when "1010",
	"00001111111111111111111" when "1011",
	"00011111111111111111111" when "1100",
	"00111111111111111111111" when "1101",
	"01111111111111111111111" when "1110",
	"11111111111111111111111" when others;
	
	lpm_mult_component : lpm_mult
	GENERIC MAP (
		lpm_hint => "MAXIMIZE_SPEED=5",
		lpm_representation => "UNSIGNED",
		lpm_type => "LPM_MULT",
		lpm_widtha => 8,
		lpm_widthb => 23,
		lpm_widthp => 23
	)
	PORT MAP (
		dataa => multIn,
		datab => volume,
		result => outMult -- volume x envelope output
	);


 square: g19_square_wave
port map(
	clk => clock,
	reset=> not reset1,
	note_number => Note_Number,
	octave => (Octave_Number),
	volume => unsigned(outMult),
	square => (square_out)
	);


decimat: g19_decimator
port map
	(
		SR50MHz  => square_out, -- input from square wave
		SR48KHz => dec_out,--output
		clk => clock,
		rst => not reset1
	);


audio : g19_audio_interface
port map
	(	
		LDATA => dec_out, 
		RDATA	=> dec_out,
		clk => clk24, --clk 24 MHZ
		rst => not reset1, 
		INIT => '1', 
		W_EN => mute,-- change to 0 when pause
		AUD_XCK => AUD_XCK,
		AUD_BCLK => AUD_BCLK,
		AUD_DACDAT => AUD_DACDAT,
		AUD_DACLRCK => AUD_DACLRCK,
		I2C_SDAT => I2c_SDAT,
		I2C_SCLK => I2c_SCLK
	);
	
				
				

end g19_behavior;