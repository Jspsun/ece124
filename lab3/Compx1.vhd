library ieee;
use ieee.std_logic_1164.all;

entity compx1 is 
port (
	bit_A, bit_B							: in std_logic; --one-bit input (A, B)
	A_less_B, A_equal_B, A_more_B		: out boolean --one-bit ouptut
);

end entity compx1;

architecture compx1 of compx1 is

begin

-- for the multiplexing of two hex input busses
A_less_B <= true when bit_A < bit_B --when A is 0 and B is 1
				else false;
A_equal_B <= true when bit_A = bit_B --when A is 1 and B is 1
				else false;
A_more_B <= true when bit_A > bit_B --when A is 1 and B is 0
				else false;
			  
end compx1;