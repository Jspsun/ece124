library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity Moore_SM IS Port
(
 clk_input, rst_n				: IN std_logic;
 target_value					: IN std_logic_vector(3 downto 0);
 MORE, LESS, EQUAL			: IN std_logic;
 Main_Clk						: IN std_logic;
 seg7_data						: OUT std_logic_vector(6 downto 0);
 seg7_char1, seg7_char2		: OUT std_logic;
 cnt_up, cnt_done, cnt_down: OUT std_logic;
 current_state_output		: OUT std_logic_vector(3 downto 0)
 );
 

END ENTITY;
 
 Architecture MSM of Moore_SM is

  
   TYPE STATE_NAMES IS (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15); -- list all the STATES

 
   SIGNAL current_state, next_state	:  STATE_NAMES;   -- signals of type STATE_NAMES
 	signal seg7_A			: std_logic_vector(6 downto 0); -- left display
	signal seg7_B			: std_logic_vector(6 downto 0); -- right display
	signal current_value	: std_logic_vector(3 downto 0);
 
	component segment7_mux port (
	  clk 			: 	in std_logic := '0';
	  DIN2			:	in std_logic_vector(6 downto 0);
	  DIN1			:	in std_logic_vector(6 downto 0);
	  DOUT			:	out std_logic_vector(6 downto 0);
	  DIG2			:	out std_logic;
	  DIG1			:	out std_logic
	  );
	end component;

	component SevenSegment port (
	 hex   		:  in  std_logic_vector(3 downto 0);   -- digit 1 shows state number in hex of state machine; if they don't match; it changes
	 sevenseg 	:  out std_logic_vector(6 downto 0)    -- target is sw [3..0] and displayed on right digit
	 ); 
	end component;

BEGIN

INST1: SevenSegment port map(target_value, seg7_A);
INST2: SevenSegment port map(current_value, seg7_B);
INST3: segment7_mux port map(clk_input, seg7_A, seg7_B, seg7_data, seg7_char2, seg7_char1);
current_value <= current_state_output; 
 
 --------------------------------------------------------------------------------
 --State Machine:
 --------------------------------------------------------------------------------
 
-- REGISTER LOGIC PROCESS
-- add clock and any related inputs for state machine register section into Sensitivity List 

Register_Section: PROCESS (Main_Clk, rst_n, next_state)  -- this process synchronizes the activity to a clock
BEGIN
	IF (rst_n = '0') THEN
		current_state <= S0;
	ELSIF(rising_edge(Main_Clk)) THEN
		current_state <= next_State;
	ELSE
		current_state <= current_state;
	END IF;
END PROCESS;	



-- TRANSTION LOGIC PROCESS (to be combinational only)
-- add all transition inputs for state machine into Transition section Sensitivity List 
-- make sure that all conditional statement options are complete otherwise VHDL will infer LATCHES.

Transition_Section: PROCESS (MORE, LESS, EQUAL, current_state) 

BEGIN
     IF (MORE= '1') THEN
		 cnt_up <= '1';
		 cnt_down <= '0';
	  ELSIF (LESS = '1') THEN
	    cnt_up <= '0';
		 cnt_down <= '1';
	  ELSE
	    cnt_up <= '0';
		 cnt_down <= '0';
	  END IF;
	  
	  CASE current_state IS
         WHEN S0 =>		
            current_value <= "0000";
				IF (MORE ='1') THEN 
               next_state <= S1;	
            ELSE 
               next_state <= S0;
            END IF;
			
			WHEN S1 =>				
            current_value <= "0001";
            IF (MORE ='1') THEN 
               next_state <= S2;	
				ELSIF (LESS ='1') THEN
					next_state <= S0;
            ELSE 
               next_state <= S1;
            END IF;
			
			WHEN S2 =>				
            current_value <= "0010";
            IF (MORE ='1') THEN 
               next_state <= S3;	
				ELSIF (LESS ='1') THEN
					next_state <= S1;
            ELSE 
               next_state <= S2;
            END IF;
			
			WHEN S3 =>				
            current_value <= "0011";
            IF (MORE ='1') THEN 
               next_state <= S4;	
				ELSIF (LESS ='1') THEN
					next_state <= S2;
            ELSE 
               next_state <= S3;
            END IF;
			
			WHEN S4 =>				
            current_value <= "0100";
            IF (MORE ='1') THEN 
               next_state <= S5;
				ELSIF (LESS ='1') THEN
					next_state <= S3;
            ELSE 
               next_state <= S4;
            END IF;
			
			WHEN S5 =>				
            current_value <= "0101";
            IF (MORE ='1') THEN 
               next_state <= S6;
				ELSIF (LESS ='1') THEN
					next_state <= S4;
            ELSE 
               next_state <= S5;
            END IF;
			
			WHEN S6 =>				
            current_value <= "0110";
            IF (MORE ='1') THEN 
               next_state <= S7;
				ELSIF (LESS ='1') THEN
					next_state <= S5;
            ELSE 
               next_state <= S6;
            END IF;
				
			WHEN S7 =>			
            current_value <= "0111";
            IF (MORE ='1') THEN 
               next_state <= S8;
				ELSIF (LESS ='1') THEN
					next_state <= S6;
            ELSE 
               next_state <= S7;
            END IF;
			
			 WHEN S8 =>				
            current_value <= "1000";
            IF (MORE ='1') THEN 
               next_state <= S9;	
				ELSIF (LESS ='1') THEN
					next_state <= S7;
            ELSE 
               next_state <= S8;
            END IF;
			
			WHEN S9 =>				
            current_value <= "1001";
            IF (MORE ='1') THEN 
               next_state <= S10;
				ELSIF (LESS ='1') THEN
					next_state <= S8;
            ELSE 
               next_state <= S9;
            END IF;
			
			WHEN S10 =>					
            current_value <= "1010";
            IF (MORE ='1') THEN 
               next_state <= S11;
				ELSIF (LESS ='1') THEN
					next_state <= S9;
            ELSE 
               next_state <= S10;
            END IF;
			
			WHEN S11 =>					
            current_value <= "1011";
            IF (MORE ='1') THEN 
               next_state <= S12;
				ELSIF (LESS ='1') THEN
					next_state <= S10;
            ELSE 
               next_state <= S11;
            END IF;
			
			WHEN S12 =>				
            current_value <= "1100";
            IF (MORE ='1') THEN 
               next_state <= S13;
				ELSIF (LESS ='1') THEN
					next_state <= S11;
            ELSE 
               next_state <= S12;
            END IF;
			
			WHEN S13 =>					
            current_value <= "1101";
            IF (MORE ='1') THEN 
               next_state <= S14;
				ELSIF (LESS ='1') THEN
					next_state <= S12;
            ELSE 
               next_state <= S13;
            END IF;
			
			WHEN S14 =>					
            current_value <= "1110";
            IF (MORE ='1') THEN 
               next_state <= S15;	
				ELSIF (LESS ='1') THEN
					next_state <= S13;
            ELSE 
               next_state <= S14;
            END IF;
				
			WHEN S15 =>					
            current_value <= "1111";
				IF (LESS ='1') THEN
					next_state <= S14;
            ELSE 
               next_state <= S15;
            END IF;
			
         WHEN others =>
               next_state <= S0;
		END CASE;
		
		
 END PROCESS;

Decoder_Section: cnt_done <= '1' when current_value = target_value else '0';


END ARCHITECTURE MSM;
