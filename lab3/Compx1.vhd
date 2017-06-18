library ieee;
use ieee.std_logic_1164.all;

entity compx1 is 
port (
	bit_A, bit_B							: in std_logic; --one-bit input (A, B)
	A_less_B, A_equal_B, A_more_B		: out std_logic --one-bit ouptut
);

end entity compx1;

architecture compx1 of compx1 is

begin

-- for the multiplexing of two hex input busses
A_less_B <= NOT bit_A AND bit_B; --when A is 0 and B is 1
A_equal_B <= (bit_A AND bit_B) OR (NOT(bit_A) AND NOT(bit_B)); --when A is 1 and B is 1 or when A is 0 and B is 0
A_more_B <= bit_A AND NOT bit_B; --when A is 1 and B is 0
			  
end compx1;