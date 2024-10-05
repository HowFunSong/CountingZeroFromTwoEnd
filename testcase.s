# Test Case 1: Simple division with positive numbers
# Input: dividend = 10, divisor = 2
# Expected Output: result = 5
# dividend = 10
# divisor = 2
# Call divide

# Test Case 2: Division with non-integer result (truncate)
# Input: dividend = 7, divisor = 3
# Expected Output: result = 2
# dividend = 7
# divisor = 3
# Call divide

# Test Case 3: Division by 1
# Input: dividend = 100, divisor = 1
# Expected Output: result = 100
# dividend = 100
# divisor = 1
# Call divide

# Test Case 4: Division by -1
# Input: dividend = 100, divisor = -1
# Expected Output: result = -100
# dividend = 100
# divisor = -1
# Call divide

# Test Case 5: Division with negative dividend
# Input: dividend = -10, divisor = 2
# Expected Output: result = -5
# dividend = -10
# divisor = 2
# Call divide

# Test Case 6: Both negative
# Input: dividend = -10, divisor = -2
# Expected Output: result = 5
# dividend = -10
# divisor = -2
# Call divide

# Test Case 7: Overflow case (INT_MIN / -1)
# Input: dividend = INT_MIN, divisor = -1
# Expected Output: result = INT_MAX
# dividend = -2147483648 (INT_MIN)
# divisor = -1
# Call divide

# Test Case 8: Large divisor (result = 0)
# Input: dividend = 1, divisor = 10
# Expected Output: result = 0
# dividend = 1
# divisor = 10
# Call divide

# Test Case 9: Zero dividend
# Input: dividend = 0, divisor = 100
# Expected Output: result = 0
# dividend = 0
# divisor = 100
# Call divide

# Test Case 10: Same dividend and divisor
# Input: dividend = 5, divisor = 5
# Expected Output: result = 1
# dividend = 5
# divisor = 5
# Call divide
