# Temperature-Display-using-8051
 This project was programmed in keil uVision 5 and the simulation was done is Proteus

 It requires coversion if 16 bit hexadecimal number to decimal number. Multiplication of the values getting from ADC with constant 59 is required for the proper values to be converted.

 LM35 sensor max output is 255 Decimal or FF HEX at 150°C . So 150/255 = 0.5882352941176471 for which we store 59 as constant at the start of multiplication.
 The code for conversion of HEX to DECIMAL is provided at KEIL_DIV Folder.


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

