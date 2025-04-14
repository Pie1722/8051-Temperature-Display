# Temperature-Display-using-8051
 This project was programmed in keil uVision 5 and the simulation was done is Proteus

 It requires coversion if 16 bit hexadecimal number to decimal number. Multiplication of the values getting from ADC with constant 59 is required for the proper values to be converted.

 LM35 sensor max output is 255 Decimal or FF HEX at 150°C. The LM35 gives output of 10mV/°C with a maximum of 1.5V at 150°C.
 
 Vref/2 of ADC0804 has input of 0.79V. I wanted to give Vref/2 0.75V for the vref to be 1.5V which is equal to the output of LM35 but practically i didnt had enough components so I used 0.79V as vref/2.
 
 So vref is 1.58 and i.e 1.58/256 = 0.006177875 for which we store 61 as constant at the start of multiplication.
 
 The code for conversion of HEX to DECIMAL is provided at KEIL_DIV Folder.

# Delay Calculation:

To estimate the total time delay, we assume the 8051 runs with a 12 MHz clock, and each instruction takes 1 machine cycle (1 µs) unless otherwise stated.

   Loop counts:

   Inner loop (D1): 250 iterations

   Middle loop (D2): 250 iterations

   Outer loop (D3): 20 iterations

Total iterations of DJNZ R3, D1 = 250
Total iterations of DJNZ R4, D2 = 250
Total iterations of DJNZ R5, D3 = 20

So, the total number of DJNZ R3, D1 executions = 250 × 250 × 20 = 1,250,000

Each DJNZ R3, D1 takes 2 µs →
1,250,000 × 2 µs = 2.5 seconds

R4 and R5 add neglibile delay so it is around 2.5s to 2.6s
To generate perfect delay usage of timer is required.

# Circuit Schematic

 ![image](https://github.com/user-attachments/assets/8714311c-b4a4-4a83-b304-25cd86ac6d96)

 

https://github.com/user-attachments/assets/7c52b8ff-2e1d-4e30-a17e-e1210c6bced4




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

R3 & R4 & R5 USED FOR LOOP COUNTER 

