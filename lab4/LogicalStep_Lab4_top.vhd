LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS
  PORT(
   clkin_50		: in	std_logic;
  	rst_n		  	: in	std_logic;
  	pb			  	: in	std_logic_vector(3 downto 0);
   sw   		   : in  std_logic_vector(7 downto 0); -- The switch inputs
   leds			: out std_logic_vector(7 downto 0);	-- for displaying the switch content
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
  	seg7_char1  : out	std_logic;				       	-- seg7 digi selectors
  	seg7_char2  : out	std_logic				        	-- seg7 digi selectors
	);
END LogicalStep_Lab4_top;

ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS
  component compx4 port (
  	a0, b0, a1, b1, a2, b2, a3, b3	: in std_logic;
  	a_less_b, a_equal_b, a_more_b		: out std_logic
	);
  end component;

  component Moore_SM port (
   clk_input, rst_n				  : IN std_logic;
   MORE, EQUAL, LESS			     : IN std_logic;
   current_value		           : OUT std_logic_vector(3 downto 0)
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
 	  hex   		:  in  std_logic_vector(3 downto 0);   -- digit 1 shows state number in hex of state machine; if they don't match; it changes
 	  sevenseg 	:  out std_logic_vector(6 downto 0)    -- target is sw [3..0] and displayed on right digit
 	  );
 	end component;

----------------------------------------------------------------------------------------------------
	CONSTANT	SIM					    	: boolean := FALSE; 	-- set to TRUE for simulation runs otherwise keep at 0.
	CONSTANT  CLK_DIV_SIZE	    	 	: INTEGER := 24;  -- size of vectors for the counters

	signal 	Main_CLK				  		: STD_LOGIC; 			-- main clock to drive sequencing of State Machine

	signal 	bin_counter				  	: UNSIGNED(CLK_DIV_SIZE-1 downto 0); -- := to_unsigned(0,CLK_DIV_SIZE); -- reset binary counter to zero

	signal	Simple_States 				: std_logic_vector(7 downto 4);
	signal	Left0_Right1		   	: std_logic;

	signal more							  	: std_logic; -- for 4-bit comparator
	signal less							  	: std_logic; -- for 4-bit comparator
	signal equal					   	: std_logic; -- for 4-bit comparator

	signal current_value       	  	: std_logic_vector(3 downto 0);
	signal target_value				  	: std_logic_vector(3 downto 0);

	signal seg7_A			            : std_logic_vector(6 downto 0); -- left display
	signal seg7_B			            : std_logic_vector(6 downto 0); -- right display

----------------------------------------------------------------------------------------------------
BEGIN

-- CLOCKING GENERATOR WHICH DIVIDES THE INPUT CLOCK DOWN TO A LOWER FREQUENCY

BinCLK: PROCESS(clkin_50, rst_n) is
   BEGIN
		IF (rising_edge(clkin_50)) THEN -- binary counter increments on rising clock edge
         bin_counter <= bin_counter + 1;
      END IF;
   END PROCESS;

Clock_Source:
				Main_Clk <=
				clkin_50 when sim = TRUE else			      	-- for simulations only
				std_logic(bin_counter(23));						-- for real FPGA operation

---------------------------------------------------------------------------------------------------
Left0_Right1 <= pb(0);              -- switch direction of led(7..4)
target_value <= sw(3 downto 0);     -- target value based on switches

leds(7 downto 4) <= Simple_States;  -- incrementing/decrementing counter
leds(3) <= Main_Clk;                -- flashing LED at speed of Main_Clk
leds(2) <= more;							-- count up led
leds(1) <= equal;							-- count done led
leds(0) <= less;							-- count down led




INST0: compx4 port map(sw(0), current_value(0), sw(1), current_value(1),
                       sw(2), current_value(2), sw(3), current_value(3),
                       more, equal, less); --passes in target value and current value to comparator
INST1: Moore_SM port map(Main_Clk, rst_n, more, equal, less, current_value); -- uses slowed down clock
INST2: SevenSegment port map(target_value, seg7_A);
INST3: SevenSegment port map(current_value, seg7_B);
INST4: segment7_mux port map(clkin_50, seg7_A, seg7_B, seg7_data, seg7_char2, seg7_char1); -- uses fast clock

----------------------------------------------------
process (Main_Clk, rst_n) is
begin
	if (rst_n = '0') then
			Simple_States <= "1000";
	elsif (rising_edge(Main_Clk)) then
			if (Left0_right1 = '1') then -- TRUE for RIGHT shift
				Simple_States (7 downto 4) <= Simple_States(4) & Simple_States(7 downto 5); --includes wrap around of shift registers bits
			else
				Simple_States (7 downto 4) <= Simple_States(6 downto 4) & Simple_States(7); --includes wrap around of shift registers bits
			end if;
	end if;
end process;

END SimpleCircuit;