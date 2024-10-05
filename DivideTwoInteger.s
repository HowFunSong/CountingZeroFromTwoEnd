.section .data
dividend:    .word 0
divisor:     .word 0
result:      .word 0

.section .text
.globl divide
divide:
    # Function arguments
    lw t0, dividend         # t0 = dividend
    lw t1, divisor          # t1 = divisor
    
    # Overflow case handling (dividend == INT_MIN && divisor == -1)
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
    li t2, -1               # result should be negative
    j compute_abs

positive_sign:
    li t2, 1                # result should be positive

compute_abs:
    # Convert dividend and divisor to positive
    li t3, -1
    bge t0, x0, abs_dividend
    neg t0, t0              # abs(dividend)

abs_dividend:
    bge t1, x0, abs_divisor
    neg t1, t1              # abs(divisor)

abs_divisor:
    mv t6, t0               # absDividend
    mv t7, t1               # absDivisor
    li t8, 0                # quotient = 0

division_loop:
    bge t6, t7, shift_computation
    j done                  # If absDividend < absDivisor, exit

shift_computation:
    # Calculate leading zeros (clz t7 and clz t6)
    clz t4, t7              # clz(absDivisor)
    clz t5, t6              # clz(absDividend)
    sub t9, t4, t5          # shift = clz(absDivisor) - clz(absDividend)

    blt t9, x0, no_shift_adjustment
    slli t10, t7, t9        # tempDivisor = absDivisor << shift
    bge t10, t6, shift_adjustment

no_shift_adjustment:
    slli t10, t7, t9        # tempDivisor = absDivisor << shift
    sub t6, t6, t10         # absDividend -= tempDivisor
    slli t11, x1, t9        # quotient += (1LL << shift)
    add t8, t8, t11
    j division_loop

shift_adjustment:
    sub t9, t9, x1          # shift--
    slli t10, t7, t9        # tempDivisor = absDivisor << (shift - 1)
    sub t6, t6, t10         # absDividend -= tempDivisor
    slli t11, x1, t9        # quotient += (1LL << shift)
    add t8, t8, t11
    j division_loop

done:
    mul t0, t8, t2          # Apply the sign
    sw t0, result           # Store the result
    ret                     # Return

check_overflow:
    beq t1, t3, handle_overflow
    j skip_overflow

handle_overflow:
    li t0, 0x7FFFFFFF       # INT_MAX
    sw t0, result           # Store INT_MAX as the result
    ret
