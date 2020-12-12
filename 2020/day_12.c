#include <stdio.h>
#include <stdlib.h>

struct Boat {
	FILE *file;
	int x;
	int y;
};

struct Boat *boat_create(char *s) {
	FILE *file = fopen(s, "r");
	struct Boat *boat = malloc(sizeof (struct Boat));
	boat->file = file;
	boat->x = 0;
	boat->y = 0;
	return boat;
}

void boat_destroy(struct Boat *boat) {
	fclose(boat->file);
	free(boat);
}

void boat_rewind(struct Boat *boat) {
	rewind(boat->file);
	boat->x = 0;
	boat->y = 0;
}

int main() {
	struct Boat *boat = boat_create("in/day_12.txt");
	boat_destroy(boat);
	return 0;
}
