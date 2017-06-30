library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity logic_processor is
port(
	hex_A, hex_B			: in std_logic_vector(3 downto 0);
	pb							  : in std_logic_vector(3 downto 0);
	logic_func				: out std_logic_vector(3 downto 0)
	);
end entity logic_processor;

architecture logic of logic_processor is

signal sum 					: std_logic_vector(3 downto 0);

begin

sum <= std_logic_vector(unsigned(hex_A) + unsigned(hex_B));

with pb select
logic_func <= hex_A AND hex_B when "1110",
				  hex_A OR hex_B when "1101",
				  hex_A XOR hex_B when "1011",
				  sum when "0111",
				  "0000" when others;

end logic;
