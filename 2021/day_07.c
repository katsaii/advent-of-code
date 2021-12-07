#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

#define LIMIT 2000

int main() {
	FILE *file = fopen("in/day_07.txt", "r");
	int min_cost = INT_MAX;
	int min_dest = 0;
	for (int dest = 0; dest < LIMIT; dest += 1) {
		int sum = 0;
		int val;
		while (fscanf(file, "%d,", &val) != EOF) {
			sum += abs(dest - val);
			if (sum > min_cost) {
				break;
			}
		}
		rewind(file);
		if (sum < min_cost) {
			min_cost = sum;
			min_dest = dest;
		}
	}
	fclose(file);
	printf("minimum cost to align crabs to position %d\n%d\n", min_dest, min_cost);
	return 0;
}
