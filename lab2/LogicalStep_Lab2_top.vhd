library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity LogicalStep_Lab2_top is port (
  clkin_50			: in	std_logic;
	pb					  : in	std_logic_vector(3 downto 0);
 	sw   				  : in  std_logic_vector(7 downto 0); -- The switch inputs
  leds				  : out std_logic_vector(7 downto 0); -- for displaying the switch content
  seg7_data 		: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  	: out	std_logic;				    		-- seg7 digit1 selector
	seg7_char2  	: out	std_logic				    		-- seg7 digit2 selector

);
end LogicalStep_Lab2_top;

architecture SimpleCircuit of LogicalStep_Lab2_top is
--
-- Components Used ---
-------------------------------------------------------------------
  component SevenSegment port (
   hex   		  :  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg 	:  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
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

	 component display_hex_mux port(
	  hex_num0		: in std_logic_vector(7 downto 0);
     hex_num1		: in std_logic_vector(7 downto 0);
     mux_select	: in std_logic_vector(3 downto 0);
     hex_out		: out std_logic_vector(7 downto 0)
	  );
	  end component;

	  component led_hex_mux port(
	   hex_num0		: in std_logic_vector(7 downto 0);
	   hex_num1		: in std_logic_vector(7 downto 0);
	   mux_select	: in std_logic_vector(3 downto 0);
	   hex_out		: out std_logic_vector(7 downto 0)
	   );
	  end component;

	  component logic_processor port(
		hex_A			: in std_logic_vector(3 downto 0);
		hex_B			: in std_logic_vector(3 downto 0);
		pb				: in std_logic_vector(3 downto 0);
		logic_func	: out std_logic_vector(3 downto 0)
		);
		end component;


-- Create any signals, or temporary variables to be used
--
--  std_logic_vector is a signal which can be used for logic operations such as OR, AND, NOT, XOR
--
	signal seg7_A		: std_logic_vector(6 downto 0); -- left display
	signal seg7_B		: std_logic_vector(6 downto 0); -- right display
	signal seg7_C		: std_logic_vector(7 downto 0); -- output of display mux

	signal hex_A		: std_logic_vector(3 downto 0); -- right 4 switches
	signal hex_B		: std_logic_vector(7 downto 4); -- left 4 switches
	signal hex_C		: std_logic_vector(7 downto 0); -- all 8 switches

	signal logic_func	: std_logic_vector(3 downto 0); -- logic processor output
	signal sum 			: std_logic_vector(7 downto 0); -- sum of two switch inputs

	signal hex_seg_A	: std_logic_vector(3 downto 0); -- left display int value
	signal hex_seg_B	: std_logic_vector(3 downto 0); -- right display int value

-- Here the circuit begins

begin
	hex_A <= sw(3 downto 0);
	hex_B <= sw(7 downto 4);
	hex_C <= hex_B & hex_A;
	hex_seg_A <= seg7_C(7 downto 4);
	hex_seg_B <= seg7_C(3 downto 0);
	sum <= std_logic_vector(unsigned("0000" & hex_A) + unsigned("0000" & hex_B)); --sum of hex_a and hex_b

--COMPONENT HOOKUP
--
-- generate the seven segment coding

	INST1: SevenSegment port map(hex_seg_A, seg7_A);
	INST2: SevenSegment port map(hex_seg_B, seg7_B);
	INST3: segment7_mux port map(clkin_50, seg7_A, seg7_B, seg7_data, seg7_char1, seg7_char2);
	INST4: display_hex_mux port map(hex_C, sum, pb, seg7_C);
	INST5: led_hex_mux port map("0000" & logic_func, sum, pb, leds);
	INST6: logic_processor port map(hex_A, hex_B, pb, logic_func);

end SimpleCircuit;
