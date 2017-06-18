library ieee;
use ieee.std_logic_1164.all;

entity compx4 is 
port (
	a0, b0, a1, b1, a2, b2, a3, b3	: in std_logic; --one-bit input (A, B)
	a_more_b, a_equal_b, a_less_b		: out std_logic --one-bit output based on 4 compx1
);

end entity compx4;

architecture compx4 of compx4 is

-- Components Used --
  component compx1 port (
	bit_A, bit_B							: in std_logic; --one-bit input (A, B)
	A_less_B, A_equal_B, A_more_B		: out std_logic --one-bit ouptut
	);
   end component;

-- Signals Created --
signal a0_more_b0 : std_logic;
signal a1_more_b1 : std_logic;
signal a2_more_b2 : std_logic;
signal a3_more_b3 : std_logic;
signal a0_equal_b0 : std_logic;
signal a1_equal_b1 : std_logic;
signal a2_equal_b2 : std_logic;
signal a3_equal_b3 : std_logic;
signal a0_less_b0 : std_logic;
signal a1_less_b1 : std_logic;
signal a2_less_b2 : std_logic;
signal a3_less_b3 : std_logic;


-- Circuit Begins --
begin

INST0: compx1 port map(a0, b0, a0_more_b0, a0_equal_b0, a0_less_b0);
INST1: compx1 port map(a1, b1, a1_more_b1, a1_equal_b1, a1_less_b1);
INST2: compx1 port map(a2, b2, a2_more_b2, a2_equal_b2, a2_less_b2);
INST3: compx1 port map(a3, b3, a3_more_b3, a3_equal_b3, a3_less_b3);


a_equal_b <= a0_equal_b0 AND a1_equal_b1 AND a2_equal_b2 AND a3_equal_b3;
a_more_b <= (a3_more_b3) OR 
				(a3_equal_b3 AND a2_more_b2) OR 
				(a3_equal_b3 AND a2_equal_b2 AND a1_more_b1) OR 
				(a3_equal_b3 AND a2_equal_b2 AND a1_equal_b1 AND a0_more_b0);
a_less_b <= (a3_less_b3) OR 
				(a3_equal_b3 AND a2_less_b2) OR 
				(a3_equal_b3 AND a2_equal_b2 AND a1_less_b1) OR 
				(a3_equal_b3 AND a2_equal_b2 AND a1_equal_b1 AND a0_less_b0);
end compx4;