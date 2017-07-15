
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab5_top IS
   PORT
	(
   clkin_50		: in	std_logic;							-- The 50 MHz FPGA Clockinput
	rst_n			: in	std_logic;							-- The RESET input (ACTIVE LOW)
	pb				: in	std_logic_vector(3 downto 0); -- The push-button inputs (ACTIVE LOW)
 	sw   			: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds			: out std_logic_vector(7 downto 0);	-- for displaying the switch content
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digi selectors
	seg7_char2  : out	std_logic							-- seg7 digi selectors
	);
END LogicalStep_Lab5_top;

ARCHITECTURE SimpleCircuit OF LogicalStep_Lab5_top IS

   component cycle_generator port (
          clkin      		: in  std_logic;
			 rst_n				: in  std_logic;
			 modulo 				: in  integer;	
			 strobe_out			: out	std_logic;
			 full_cycle_out	: out std_logic
  );
   end component;

   component segment7_mux port (
          clk        : in  std_logic := '0';
			 DIN2 		: in  std_logic_vector(6 downto 0);	
			 DIN1 		: in  std_logic_vector(6 downto 0);
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
   );
   end component;
	
	component Lab5_Moore_SM port (
		clk_input, rst_n				     : IN std_logic;
		night_mode						     : IN std_logic; 
		reduced_mode		  				  : IN std_logic; 
		ns_latch, ew_latch				  : IN std_logic;
		current_value		              : OUT std_logic_vector(4 downto 0)
	);
	end component;
	
	component synchronizer is port(
	input			: in std_logic;
	rst_n			: in std_logic;
	clk_input	: in std_logic;
	output		: out std_logic
	);
	end component;
	
	component traffic_latch is port(
	sync_in		: in std_logic;
	clear			: in std_logic;
	clk_input 	: in std_logic;
	enable		: in std_logic;
	rst_n			: in std_logic;
	output 		: out std_logic
	);
	end component;
	
	
----------------------------------------------------------------------------------------------------
	CONSTANT	SIM							:  boolean := FALSE ;

	CONSTANT CNTR1_modulo				: 	integer := 25000000;    	-- modulo count for 1Hz cycle generator 1 with 50Mhz clocking input
   CONSTANT CNTR2_modulo				: 	integer := 5000000;    		-- modulo count for 5Hz cycle generator 2 with 50Mhz clocking input
   CONSTANT CNTR1_modulo_sim			: 	integer := 199;   			-- modulo count for cycle generator 1 during simulation
   CONSTANT CNTR2_modulo_sim			: 	integer :=  39;   			-- modulo count for cycle generator 2 during simulation
	
   SIGNAL CNTR1_modulo_value			: 	integer ;   					-- modulo count for cycle generator 1 
   SIGNAL CNTR2_modulo_value			: 	integer ;   					-- modulo count for cycle generator 2 

   SIGNAL clken1,clken2					:  STD_LOGIC; 						-- clock enables 1 & 2

	SIGNAL strobe1, strobe2				:  std_logic;						-- strobes 1 & 2 with each one being 50% Duty Cycle
		
	SIGNAL SM_output                 :  std_logic_vector(4 downto 0); -- signal for what state the LTC is at

	SIGNAL seg7_A, seg7_B				:  STD_LOGIC_VECTOR(6 downto 0); -- signals for inputs into seg7_mux.
	
	SIGNAL sync_out1, sync_out2		: std_logic;
	
	SIGNAL clearNS, clearEW 			: std_logic;
	
	SIGNAL NS_out, EW_out				: std_logic;
	
BEGIN
----------------------------------------------------------------------------------------------------


MODULO_1_SELECTION:	CnTR1_modulo_value <= CNTR1_modulo when SIM = FALSE else CNTR1_modulo_sim; 

MODULO_2_SELECTION:	CNTR2_modulo_value <= CNTR2_modulo when SIM = FALSE else CNTR2_modulo_sim; 
						

----------------------------------------------------------------------------------------------------
-- Component Hook-up:					

GEN1: 	cycle_generator port map(clkin_50, rst_n, CNTR1_modulo_value, strobe1, clken1);	
GEN2: 	cycle_generator port map(clkin_50, rst_n, CNTR2_modulo_value, strobe2, clken2);	

SM: Lab5_Moore_SM port map(strobe1, rst_n, sw(0), sw(1), NS_out, EW_out, SM_output);
MUX: segment7_mux port map(clkin_50, seg7_A, seg7_B, seg7_data, seg7_char1, seg7_char2);

SYNC1: synchronizer port map(not pb(0), rst_n, clkin_50, sync_out1);
SYNC2: synchronizer port map(not pb(1), rst_n, clkin_50, sync_out2);

LATCH1: traffic_latch port map(sync_out1, clearNS, clkin_50, clken2, rst_n, NS_out);
LATCH2: traffic_latch port map(sync_out2, clearEW, clkin_50, clken2, rst_n, EW_out);
	
leds(1 downto 0) <= Strobe1 & Strobe2;
leds(6 downto 2) <= SM_output;

with SM_output select
	clearNS <= '1' when "01111",
				  '0' when others;
with SM_output select			  
	clearEW <= '1' when "01111",
				  '0' when others;


-- used for simulations
--	leds(0) <= clken1;
--	leds(1) <= Strobe1;
--	leds(2) <= clken2;
--	leds(3) <= Strobe2;
--	leds(7 downto 4) <= State Machine state numbers

WITH SM_output select
	-- the NS TLC
	-- red 1, amber 7, green 4
	seg7_A <= 
		---------- G flash
		"000" & strobe2 & "000" when "00000", -- strobe2 is the 5Hz strobe signal 
		"000" & strobe2 & "000" when "00001",
		---------- G solid
		"0001000" when "00010",
		"0001000" when "00011",
		"0001000" when "00100",
		"0001000" when "00101",
		---------- A solid
		"1000000" when "00110",
		"1000000" when "00111",
		---------- R solid
		"0000001" when "01000",
		"0000001" when "01001",
		"0000001" when "01010",
		"0000001" when "01011",
		"0000001" when "01100",
		"0000001" when "01101",
		"0000001" when "01110",
		"0000001" when "01111",
		----------- night mode (NS is green)
		"0001000" when "10000",
		----------- reduced mode (NS is slow flash A)
		strobe1 & "000000" when others;

WITH SM_output select	
	-- the EW TLC
	seg7_B <=
		---------- R solid
		"0000001" when "00000",
		"0000001" when "00001",
		"0000001" when "00010",
		"0000001" when "00011",
		"0000001" when "00100",
		"0000001" when "00101",
		"0000001" when "00110",
		"0000001" when "00111",
		---------- G flash
		"000" & strobe2 & "000" when "01000",
		"000" & strobe2 & "000" when "01001",
		---------- G solid
		"0001000" when "01010",
		"0001000" when "01011",
		"0001000" when "01100",
		"0001000" when "01101",
		---------- A solid
		"1000000" when "01110",
		"1000000" when "01111",
		---------- night mode (EW is red)
		"0000001" when "10000",
		----------- reduced mode (NS is slow flash R)
		"000000" & strobe1 when others;

END SimpleCircuit;
