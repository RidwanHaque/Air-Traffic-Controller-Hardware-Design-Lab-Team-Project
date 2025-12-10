; SCOMP Assembly Program - Simulated Airplane Highways at ATL
;
; This program symbolically represents air traffic control scenarios using LEDs as
; "airplane highways" into and out of Atlanta International Airport (ATL).
;
; - LEDs 9–5 represent inbound airplane highways into ATL
; - LEDs 4–0 represent outbound airplane highways from ATL
; - Brightness level (bits 14–11) represents plane speed
;
; Each step simulates a realistic decision an air traffic controller might make,
; such as slowing traffic, restricting access, or issuing emergency clearance.


; Scenario 1: Normal day, good weather
; All lanes open at 100% plane speed
    LOAD Value1
    OUT LEDs
    CALL Delay
 
; Scenario 2: Normal day, good weather
; All lanes open at 20% plane speed
    LOAD Value2
    OUT LEDs
    CALL Delay
    
; Scenario 3: Jetstream into ATL
; Left half open only, but 40% plane speed for safety
    LOAD Value3
    OUT LEDs
    CALL Delay
    
; Scenario 4: Jetstream into ATL
; Left half open only, but 80% plane speed 
    LOAD Value4
    OUT LEDs
    CALL Delay

; Scenario 5: Military presence restricts part of airspace
; Alternating lanes open, 20% plane speed
    LOAD Value5
    OUT LEDs
    CALL Delay
    
; Scenario 6: Military presence restricts part of airspace
; Alternating lanes open, 60% plane speed
    LOAD Value6
    OUT LEDs
    CALL Delay
    
; Scenario 7: Randomish lanes open, 40% plane speed  
    LOAD Value7
    OUT LEDs
    CALL Delay
    
; Scenario 8: Same lanes, 100% plane speed   
    LOAD Value8
    OUT LEDs
    CALL Delay
    
; Scenario 9: Manual override: one airplane highway into ATL and one out
; Lanes 0 and 9 open, 60% plane speed
    LOAD Value9
    OUT LEDs
    CALL Delay
 
; Scenario 10: Manual override: one airplane highway into ATL and one out
; Lanes 0 and 9 open, 20% plane speed
    LOAD Value10
    OUT LEDs
    CALL Delay
 
; Scenario 11: Full shutdown
    LOAD Value11
    OUT LEDs
    CALL Delay
    
; Loop to freeze the final state	
InfiniteLoop:
	JUMP InfiniteLoop
	
; Delay: Provides time between scenarios
Delay:
	OUT    Timer
WaitingLoop:
	IN     Timer
	ADDI   -150 ; 15 seconds
	JNEG   WaitingLoop
	RETURN    


; Data values with symbolic pattern mapping
Value1: DW &H8420 ; All lanes open, 100% speed 
Value2: DW &H8C20 ; All lanes open, 20% speed 
Value3: DW &H9440 ; Left half lanes open, 40% speed 
Value4: DW &HC440 ; Left half lanes open, 80% speed
Value5: DW &H8E00 ; Alternating lanes open, 20% speed
Value6: DW &HA600 ; Alternating lanes open, 60% speed
Value7: DW &H9408 ; Randomish lanes open, 40% spped
Value8: DW &H8408 ; Randomish lanes open, 100% spped
Value9: DW &HA201 ; Manually decided lanes by air traffic controllor are open, 60% speed
Value10: DW &H8A01 ; Manually decided lanes by air traffic controllor are open, 20% speed
Value11: DW &H8410 ; All lanes off 


LEDS: 	   EQU 032 ; LED peripheral I/O address
Timer:     EQU 002 ; Timer I/O address


