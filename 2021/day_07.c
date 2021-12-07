#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

#define LIMIT 2000

int main() {
	FILE *file = fopen("in/day_07.txt", "r");
	int min_cost = INT_MAX;
	int min_dest = 0;
	int min_cost_expensive = INT_MAX;
	int min_dest_expensive = 0;
	for (int dest = 0; dest < LIMIT; dest += 1) {
		int sum = 0;
		int sum_expensive = 0;
		int val;
		while (fscanf(file, "%d,", &val) != EOF) {
			int dist = abs(dest - val);
			sum += dist;
			sum_expensive += dist * (dist + 1) / 2;
		}
		rewind(file);
		if (sum < min_cost) {
			min_cost = sum;
			min_dest = dest;
		}
		if (sum_expensive < min_cost_expensive) {
			min_cost_expensive = sum_expensive;
			min_dest_expensive = dest;
		}
	}
	fclose(file);
	printf("minimum cost to align crabs to position %d\n%d\n\n", min_dest, min_cost);
	printf("minimum cost to align crabs to position %d using expensive fuel\n%d\n", min_dest_expensive, min_cost_expensive);
	return 0;
}
