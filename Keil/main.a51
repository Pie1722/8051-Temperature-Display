;===================================================================
; R0 -> QUOTIENT STORAGE (50H TO 52H)
; R1 -> REMAINDER STORAGE (60H TO 64H) 
; R2 -> USED AS TEMP STORAGE OF SWAPPED REMAINDER FOR OR OPERATION
; R3 -> USED FOR LOOP COUNTER
; R4 -> STORAGE FOR HIGHER BYTE
; R5 -> STORAGE FOR LOWER BYTE

; ASCII_LCD =======================
; R0 -> USED FOR GETTING VALUES FROM 64H TO 60H 
; R7 -> USED FOR LOOP COUNTER

; DELAY ==========================
; R3 & R4 USED FOR LOOP COUNTER 

ORG 0H
LJMP START	

ORG 100H
START:

;-------------------------------------
;LCD INITIALIZATION ------------------
;-------------------------------------

    MOV A, #38H   ; Initialize LCD for 2 lines, 5x7 matrix
    LCALL COMNWRT
    MOV A, #0CH   ; Display ON, Cursor OFF, Blink OFF
    LCALL COMNWRT
    MOV A, #01H   ; Clear LCD display
    LCALL COMNWRT
    MOV A, #06H   ; Shift cursor to the right
    LCALL COMNWRT
    MOV A, #80H   ; Set cursor at Line 1, Column 1 (Corrected)
    LCALL COMNWRT        ; Call command write subroutine
    MOV A, #'T'          ; Display letter 'T'
    LCALL DATAWRT        ; Call data write subroutine
    MOV A, #'E'          ; Display letter 'E'
    LCALL DATAWRT        ; Call data write subroutine
    MOV A, #'M'          ; Display letter 'M'
    LCALL DATAWRT        ; Call data write subroutine
    MOV A, #'P'          ; Display letter 'P'
    LCALL DATAWRT        ; Call data write subroutine
    MOV A, #'E'          ; Display letter 'E'
    LCALL DATAWRT        ; Call data write subroutine
    MOV A, #'R'          ; Display letter 'R'
    LCALL DATAWRT        ; Call data write subroutine
    MOV A, #'A'          ; Display letter 'A'
    LCALL DATAWRT        ; Call data write subroutine
    MOV A, #'T'          ; Display letter 'T'
    LCALL DATAWRT        ; Call data write subroutine
    MOV A, #'U'          ; Display letter 'U'
    LCALL DATAWRT        ; Call data write subroutine
    MOV A, #'R'          ; Display letter 'R'
    LCALL DATAWRT        ; Call data write subroutine
    MOV A, #'E'          ; Display letter 'E'
    LCALL DATAWRT        ; Call data write subroutine
    MOV A, #':'          ; Display colon ':'
    LCALL DATAWRT        ; Call data write subroutine
    MOV A, #'-'          ; Display '-'
    LCALL DATAWRT        ; Call data write subroutine
    MOV A, #0C8H         ; Set cursor at line 2, position 1
    LCALL COMNWRT        ; Call command write subroutine
    MOV A,#0DFH		 ; Degree Symbol
    LCALL DATAWRT
    MOV A,#'C'			
    LCALL DATAWRT

;================================================================

   ; LABELS FOR PINS OF ADC 0804
      
	CS BIT P3.0
	RD_PIN BIT P3.1
	WR_PIN BIT P3.2
	INTR BIT P3.3
	OUTPUT EQU P1
	
	MOV OUTPUT, #0FFH ; Configure P1 as input
	
