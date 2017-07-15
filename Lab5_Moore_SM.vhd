library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity Lab5_Moore_SM IS Port
(
 clk_input, rst_n				     : IN std_logic;
 night_mode						     : IN std_logic; 
 reduced_mode		  				  : IN std_logic; 
 ns_latch, ew_latch				  : IN std_logic;
 current_value		              : OUT std_logic_vector(4 downto 0)
 );
END ENTITY;

Architecture MSM of Lab5_Moore_SM is
  TYPE STATE_NAMES IS (S0, S1, S2, S3, S4, S5, S6, S7,
                       S8, S9, S10, S11, S12, S13, S14, S15, S16, S17); -- list all the STATES


  signal current_state,next_state	:  STATE_NAMES;   -- signals of type STATE_NAMES
  signal super_night_mode : std_logic;
  
BEGIN
--------------------------------------------------------------------------------
--State Machine:
--------------------------------------------------------------------------------

-- REGISTER LOGIC PROCESS
-- add clock and any related inputs for state machine register section into Sensitivity List

Register_Section: PROCESS (clk_input, rst_n,next_state)  -- this process synchronizes the activity to a clock
BEGIN
	IF (rst_n = '0') THEN
		current_state <= S0;
	ELSIF(rising_edge(clk_input)) THEN
		current_state <=next_state;
	        ELSE
		current_state <= current_state;
	        END IF;
END PROCESS;

PROCESS(night_mode, reduced_mode)
BEGIN
	if (night_mode = '1') and (reduced_mode = '1') then
		super_night_mode <= '0';
	else 
		super_night_mode <= night_mode;
	end if;
END PROCESS;

-- TRANSTION LOGIC PROCESS (to be combinational only)
-- add all transition inputs for state machine into Transition section Sensitivity List
-- make sure that all conditional statement options are complete otherwise VHDL will infer LATCHES.

Transition_Section: PROCESS (current_state)

-- NS monitors latch during S8 to 12; if latch output = 1; go to S14 so that theres amber light, at S15, send latch clear to latch
-- SE monitors latch during S0 to 4; go to S6, then at S7, send latch clear

BEGIN 
	  CASE current_state IS
		-- part D MSM
		      WHEN S0 =>
         if (ew_latch = '1') THEN
				next_state <= S6;
			else
				next_state <= S1;
			end if; 
      WHEN S1 =>
         if (ew_latch = '1') THEN
				next_state <= S6;
			else
				next_state <= S2;
			end if; 
      WHEN S2 =>
         if (ew_latch = '1') THEN
				next_state <= S6;
			else
				next_state <= S3;
			end if; 
      WHEN S3 =>
         if (ew_latch = '1') THEN
				next_state <= S6;
			else
				next_state <= S4;
			end if; 
      WHEN S4 =>
         if (ew_latch = '1') THEN
				next_state <= S6;
			else
				next_state <= S5;
			end if; 
      WHEN S5 =>
         next_state <= S6;
      WHEN S6 =>
         next_state <= S7;
      WHEN S7 =>
         if (reduced_mode = '1') then
				next_state <= S17;
			elsif (super_night_mode = '1') then
				next_state <= S16;
			else
				next_state <= S8;
			end if;
      WHEN S8 =>
			if (ns_latch = '1') THEN
				next_state <= S14;
			else
				next_state <= S9;
			end if; 
      WHEN S9 =>
         if (ns_latch = '1') THEN
				next_state <= S14;
			else
				next_state <= S10;
			end if; 
      WHEN S10 =>
         if (ns_latch = '1') THEN
				next_state <= S14;
			else
				next_state <= S11;
			end if; 
      WHEN S11 =>
         if (ns_latch = '1') THEN
				next_state <= S14;
			else
				next_state <= S12;
			end if; 
      WHEN S12 =>
         if (ns_latch = '1') THEN
				next_state <= S14;
			else
				next_state <= S13;
			end if; 
      WHEN S13 =>
         next_state <= S14;
      WHEN S14 =>
         next_state <= S15;
      WHEN S15 =>
		   if (reduced_mode = '1') then
				next_state <= S17;
			elsif (super_night_mode = '1') then
				next_state <= S16;
			else
				next_state <= S0;
			end if;
		WHEN S16 => 
			if (super_night_mode = '0') then 
				next_state <= S6;
			end if;
		WHEN S17 => 
			if (reduced_mode = '0') then
				next_state <= S6;
			end if;
      WHEN others =>
          next_state <= S0;
		END CASE;
		

END PROCESS;

Decoder_Section: PROCESS(current_state)

BEGIN -- based on current state, assign 4-bit value to current-value
  CASE current_state IS
	 ------------------ G flash
    WHEN S0 =>
      current_value <= "00000";
    WHEN S1 =>
      current_value <= "00001";
	 ------------------ G solid
    WHEN S2 =>
      current_value <= "00100";
    WHEN S3 =>
      current_value <= "00011";
    WHEN S4 =>
      current_value <= "00100";
    WHEN S5 =>
      current_value <= "00101";
	 ------------------ A solid
    WHEN S6 =>
      current_value <= "00110";
    WHEN S7 =>
      current_value <= "00111";
    ------------------ R solid
    WHEN S8 =>
      current_value <= "01000";
    WHEN S9 =>
      current_value <= "01001";
    WHEN S10 =>
      current_value <= "01010";
    WHEN S11 =>
      current_value <= "01011";
    WHEN S12 =>
      current_value <= "01100";
    WHEN S13 =>
      current_value <= "01101";
    WHEN S14 =>
      current_value <= "01110";
    WHEN S15 =>
      current_value <= "01111";
	WHEN S16 =>
      current_value <= "10000";
	WHEN S17 =>
      current_value <= "10001";
  END CASE;
END PROCESS;

END ARCHITECTURE MSM;