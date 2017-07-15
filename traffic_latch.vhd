library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity traffic_latch is port(
	sync_in		: in std_logic;
	clear			: in std_logic;
	clk_input	: in std_logic;
	enable		: in std_logic;
	rst_n			: in std_logic;
	output 		: out std_logic
);
end traffic_latch;

ARCHITECTURE behaviour OF traffic_latch IS

component en_dff is port(
	clk_input	: in std_logic;  -- 50Mhz Clock
	enable		: in std_logic;  -- enable
	rst_n			: in std_logic;
	D				: in std_logic;  --input from pb (can be metastable)
	Q				: out std_logic -- temp output (not metastable)
);
end component;

signal dff_in : std_logic;
signal temp : std_logic;

begin
DFF: en_dff port map(clk_input, enable, rst_n, dff_in, temp);
dff_in <= (not clear) and (sync_in or temp);
output <= temp;

END ARCHITECTURE behaviour;