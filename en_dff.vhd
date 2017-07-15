library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity en_dff is port(
	clk_input	: in std_logic;  -- 50Mhz Clock
	enable		: in std_logic;  -- enable
	rst_n			: in std_logic;  -- reset 
	D				: in std_logic;  --input from pb (can be metastable)
	Q				: out std_logic -- temp output (not metastable)
);
end en_dff;

ARCHITECTURE behaviour OF en_dff IS
begin

PROCESS (clk_input) is
	begin
		if rising_edge(clk_input) then -- by definition of a D flip flop
			if (rst_n = '0') or (enable = '1') then -- Q = 0 of reset or clock not enabled 
				Q <= '0';
			else
				Q <= D;
			end if;
		end if;
end process;

END ARCHITECTURE behaviour;