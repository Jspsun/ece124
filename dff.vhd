library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d_flip_flop is port(
	clk_input	: in std_logic;  -- 50Mhz Clock
	rst_n			: in std_logic;
	D				: in std_logic;  --input from pb (can be metastable)
	Q				: out std_logic -- temp output (not metastable)
);
end d_flip_flop;

ARCHITECTURE behaviour OF d_flip_flop IS
begin

PROCESS (clk_input) is
	begin
		if rising_edge(clk_input) then -- by definition of a D flip flop
			if (rst_n = '0') then
				Q <= '0';
			else
				Q <= D;
			end if;
		end if;
end process;

END ARCHITECTURE behaviour;