library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity synchronizer is port(
	input			: in std_logic;
	rst_n			: in std_logic;
	clk_input	: in std_logic;
	output		: out std_logic
);
end synchronizer;

	
ARCHITECTURE behaviour OF synchronizer IS

component d_flip_flop is port(
	clk_input	: in std_logic;
	rst_n			: in std_logic;
	D				: in std_logic;
	Q				: out std_logic
	);
end component;

signal temp: std_logic;

begin
	DFF1: d_flip_flop port map(clk_input, rst_n, input, temp); -- slave flip flop
	DFF2: d_flip_flop port map(clk_input, rst_n, temp, output); -- master flip flop

END ARCHITECTURE behaviour;
