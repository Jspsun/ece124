LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY work;

ENTITY VHDL_polarity_gates IS
	PORT
	(
		IN1, IN2, IN3, IN4, POLARITY_CNTRL: IN BIT;
		OUT1, OUT2, OUT3, OUT4 : OUT BIT
	);
END VHDL_polarity_gates;

ARCHITECTURE simple_gates OF VHDL_polarity_gates IS


BEGIN

OUT1 <= IN1 XOR POLARITY_CNTRL;
OUT2 <= IN2 XOR POLARITY_CNTRL;
OUT3 <= IN3 XOR POLARITY_CNTRL;
OUT4 <= IN4 XOR POLARITY_CNTRL;

END simple_gates;