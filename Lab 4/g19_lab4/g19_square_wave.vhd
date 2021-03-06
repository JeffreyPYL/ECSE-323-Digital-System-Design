
--Group 19
--Frank Luong 260481340
--Jeffrey Leung 260402139

Library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
library lpm;
use lpm.lpm_components.all;


  entity g19_square_wave is
 port ( clk, reset : in std_logic; 
	note_number : in std_logic_vector(3 downto 0); 
	octave : in std_logic_vector(2 downto 0);
	volume : in unsigned(22 downto 0); 
	square : out signed(23 downto 0)); 
  end g19_square_wave;
  
  architecture g19_behavior of g19_square_wave is
  signal load : std_logic := '1';
  signal ffOut : std_logic_vector (0 downto 0);
  signal topValue: std_logic_vector(23 downto 0);
  signal outBarrel,B: std_logic_vector(19 downto 0);
  signal data : integer;
  signal outLPMADD, TESTING: std_logic_vector (23 downto 0);

  
  signal pitch_period :std_logic_vector(19 downto 0);
  begin 
	
   -- Pitch number --
	with note_number select
	pitch_period <= 
		
	"10111010101000100011" when "0000",
	"10110000001010001001" when "0001",
	"10100110010001011000" when "0010",
	"10011100111100001000" when "0011",
	"10010100001000011001" when "0100",
	"10001011110100010011" when "0101",
	"10000011111110000100" when "0110",
	"01111100100100000001" when "0111",
	"01110101100100100101" when "1000",
	"01101110111110010001" when "1001",
	"01101000101111101001" when "1010",
	"01100010110111011001" when "1011",
	"11111111111111111111" when others;
--	
--	-- Barrel Shifter --
--	
	outBarrel <= to_stdlogicvector(to_bitvector(pitch_period) SRL to_integer(unsigned(octave)));


	--Process Block-------
	counter1: process(clk,reset)	
		
		begin
		
		if reset = '1' then
			data <= 0;
		elsif clk = '1' and clk'event then
			
			if load = '1' then 
			data <= to_integer(unsigned(outBarrel)); -- conver to int so can so math on it with math sign
		
			else
				data <= data - 1; --count <= count -1; 
			end if; -- end when data is 0 then push it back to the top
	
			
      
		end if;
	B <= std_logic_vector(to_unsigned(data, 20));
	
	load <= not(B(0) or B(1) or B(2) or B(3)or B(4)or B(5)or B(6)or B(7)or B(8)or B(9)or B(10)or B(11)or B(12)or B(13)or B(14)or B(15)or B(16) or B(17)or B(18)or B(19));
		--end if;
	end process;
	
	----- End Process Block--------
	lpm_ff_component : lpm_ff
	GENERIC MAP (
		lpm_fftype => "TFF",
		lpm_type => "LPM_FF",
		lpm_width => 1
	)
	PORT MAP (
		enable => load, -- output from the process block
		aclr => reset,
		clock => clk,
		q => ffOut
	);


-- choose the sign of the volume.
with ffOut select
	square <= - signed(('0') & volume) when "1",
		    signed(('0') & volume)when others;
	





end g19_behavior;
  