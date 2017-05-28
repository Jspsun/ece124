library ieee;
use ieee.std_logic_1164.all;

entity led_hex_mux is 
port (
	hex_num1, hex_num0	: in std_logic_vector(7 downto 0); --logic_func, sum
	mux_select				: in std_logic_vector(3 downto 0);
	hex_out					: out std_logic_vector(7 downto 0)
);

end entity led_hex_mux;

architecture mux_logic of led_hex_mux is

begin

-- for the multiplexing of two hex input busses
with mux_select select
hex_out <= hex_num1 when "0111", --when pb3 is pressed
			  hex_num0 when "1111", --when pb3 is not pressed and less than 2 buttons are pressed
			  hex_num0 when "1011", 
			  hex_num0 when "1101",
			  hex_num0 when "1110",
			  "11111111" when others; --when 2 or more buttons are pressed
end mux_logic;