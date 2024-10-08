.data
target:       .word 10          # Initial target value, can be modified
maxDoubles:   .word 4           # Maximum number of times we can divide by 2
moves:        .word 0           # Record the number of moves
msg_result:   .string "Minimum moves: "
newline:      .string "\n"

.text
.globl _start
_start:
    # Initialization
    la t0, target        # Load address of target into t0
    lw t1, 0(t0)         # t1 = value of target

    la t0, maxDoubles    # Load address of maxDoubles into t0
    lw t2, 0(t0)         # t2 = value of maxDoubles

    li t3, 0             # t3 = moves, initialize to 0
    li s1, 1             # s1 = 1, used to compare if target equals 1

main_loop:
    beq t1, s1, end_loop  # If target == 1, exit the loop

    beqz t2, no_doubles  # If maxDoubles == 0, jump to no_doubles

    # Check the number of trailing zeros in target
    mv a0, t1            # Pass the target value to my_cbz function
    jal ra, my_cbz       # Call my_cbz function, result is in t0

    beqz t0, not_even    # If the number of trailing zeros is 0, target is odd, jump to not_even

    # Calculate the actual number of times we can divide by 2
    mv t4, t0            # t4 = number of trailing zeros
    bge t4, t2, limit_doubles  # If trailing zeros >= maxDoubles, limited by maxDoubles

    # The actual number of divisions is t4
    j perform_divide

limit_doubles:
    mv t4, t2            # The actual number of divisions is maxDoubles

perform_divide:
    # Update target, perform division by 2 t4 times
    srl t1, t1, t4       # target >>= t4
    sub t2, t2, t4       # maxDoubles -= t4
    add t3, t3, t4       # moves += t4
    j main_loop          # Return to main loop

not_even:
    # target is odd, cannot divide by 2, need to subtract 1
    addi t1, t1, -1      # target--
    addi t3, t3, 1       # moves++
    j main_loop          # Return to main loop

no_doubles:
    # maxDoubles == 0, need to decrement target to 1 directly
    addi t4, t1, -1      # t4 = target - 1
    add t3, t3, t4       # moves += target - 1

    j end_loop

end_loop:
    # Store the result moves into memory
    la t0, moves
    sw t3, 0(t0)

    # Print the result
    la a0, msg_result
    li a7, 4             # System call: print string
    ecall

    mv a0, t3            # a0 = moves
    li a7, 1             # System call: print integer
    ecall

    # Print newline
    la a0, newline
    li a7, 4
    ecall

    # Exit the program
    li a7, 10
    ecall

# my_cbz function: calculate number of trailing zeros
my_cbz:
    addi sp, sp, -4       # Adjust stack pointer, allocate space to save t3
    sw t3, 0(sp)          # Save t3

    li t5, 0              # t5 = counter, initialize to 0
    mv t6, a0             # t6 = input value

cbz_loop:
    andi t3, t6, 1        # Check if the least significant bit is 1
    bnez t3, cbz_done     # If the least significant bit is 1, exit loop
    addi t5, t5, 1        # Increment counter
    srli t6, t6, 1        # Shift right by one bit
    bnez t6, cbz_loop     # If t6 is not zero, continue loop
    j cbz_done

cbz_done:
    mv t0, t5             # Return the count result
    lw t3, 0(sp)          # Restore t3
    addi sp, sp, 4        # Restore stack pointer
    ret
