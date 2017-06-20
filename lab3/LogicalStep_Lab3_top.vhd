library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LogicalStep_Lab3_top is port (
	clkin_50	: in std_logic;
	pb			: in std_logic_vector(3 downto 0);	-- pb(2) fdoor; pb(1) window; pb(0) bdoor
 	sw   		: in std_logic_vector(7 downto 0); 	-- The switch inputs
	leds		: out std_logic_vector(7 downto 0);	-- for displaying the switch content
	seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out std_logic;					-- seg7 digi selectors
	seg7_char2  : out std_logic						-- seg7 digi selectors
	
); 
end LogicalStep_Lab3_top;

architecture Energy_Monitor of LogicalStep_Lab3_top is
-- Components Used
------------------------------------------------------------------- 
  component compx4 port (
	a0, b0, a1, b1, a2, b2, a3, b3	: in std_logic; --a is the current temp, b is the desired temp
	a_more_b, a_equal_b, a_less_b	: out std_logic --one-bit output based on 4 compx1
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
	
  component vacation_mux port (
	desired_temp			: in std_logic_vector(3 downto 0); 
	vacation_select		: in std_logic;
	hex_out					: out std_logic_vector(3 downto 0)
);
	end component;
------------------------------------------------------------------	
	
-- Create any signals, or temporary variables to be used
signal temp_led0		: std_logic; -- a more b i.e. current more desired; truth value for led0 (furnace on, below temp)
signal temp_led1		: std_logic; -- truth value for led1 (at temp)
signal temp_led2		: std_logic; -- a more b i.e. current more desired; truth value for led0 (ac on, below temp)
signal seg7_A			: std_logic_vector(6 downto 0); -- left display
signal seg7_B			: std_logic_vector(6 downto 0); -- right display
signal desired			: std_logic_vector(3 downto 0); -- output of vacation mux
	
-- Here the circuit begins

begin
leds(3) <= (temp_led0 OR temp_led2) AND (pb(2) AND pb(1) AND pb(0)); --blower status
leds(2) <= temp_led0 AND (pb(2) AND pb(1) AND pb(0)); -- furnace status 
leds(1) <= temp_led1; --desired temp status
leds(0) <= temp_led2 AND (pb(2) AND pb(1) AND pb(0)); -- ac status 

leds(4) <= NOT(pb(0));
leds(5) <= NOT(pb(1));
leds(6) <= NOT(pb(2));
leds(7) <= NOT(pb(3));
 
INST0: compx4 port map(sw(0), desired(0), sw(1), desired(1), sw(2), desired(2), sw(3), desired(3), temp_led2, temp_led1, temp_led0); --leds(0) is the furnace, leds(1) is the system at temp, leds(2) is the a/c

INST1: SevenSegment port map(sw(3 downto 0), seg7_A);
INST2: SevenSegment port map(desired, seg7_B);
INST3: segment7_mux port map(clkin_50, seg7_A, seg7_B, seg7_data, seg7_char2, seg7_char1);
INST4: vacation_mux port map(sw(7 downto 4), pb(3), desired);

end Energy_Monitor;

