#include <limits.h>
#include <stdlib.h>
#include <stdio.h>
int divide(int dividend, int divisor) {
    // 溢出情況處理
    if (dividend == INT_MIN && divisor == -1) {
        return INT_MAX;
    }

    // 計算結果的符號
    int sign = (dividend > 0) == (divisor > 0) ? 1 : -1;

    // 使用正數進行計算以簡化問題
    long long absDividend = llabs((long long)dividend);
    long long absDivisor = llabs((long long)divisor);

    long long quotient = 0;

    // 當 dividend 大於等於 divisor 時
    while (absDividend >= absDivisor) {
        // 計算 absDividend 和 absDivisor 的前導零數
        int shift = __builtin_clzll(absDivisor) - __builtin_clzll(absDividend);
        if (shift < 0) shift = 0; // 避免負位移
        
        // 根據 shift 左移 divisor
        long long tempDivisor = absDivisor << shift;
        if (tempDivisor > absDividend) {
            tempDivisor = absDivisor << (shift - 1);  // 修正超出範圍的情況
            shift--;
        }

        // 減去相應的倍數，並增加商的值
        absDividend -= tempDivisor;
        quotient += (1LL << shift);
    }

    // 應用符號到結果
    return sign * quotient;
}



void runTestCase(int dividend, int divisor, int expected) {
    int result = divide(dividend, divisor);
    if (result == expected) {
        printf("PASS: divide(%d, %d) = %d\n", dividend, divisor, result);
    } else {
        printf("FAIL: divide(%d, %d) = %d, expected %d\n", dividend, divisor, result, expected);
    }
}

int main() {
    // Test Case 1: Simple division with positive numbers
    // 10 / 2 = 5
    runTestCase(10, 2, 5);

    // Test Case 2: Division where result is not an integer
    // 7 / 3 = 2 (integer division truncates the result)
    runTestCase(7, 3, 2);

    // Test Case 3: Division by 1 should return the dividend
    // 100 / 1 = 100
    runTestCase(100, 1, 100);

    // Test Case 4: Division by -1
    // 100 / -1 = -100
    runTestCase(100, -1, -100);

    // Test Case 5: Division of negative numbers
    // -10 / 2 = -5
    runTestCase(-10, 2, -5);

    // Test Case 6: Both negative numbers
    // -10 / -2 = 5
    runTestCase(-10, -2, 5);

    // Test Case 7: Division of INT_MIN by -1 causes overflow, should return INT_MAX
    // INT_MIN / -1 = INT_MAX (overflow condition)
    runTestCase(INT_MIN, -1, INT_MAX);

    // Test Case 8: Division of INT_MIN by 1 should return INT_MIN
    // INT_MIN / 1 = INT_MIN
    runTestCase(INT_MIN, 1, INT_MIN);

    // Test Case 9: Division by a larger divisor should return 0
    // 1 / 10 = 0
    runTestCase(1, 10, 0);

    // Test Case 10: Division of 0 by any number should return 0
    // 0 / 100 = 0
    runTestCase(0, 100, 0);

    // Test Case 11: Edge case where both dividend and divisor are the same
    // 5 / 5 = 1
    runTestCase(5, 5, 1);

    return 0;
}