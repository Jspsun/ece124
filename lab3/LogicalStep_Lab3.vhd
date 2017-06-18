library ieee;
use ieee.std_logic_1164.all;

entity LogicalStep_Lab3_top is 
port (
	sw   				: in  std_logic_vector(7 downto 0); -- The switch inputs
	leds				: out std_logic_vector(7 downto 0) -- for displaying the switch content
);

end entity LogicalStep_Lab3_top;

architecture Comparator of LogicalStep_Lab3_top is

-- Components Used --
  component compx4 port (
	a0, b0, a1, b1, a2, b2, a3, b3	: in std_logic; --one-bit input (A, B)
	a_more_b, a_equal_b, a_less_b		: out std_logic --one-bit output based on 4 compx1
);
   end component;


-- Circuit Begins --
begin

INST0: compx4 port map(sw(0), sw(4), sw(1), sw(5), sw(2), sw(6), sw(3), sw(7), leds(2), leds(1), leds(0));

end Comparator;