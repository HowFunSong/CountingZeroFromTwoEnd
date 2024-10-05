   .data
num:    .word 0x00FFFFFF       # Test number 0x00000001 (you can modify this)
result: .word 0                # Variable to store the result

msg1: .string "Number: "
msg2: .string "Leading zeros count: "
msg3: .asciz "\n"

    .text
    .globl _start
_start:
    # Load the number into t0
    la t0, num                 # Load the address of num
    lw t0, 0(t0)               # Load the number from memory into t0

    # Call clz function to calculate leading zeros
    jal ra, my_clz
    
    # Store the result in memory
    la t1, result              # Load the address of result
    sw t0, 0(t1)               # Store the result in memory
    
    # Call printResult function to print the number and leading zero count
    mv a1, t0                  # a1 = result (leading zero count)
    
    la t0, num                 # Load the address of num
    lw a0, 0(t0)               # Load the number into a0 = num
    
    jal ra, printResult        # Call printResult to print num and result
    
    # Exit the program
    li a7, 10                  # System call 10 = ecall for exit
    ecall

# clz function: calculates leading zeros
my_clz:
    li t1, 31                  # Initialize the counter (t1) to 31 (for bit positions 31 to 0)
    
clz_loop:
    slli t3, t0, 0             # Move the number into t3 without shifting to start check
    srl t3, t0, t1            # Shift the number t0 by t1 bits to the right
    andi t3, t3, 1             # Mask to check if the highest bit is 1 after shifting
    bnez t3, clz_done          # If the highest bit is 1, go to clz_done
    
    addi t1, t1, -1            # Decrement the counter (next bit position)
    bgez t1, clz_loop          # If t1 >= 0, repeat the loop

clz_done:
    li  t2, 31                 # Load 31 into t2
    sub t0, t2, t1             # Calculate leading zero count: 31 - t1
    ret                        # Return to the caller


# printResult function: prints the number and the leading zeros count
printResult:
    mv t0, a0                  # Store num in t0
    mv t1, a1                  # Store result (leading zero count) in t1
    
    # Print "Number: "
    la a0, msg1                # Load the address of the first message ("Number: ")
    li a7, 4                   # System call code for printing a string
    ecall                      # Print the string
    
    # Print the number (num)
    mv a0, t0                  # Move the number to a0
    li a7, 1                   # System call for printing an integer (modify this based on your environment)
    ecall                      # Print the number
    
    # Print newline "\n"
    la a0, msg3                # Load the address of the newline message ("\n")
    li a7, 4                   # System call code for printing a string
    ecall                      # Print the newline
    
    # Print "Leading zeros count: "
    la a0, msg2                # Load the address of the second message ("Leading zeros count: ")
    li a7, 4                   # System call code for printing a string
    ecall                      # Print the string
    
    # Print the result (leading zero count)
    mv a0, t1                  # Move the result to a0
    li a7, 1                   # System call for printing an integer (modify this based on your environment)
    ecall                      # Print the result
    
    ret                        # Return to the caller