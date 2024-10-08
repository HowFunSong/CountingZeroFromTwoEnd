#include <stdio.h>

int minMoves(int target, int maxDoubles) {
    int moves = 0;

    while (target != 1) {
        if (maxDoubles == 0) {
            moves += target - 1;
            break;
        }

        // Equivalent of checking if the number is even and maxDoubles > 0
        while (maxDoubles > 0 && (target & 1) == 0) {
            target >>= 1;
            maxDoubles--;
            moves++;
        }

        // If target is not 1, decrement target by 1 and increment moves
        if (target != 1) {
            target--;
            moves++;
        }
    }

    return moves;
}

int main() {
    int target = 10;
    int maxDoubles = 4;
    int result = minMoves(target, maxDoubles);
    printf("Minimum moves: %d\n", result);
    return 0;
}