LOOP:
	
	MOV A, #0C2H         ; Set cursor at line 2, position 1
	LCALL COMNWRT        ; Call command write subroutine
	
	;---- ADC 0804 ---------------------------------------
	
	 CLR CS                 ; Select ADC (Active Low)
	 CLR WR_PIN             ; WR = 0 (Start conversion)
	 SETB WR_PIN            ; WR = 1 (End write - Start conversion)
	 SETB CS
     
	 JB INTR, $     ; Wait for conversion to complete (INTR = 0 means busy)

	 ; Once INTR is high, conversion is done
	 CLR CS                 ; Keep CS low during read (select ADC)
	 CLR RD_PIN             ; RD = 0 (Initiate ADC read)
	 NOP
	 MOV A, OUTPUT          ; Store ADC data in Accumulator (A)
	 ;MOV P0, A		; CHECK OUTPUT AT PORT 0 FOR DEBUGGING
	 SETB RD_PIN             ; RD = 0 (Initiate ADC read)
	 SETB CS                ; Deselect ADC (CS = 1)

	;-----------------------------------------------------
	        ;MOV A, #0AEH;
		  
		MOV B, #59; CONST 59 LM35 (150/255)
		MUL AB; MULTIPLY CONST AND O/P OF PORT1
		MOV R4, B; MOVE HIGHER BYTE TO R4
		MOV R5, A; MOVE LOWER BYTE TO R5
		
		MOV R0, #50H; QUOTIENT STORAGE
		MOV R1,#60H; REMAINDER STORAGE
		
	;------------------------------------------------------
	
		DIV_LOOP:
			ACALL DIVV; CALL THE DIV SUBROUTINE AT LINE 39
			MOV R4, 50H; MOVE THE FIRST QUOTIENT TO R4
			MOV A, 51H; MOVE THE SECOND QUOTIENT TO A
			SWAP A; SWAP THE BITS OF ACC EX- 1000 0010 = 0010 1000
			ORL A, 52H; OR OPERATION FOR ADDING THE PAST REMAINDER WITH NEW DIVIDEND 
			MOV R5, A; MOVE THE NEW DIVIDEND TO LOWER BYTE (ALSO THE FINAL QUOTIENT)
			MOV R0, #50H; RESET THE R0 REGISTER FOR STORING THE QUOTIENT OF NEXT NUMBERS
			INC R1; increment for storing all the remainders
			MOV @R1, A; SAVE THE QUOTIENT 
			MOV A, R4; MOVE THE FIRST QUOTIENT TO ACC FOR CHECKING 
			JNZ DIV_LOOP ; IF THE ACC IN NOT ZERO THEN CONTINUE LOOP ELSE NEXT LINE
			MOV A, R5; final quotient
			CLR C; CLEAR THE CARRY FLAG FOR SUBB
			SUBB A,#0AH; CHECK IF THE QUOTIENT IS LESS THAN 0AH TO SEE IF ITS DECIMAL OR NOT
			JNC DIV_LOOP; IF CARRY IS NOT SET , THEN CONTINUE DIVISION , IF CARRY IS SET THE FINAL QUOTIENT IS DECIMAL			
			
		ACALL ASCII_LCD; CALL THE ASCII SUBROUTINE TO CONVERT DECIMAL INTO ASCII AND PRINT IN LCD
		
		; CLEAR THE 64H AND 63H MEMORY LOCATION TO CLEAR THE MEMORY IF THE NEXT NUMBER DOES NOT OVERWRITE -
		; - THE DATA OF THE MEMORY LOCATION THEN THE PAST DATA WILL BE THERE AND THE TEMPERATURE WONT BE CORRECLTY DISPLAYED
		MOV 64H, #00H
		MOV 63H, #00H
		
SJMP LOOP ; CONTINUE THE LOOP FOREVER
		
;-------------------------------------------------------------------------------------------------------------


;-------------------------------
; DIVISION SUBROUTINE
;-------------------------------

		DIVV:
			MOV A, R4; MOVE HIGHER BYTE TO ACC FOR FIRST DIV
			MOV B, #0AH; MOVE 10 TO B
			MOV R3, #3; LOOP COUNTER FOR DIVISIONS
			JUUMP: 
				DIV AB; DIV A WITH 0x0A
				MOV @R0, A; SAVE QUOTIENT FROM 0x50
				INC R0; INCREMENT FOR THE NEXT QUOTIENT
				MOV @R1, B; SAVE THE REMAINDER FROM 0x60
				MOV A, @R1; MOVE THE REMAINDER TO A FOR SWAPPING THE BITS
				SWAP A; SWAP THE BITS OF ACC EX- 1000 0010 = 0010 1000
				MOV R2, A; SAVE THE BYTE TO R2 FOR FURTHER OPERATION
				MOV A, R5; MOVE THE LOWER BYTE FOR DIVISION
				MOV B,#10H 
				DIV AB; DIVIDE THE NUM WITH 10H
	
				CJNE R3, #2, SKIP
				MOV A, B
	
				SKIP:
					ORL A,R2; ORL OPERATION TO ADD 
					MOV B, #0AH; MOVE 0AH FOR NEXT DIVISION
					CLR C; CLEAR THE CARRY FLAG
			DJNZ R3, JUUMP; KEEP THE LOOP FOR 3 ITERATIONS
		RET
		
;======================================
; ASCII SUBROUTINE
;=======================================
		
ASCII_LCD:
   MOV R0, #64H			
   MOV R7, #5
			
   JUMP_ASCII:	
      MOV A, @R0
      ADD A, #30H
      LCALL DATAWRT        ; Call data write subroutine
      DEC R0
      CJNE R7, #3, JMPP
      MOV A,#"."
      LCALL DATAWRT
      JMPP:DJNZ R7, JUMP_ASCII
RET	

; ==============================
; Command Write Subroutine
; ============================
COMNWRT:
    ACALL DELAY          ; Prepare for sending command to LCD
    MOV P2, A            ; Copy content of register A to port 1
    CLR P3.4             ; Set RS = 0 for command mode
    CLR P3.5             ; Set R/W = 0 for write mode
    SETB P3.6            ; Set E high for pulse
    CLR P3.6             ; Set E low for H-to-L pulse
    RET

; =============================
; Data Write Subroutine
; =============================
DATAWRT:
    ACALL DELAY          ; Prepare for writing data to LCD
    MOV P2, A            ; Copy content of register A to port 2
    SETB P3.4            ; Set RS = 1 for data mode
    CLR P3.5             ; Set R/W = 0 for write mode
    SETB P3.6            ; Set E high for pulse
    CLR P3.6             ; Set E low for H-to-L pulse
    RET


; =============================
; Delay Subroutine
; =============================
DELAY:
    MOV R3, #10          ; Set outer loop count (50 or higher for fast CPUs)
HERE2:
    MOV R4, #30         ; Set inner loop count (255)
HERE:
    DJNZ R4, HERE        ; Decrement R4 and repeat until it reaches 0
    DJNZ R3, HERE2       ; Decrement R3 and repeat until it reaches 0
    RET
	
END
