;===================================================================
; R0 -> QUOTIENT STORAGE (50H TO 52H)
; R1 -> REMAINDER STORAGE (60H TO 64H) 
; R2 -> USED AS TEMP STORAGE OF SWAPPED REMAINDER FOR OR OPERATION
; R3 -> USED FOR LOOP COUNTER
; R4 -> STORAGE FOR HIGHER BYTE
; R5 -> STORAGE FOR LOWER BYTE

ORG 0H
LJMP START	

ORG 100H
START:
	
	  MOV A, #0AEH; ENTER A 8 BIT VALUE IN HERE 
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
		
SJMP NEXT
		
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

NEXT:
  
END

