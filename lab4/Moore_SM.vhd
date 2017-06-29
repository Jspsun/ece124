library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity Moore_SM IS Port
(
 clk_input, rst_n				     : IN std_logic;
 MORE, EQUAL, LESS			     : IN std_logic;
 target_value					       : IN std_logic_vector(3 downto 0);
 current_value		           : OUT std_logic_vector(3 downto 0)
 );
END ENTITY;

Architecture MSM of Moore_SM is
  TYPE STATE_NAMES IS (S0, S1, S2, S3, S4, S5, S6, S7,
                       S8, S9, S10, S11, S12, S13, S14, S15); -- list all the STATES


  signal current_state,next_state	:  STATE_NAMES;   -- signals of type STATE_NAMES
	signal current_value	            : std_logic_vector(3 downto 0);

BEGIN
--------------------------------------------------------------------------------
--State Machine:
--------------------------------------------------------------------------------

-- REGISTER LOGIC PROCESS
-- add clock and any related inputs for state machine register section into Sensitivity List

Register_Section: PROCESS (Main_Clk, rst_n,next_state)  -- this process synchronizes the activity to a clock
BEGIN
	IF (rst_n = '0') THEN
		current_state <= S0;
	ELSIF(rising_edge(Main_Clk)) THEN
		current_state <=next_state;
	        ELSE
		current_state <= current_state;
	        END IF;
END PROCESS;

-- TRANSTION LOGIC PROCESS (to be combinational only)
-- add all transition inputs for state machine into Transition section Sensitivity List
-- make sure that all conditional statement options are complete otherwise VHDL will infer LATCHES.

Transition_Section: PROCESS (MORE, LESS, EQUAL, current_state)

BEGIN
	  CASE current_state IS
      WHEN S0 =>
        IF (MORE ='1') THEN
          next_state <= S1;
        ELSE
          next_state <= S0;
        END IF;

      WHEN S1 =>
        IF (MORE ='1') THEN
          next_state <= S2;
        ELSIF (LESS ='1') THEN
          next_state <= S0;
        ELSE
          next_state <= S1;
        END IF;

      WHEN S2 =>
        IF (MORE ='1') THEN
          next_state <= S3;
        ELSIF (LESS ='1') THEN
          next_state <= S1;
        ELSE
          next_state <= S2;
        END IF;

      WHEN S3 =>
        IF (MORE ='1') THEN
          next_state <= S4;
        ELSIF (LESS ='1') THEN
          next_state <= S2;
        ELSE
          next_state <= S3;
        END IF;

      WHEN S4 =>
        IF (MORE ='1') THEN
          next_state <= S5;
        ELSIF (LESS ='1') THEN
          next_state <= S3;
        ELSE
          next_state <= S4;
        END IF;

      WHEN S5 =>
        IF (MORE ='1') THEN
          next_state <= S6;
        ELSIF (LESS ='1') THEN
          next_state <= S4;
        ELSE
          next_state <= S5;
        END IF;

      WHEN S6 =>
        IF (MORE ='1') THEN
          next_state <= S7;
        ELSIF (LESS ='1') THEN
          next_state <= S5;
        ELSE
          next_state <= S6;
        END IF;

      WHEN S7 =>
        IF (MORE ='1') THEN
          next_state <= S8;
        ELSIF (LESS ='1') THEN
          next_state <= S6;
        ELSE
          next_state <= S7;
        END IF;

      WHEN S8 =>
        IF (MORE ='1') THEN
          next_state <= S9;
        ELSIF (LESS ='1') THEN
          next_state <= S7;
        ELSE
          next_state <= S8;
        END IF;

      WHEN S9 =>
        IF (MORE ='1') THEN
          next_state <= S10;
        ELSIF (LESS ='1') THEN
          next_state <= S8;
        ELSE
          next_state <= S9;
        END IF;

      WHEN S10 =>
        IF (MORE ='1') THEN
          next_state <= S11;
        ELSIF (LESS ='1') THEN
          next_state <= S9;
        ELSE
          next_state <= S10;
        END IF;

      WHEN S11 =>
        IF (MORE ='1') THEN
          next_state <= S12;
        ELSIF (LESS ='1') THEN
          next_state <= S10;
        ELSE
          next_state <= S11;
        END IF;

      WHEN S12 =>
        IF (MORE ='1') THEN
          next_state <= S13;
        ELSIF (LESS ='1') THEN
          next_state <= S11;
        ELSE
          next_state <= S12;
        END IF;

      WHEN S13 =>
        IF (MORE ='1') THEN
          next_state <= S14;
        ELSIF (LESS ='1') THEN
          next_state <= S12;
        ELSE
          next_state <= S13;
        END IF;

      WHEN S14 =>
        IF (MORE ='1') THEN
          next_state <= S15;
        ELSIF (LESS ='1') THEN
          next_state <= S13;
        ELSE
          next_state <= S14;
        END IF;

      WHEN S15 =>
        IF (LESS ='1') THEN
          next_state <= S14;
        ELSE
          next_state <= S15;
        END IF;

      WHEN others =>
          next_state <= S0;
		END CASE;

END PROCESS;

Decoder_Section: PROCESS(current_state)

BEGIN
  CASE current_state IS
    WHEN S0 =>
      current_value <= "0000";
    WHEN S1 =>
      current_value <= "0001";
    WHEN S2 =>
      current_value <= "0010";
    WHEN S3 =>
      current_value <= "0011";
    WHEN S4 =>
      current_value <= "0100";
    WHEN S5 =>
      current_value <= "0101";
    WHEN S6 =>
      current_value <= "0110";
    WHEN S7 =>
      current_value <= "0111";
    WHEN S8 =>
      current_value <= "1000";
    WHEN S9 =>
      current_value <= "1001";
    WHEN S10 =>
      current_value <= "1010";
    WHEN S11 =>
      current_value <= "1011";
    WHEN S12 =>
      current_value <= "1100";
    WHEN S13 =>
      current_value <= "1101";
    WHEN S14 =>
      current_value <= "1110";
    WHEN S15 =>
      current_value <= "1111";
  END CASE;
END PROCESS;

END ARCHITECTURE MSM;
