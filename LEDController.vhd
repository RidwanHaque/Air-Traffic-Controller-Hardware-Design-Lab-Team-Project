-- LEDController.VHD
-- 2025.04.14
--
-- SCOMP Peripheral Interface: LED Pattern + Brightness Controller
--
-- Interface Summary:
--   - IO_DATA(15)     : Mode select (0 = direct pattern, 1 = brightness control)
--   - IO_DATA(14–11)  : Brightness level (PWM duty cycle control)
--   - IO_DATA(10)     : Pattern source (0 = user-defined, 1 = predefined pattern)
--   - IO_DATA(9–0)    : LED output pattern (10-bit vector)
--
--   - Bit interpretation allows symbolic LED display with adjustable plane speed simulation.
--   - PWM-based brightness logic active only when IO_DATA(15) = '1'.
--
-- Designed for integration with the DE10-based SCOMP architecture.

LIBRARY IEEE;
LIBRARY LPM;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE LPM.LPM_COMPONENTS.ALL;

ENTITY LEDController IS
PORT(
    CS          : IN  STD_LOGIC;
    WRITE_EN    : IN  STD_LOGIC;
    RESETN      : IN  STD_LOGIC;
    LEDs        : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    IO_DATA     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
	 CLOCK		 : IN  STD_LOGIC
    );
END LEDController;

ARCHITECTURE a OF LEDController IS
 SIGNAL PATTERN : STD_LOGIC_VECTOR(9 DOWNTO 0); --NEW
 SIGNAL COUNT : INTEGER;--NEW
 SIGNAL CHOSEN : STD_LOGIC;
 SIGNAL BRIGHTNESS : STD_LOGIC_VECTOR(3 DOWNTO 0);


BEGIN
	 
    PROCESS (RESETN, CS)
    BEGIN
        IF (RESETN = '0') THEN
            -- Turn off LEDs at reset (a nice usability feature)
            PATTERN <= "0000000000";
				CHOSEN <= '0';
        ELSIF (RISING_EDGE(CS)) THEN
            IF WRITE_EN = '1' THEN
					CHOSEN <= '1'; 
                -- If bit 15 is 0, directly put data on LEDs
					 --Else, change brightness, have a certain pattern, etc.
					 --Bit 15 is a mode select, like do you want the normal LED peripheral built into the SCOMP or do you want to do something special.
					 
					 IF (IO_DATA(15) = '0') THEN
						PATTERN <= IO_DATA(9 DOWNTO 0);
						
					 
					 ELSIF(IO_DATA(15) = '1') THEN
						
						-- Bits 14 to 11 will be brightness control
						-- the pattern must be found first, and then brightness must be checked and done with a state machine
						IF (IO_DATA(14) = '1') THEN
							BRIGHTNESS <= "1000";
							
						ELSIF (IO_DATA(13) = '1') THEN
							BRIGHTNESS <= "0100";
							
						ELSIF (IO_DATA(12) = '1') THEN
							BRIGHTNESS <= "0010";
						
						ELSIF (IO_DATA(11) = '1') THEN
							BRIGHTNESS <= "0001";
							
						ELSE
							BRIGHTNESS <= "0000";
						
						END IF;
						
						
						-- Bit 10 is another mode select, specifically for if you want a predetermined pattern.
						--If not and you only want to incorporate brightness to your original inputted pattern, bit 10 will be 0
						--If you want a predetermined pattern, then bit 10 will be high (1)
						IF (IO_DATA(10) = '0') THEN -- do the original pattern 
							PATTERN <= IO_DATA(9 DOWNTO 0); -- this will be changed later to incorporate brightness, but I don't know it know
							
						ELSIF IO_DATA(10) = '1' THEN -- choose a pattern for user
							
							IF IO_DATA(9) = '1' THEN
								PATTERN <= "0101010101";
					
							
							ELSIF IO_DATA(8) = '1' THEN
								PATTERN <= "1010101010";
							
							
							ELSIF IO_DATA(7) = '1' THEN
								PATTERN <= "0000011111";
							
							
							ELSIF IO_DATA(6) = '1' THEN
								PATTERN <= "1111100000";
					
							
							ELSIF IO_DATA(5) = '1' THEN
								PATTERN <= "1111111111";
						
							
							ELSIF IO_DATA(4) = '1' THEN
								PATTERN <= "0000000000";
							
							ELSIF IO_DATA(3) = '1' THEN
								PATTERN <= "1010110101";
								
							END IF;	
						END IF;
					 END IF;
            END IF;
        END IF;
    END PROCESS;
	 
-- Brightness-Controlled LED Output Process
--
-- This process generates pulse-width modulation (PWM) behavior to simulate different LED brightness levels.
-- It uses a 1000-cycle frame and a counter (COUNT) to determine the LED duty cycle based on a selected brightness level.
	 PROCESS(CLOCK, RESETN) 
	 BEGIN
		IF (RESETN = '0') THEN
			LEDs <= "0000000000";
			COUNT <= 0;
		ELSIF (RISING_EDGE(CLOCK)) THEN
			IF (CHOSEN = '1') THEN
				IF (BRIGHTNESS(3) = '1') THEN -- 80% brightness
					IF (COUNT < 612) THEN
						COUNT <= COUNT + 1;
						LEDs <= PATTERN;
					ELSIF (COUNT < 1000) THEN
						COUNT <= COUNT + 1;
						LEDs <= "0000000000";
					ELSE
						COUNT <= 0;
					END IF;
						
				ELSIF (BRIGHTNESS(2) = '1') THEN -- 60% brightness
					IF (COUNT < 325) THEN
						COUNT <= COUNT + 1;
						LEDs <= PATTERN;
					ELSIF (COUNT < 1000) THEN
						COUNT <= COUNT + 1;
						LEDs <= "0000000000";
					ELSE
						COUNT <= 0;
					END IF;
						
				ELSIF (BRIGHTNESS(1) = '1') THEN  -- 40% brightness
					IF (COUNT < 133) THEN
					  COUNT <= COUNT + 1;
					  LEDs <= PATTERN;
					ELSIF (COUNT < 1000) THEN
					  COUNT <= COUNT + 1;
					  LEDs <= "0000000000";
					ELSE
						COUNT <= 0;
					END IF;

						
				ELSIF (BRIGHTNESS(0) = '1') THEN  --20% brightness
					IF (COUNT < 29) THEN
						COUNT <= COUNT + 1;
						LEDs <= PATTERN;
					ELSIF (COUNT < 1000) THEN
						COUNT <= COUNT + 1;
						LEDs <= "0000000000";
					ELSE
						COUNT <= 0;
					END IF;
						
				ELSE
					LEDs <= PATTERN;
				END IF;
			END IF;
		END IF;
	 END PROCESS;
END a;