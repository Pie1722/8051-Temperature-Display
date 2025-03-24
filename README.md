# Temperature-Display-using-8051
 This project was programmed in keil uVision 5 and the simulation was done is Proteus

# Circuit Schematic

 ![image](https://github.com/user-attachments/assets/8714311c-b4a4-4a83-b304-25cd86ac6d96)

# Registers Used In 8051

R0 -> QUOTIENT STORAGE (50H TO 52H)
R1 -> REMAINDER STORAGE (60H TO 64H) 
R2 -> USED AS TEMP STORAGE OF SWAPPED REMAINDER FOR OR OPERATION
R3 -> USED FOR LOOP COUNTER
R4 -> STORAGE FOR HIGHER BYTE
R5 -> STORAGE FOR LOWER BYTE

ASCII_LCD =======================
R0 -> USED FOR GETTING VALUES FROM 64H TO 60H 
R7 -> USED FOR LOOP COUNTER

DELAY ==========================
R3 & R4 USED FOR LOOP COUNTER 

