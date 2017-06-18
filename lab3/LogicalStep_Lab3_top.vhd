library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity LogicalStep_Lab3_top is port (
   clkin_50		: in	std_logic;
	pb				: in	std_logic_vector(3 downto 0); -- pb(2) fdoor; pb(1) window; pb(0) bdoor
 	sw   			: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds			: out std_logic_vector(7 downto 0);	-- for displaying the switch content
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digi selectors
	seg7_char2  : out	std_logic							-- seg7 digi selectors
	
); 
end LogicalStep_Lab3_top;

architecture Energy_Monitor of LogicalStep_Lab3_top is
--
-- Components Used
------------------------------------------------------------------- 
  component compx4 port (
	a0, b0, a1, b1, a2, b2, a3, b3	: in std_logic; --a is the current temp, b is the desired temp
	a_more_b, a_equal_b, a_less_b		: out boolean --one-bit output based on 4 compx1
);
   end component;
	
	component segment7_mux port (
	 clk 			: 	in std_logic := '0';
	 DIN2			:	in std_logic_vector(6 downto 0);
	 DIN1			:	in std_logic_vector(6 downto 0);
	 DOUT			:	out std_logic_vector(6 downto 0);
	 DIG2			:	out std_logic;
	 DIG1			:	out std_logic
	 );
	end component;
	
  component SevenSegment port (
   hex   		:  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg 	:  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
); 
   end component;
------------------------------------------------------------------
	
	
-- Create any signals, or temporary variables to be used
signal temp_led0		: boolean; -- a more b i.e. current more desired; truth value for led0 (furnace on, below temp)
signal temp_led1		: boolean; -- truth value for led1 (at temp)
signal temp_led2		: boolean; -- a more b i.e. current more desired; truth value for led0 (ac on, below temp)
signal seg7_A		: std_logic_vector(6 downto 0); -- left display
signal seg7_B		: std_logic_vector(6 downto 0); -- right display
	
-- Here the circuit begins

begin
leds(2) <= '1' when temp_led0 AND (pb(2 downto 0) = "111") -- furnace status
					else '0'; 
leds(1) <= '1' when temp_led1
					else '0';
leds(0) <= '1' when temp_led2 AND (pb(2 downto 0) = "111") -- ac status
					else '0'; 
leds(3) <= '1' when (temp_led0 OR temp_led2) AND (pb(2 downto 0) = "111")
					else '0';
leds(4) <= '0' when pb(0) = '1'
					else '1';
leds(5) <= '0' when pb(1) = '1'
					else '1';
leds(6) <= '0' when pb(2) = '1'
					else '1';
 
INST0: compx4 port map(sw(0), sw(4), sw(1), sw(5), sw(2), sw(6), sw(3), sw(7), temp_led2, temp_led1, temp_led0); --leds(0) is the furnace, leds(1) is the system at temp, leds(2) is the a/c

INST1: SevenSegment port map(sw(3 downto 0), seg7_A);
INST2: SevenSegment port map(sw(7 downto 4), seg7_B);
INST3: segment7_mux port map(clkin_50, seg7_A, seg7_B, seg7_data, seg7_char1, seg7_char2);

end Energy_Monitor;

