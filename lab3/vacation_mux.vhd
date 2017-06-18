library ieee;
use ieee.std_logic_1164.all;

entity vacation_mux is 
port (
	desired_temp			: in std_logic_vector(3 downto 0); 
	vacation_select		: in std_logic;
	hex_out					: out std_logic_vector(3 downto 0)
);

end entity vacation_mux;

architecture mux_logic of vacation_mux is

begin

with vacation_select select
hex_out <= "0100" when '0', --when pb3 is not pressed
			  desired_temp when '1'; --when pb3 is pressed
end mux_logic;