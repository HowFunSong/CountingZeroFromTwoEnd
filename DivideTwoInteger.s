    .data
dividend:    .word -70              # Dividend
divisor:     .word 11               # Divisor
result:      .word 0                # Store result
msg1: .string "the dividend is "    # Message 1
msg2: .string "the divisor is "     # Message 2
msg3: .string "quotient is "        # Message 3
msg4: .string "\n"                  # Newline character

    .text
    .globl _start
_start:
    # Load dividend and divisor into a0 and a1
    lw a0, dividend         # a0 = dividend
    lw a1, divisor          # a1 = divisor

    jal divide              # Call the divide function

    jal printResult         # Call printResult to display dividend, divisor, and result
    
    # Exit the program
    li a7, 10               # System call 10 = program exit
    ecall

divide:
    addi sp, sp, -4         # Adjust stack pointer, make room to save ra
    sw ra, 0(sp)            # Save ra to stack

    # Move a0 and a1 values to temporary registers
    mv t0, a0               # t0 = dividend
    mv t1, a1               # t1 = divisor

    # Handle overflow case (dividend == INT_MIN && divisor == -1)
    li t2, 0x80000000       # INT_MIN
    li t3, -1               # -1
    beq t0, t2, check_overflow

skip_overflow:
    # Calculate the sign of the result
    li t2, 0                # t2 = sign
    slt t4, x0, t0          # t4 = (dividend > 0)
    slt t5, x0, t1          # t5 = (divisor > 0)
    xor t4, t4, t5          # t4 = t4 ^ t5
    beq t4, x0, positive_sign
    li t2, -1               # Result should be negative
    j compute_abs

positive_sign:
    li t2, 1                # Result should be positive

compute_abs:
    # Convert dividend and divisor to positive
    bge t0, x0, abs_dividend
    neg t0, t0              # abs(dividend)

abs_dividend:
    bge t1, x0, abs_divisor
    neg t1, t1              # abs(divisor)

abs_divisor:
    mv s0, t0               # absDividend -> s0
    mv s1, t1               # absDivisor -> s1
    li s2, 0                # quotient = 0
    li s4, 1                # s4 = 1 (for shifting)

division_loop:
    blt s0, s1, done        # If absDividend < absDivisor, jump to done

    # Calculate shift amount
shift_computation:
    # Call my_clz to calculate leading zeros of absDivisor and absDividend
    mv t0, s1               # Move absDivisor to t0
    jal my_clz              # Call my_clz
    mv t4, t0               # Store the result in t4

    mv t0, s0               # Move absDividend to t0
    jal my_clz              # Call my_clz
    mv t5, t0               # Store the result in t5

    sub t6, t4, t5          # shift = clz(absDivisor) - clz(absDividend)

    blt t6, x0, adjust_shift_zero

    sll s3, s1, t6          # tempDivisor = absDivisor << shift
    blt s3, s0, no_shift_adjustment
    j shift_adjustment

adjust_shift_zero:
    li t6, 0                # shift = 0

no_shift_adjustment:
    sll s3, s1, t6          # tempDivisor = absDivisor << shift
    sub s0, s0, s3          # absDividend -= tempDivisor
    sll t4, s4, t6          # t4 = 1 << shift
    add s2, s2, t4          # quotient += t4
    j division_loop

shift_adjustment:
    sub t6, t6, s4          # shift--
    sll s3, s1, t6          # tempDivisor = absDivisor << (shift - 1)
    sub s0, s0, s3          # absDividend -= tempDivisor
    sll t4, s4, t6          # t4 = 1 << shift
    add s2, s2, t4          # quotient += t4
    j division_loop

done:
    mul t0, s2, t2          # Apply the sign
    la t1, result
    sw t0, 0(t1)            # Store the result (quotient)

    lw ra, 0(sp)            # Restore ra from stack
    addi sp, sp, 4          # Restore stack pointer
    ret                     # Return to main program

check_overflow:
    beq t1, t3, handle_overflow
    j skip_overflow

handle_overflow:
    li t0, 0x7FFFFFFF       # INT_MAX
    la t1, result
    sw t0, 0(t1)            # Store INT_MAX as the result

    lw ra, 0(sp)            # Restore ra from stack
    addi sp, sp, 4          # Restore stack pointer
    ret                     # Directly return

# clz function: calculates leading zeros
my_clz:
    addi sp, sp, -12        # Adjust stack pointer, make room to save t1, t2, t3
    sw t1, 0(sp)            # Save t1
    sw t2, 4(sp)            # Save t2
    sw t3, 8(sp)            # Save t3

    li t1, 0                # Initialize counter t1 to 0
    li t2, 31               # Set bit position (starting from 31)

clz_loop:
    beqz t0, clz_done       # If t0 is 0, jump to clz_done
    srli t3, t0, 31         # Check if the highest bit is 1
    bnez t3, clz_done       # If highest bit is 1, jump to clz_done
    addi t1, t1, 1          # Increment counter
    slli t0, t0, 1          # Shift t0 left, check the next bit
    addi t2, t2, -1         # Decrease bit position
    j clz_loop              # Jump back to clz_loop

clz_done:
    mv t0, t1               # Store the result (leading zero count) in t0

    # Restore saved registers (not restoring t0)
    lw t1, 0(sp)
    lw t2, 4(sp)
    lw t3, 8(sp)

    addi sp, sp, 12         # Restore stack pointer
    ret                     # Return to caller

# printResult function: prints the dividend, divisor, and quotient
printResult:
    # Print "the dividend is "
    la a0, msg1             # Load address of message1
    li a7, 4                # syscall for printing string
    ecall

    # Print the dividend
    lw a0, dividend         # Load dividend value
    li a7, 1                # syscall for printing integer
    ecall

    # Print newline
    la a0, msg4             # Load address of newline
    li a7, 4                # syscall for printing string
    ecall

    # Print "the divisor is "
    la a0, msg2             # Load address of message2
    li a7, 4                # syscall for printing string
    ecall

    # Print the divisor
    lw a0, divisor          # Load divisor value
    li a7, 1                # syscall for printing integer
    ecall

    # Print newline
    la a0, msg4             # Load address of newline
    li a7, 4                # syscall for printing string
    ecall

    # Print "quotient is "
    la a0, msg3             # Load address of message3
    li a7, 4                # syscall for printing string
    ecall

    # Print the quotient
    lw a0, result           # Load quotient from result
    li a7, 1                # syscall for printing integer
    ecall

    # Print newline
    la a0, msg4             # Load address of newline
    li a7, 4                # syscall for printing string
    ecall

    ret                     # Return to the caller
