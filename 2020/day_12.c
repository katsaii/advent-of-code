#include <stdio.h>
#include <stdlib.h>

#define DIRECTION_COUNT 4

enum Direction {
	NORTH,
	EAST,
	SOUTH,
	WEST
};

int X_MOVE[DIRECTION_COUNT] = { 0, 1, 0, -1 };
int Y_MOVE[DIRECTION_COUNT] = { 1, 0, -1, 0 };
int X_PROJ_X[DIRECTION_COUNT] = { 1, 0, -1, 0 };
int X_PROJ_Y[DIRECTION_COUNT] = { 0, -1, 0, 1 };
int Y_PROJ_X[DIRECTION_COUNT] = { 0, 1, 0, -1 };
int Y_PROJ_Y[DIRECTION_COUNT] = { 1, 0, -1, 0 };

struct Boat {
	FILE *file;
	int x;
	int y;
	enum Direction dir;
	int waypoint_x;
	int waypoint_y;
};

struct Boat *boat_create(char *s) {
	FILE *file = fopen(s, "r");
	struct Boat *boat = malloc(sizeof (struct Boat));
	boat->file = file;
	boat->x = 0;
	boat->y = 0;
	boat->dir = EAST;
	boat->waypoint_x = 10;
	boat->waypoint_y = 1;
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
	boat->dir = EAST;
	boat->waypoint_x = 10;
	boat->waypoint_y = 1;
}

void boat_rotate(struct Boat *boat, int angle) {
	int dir = (boat->dir + angle / 90) % DIRECTION_COUNT;
	if (dir < 0) {
		dir = DIRECTION_COUNT + dir;
	}
	boat->dir = dir;
}

void boat_rotate_waypoint(struct Boat *boat, int angle) {
	int dir = (angle / 90) % DIRECTION_COUNT;
	if (dir < 0) {
		dir = DIRECTION_COUNT + dir;
	}
	int x = boat->waypoint_x;
	int y = boat->waypoint_y;
	boat->waypoint_x = x * X_PROJ_X[dir] + y * Y_PROJ_X[dir];
	boat->waypoint_y = x * X_PROJ_Y[dir] + y * Y_PROJ_Y[dir];
}

void boat_move(struct Boat *boat, enum Direction dir, int amount) {
	boat->x += amount * X_MOVE[dir];
	boat->y += amount * Y_MOVE[dir];
}

void boat_move_forward(struct Boat *boat, int amount) {
	boat_move(boat, boat->dir, amount);
}

void boat_move_waypoint(struct Boat *boat, int dx, int dy) {
	boat->waypoint_x += dx;
	boat->waypoint_y += dy;
}

void boat_move_forward_to_waypoint(struct Boat *boat, int amount) {
	boat->x += boat->waypoint_x * amount;
	boat->y += boat->waypoint_y * amount;
}

void boat_travel(struct Boat *boat) {
	char op;
	int val;
	while (fscanf(boat->file, "%c%d\n", &op, &val) != EOF) {
		switch (op) {
		case 'N':
			boat_move(boat, NORTH, val);
			break;
		case 'E':
			boat_move(boat, EAST, val);
			break;
		case 'S':
			boat_move(boat, SOUTH, val);
			break;
		case 'W':
			boat_move(boat, WEST, val);
			break;
		case 'L':
			boat_rotate(boat, -val);
			break;
		case 'R':
			boat_rotate(boat, val);
			break;
		case 'F':
			boat_move_forward(boat, val);
			break;
		}
	}
}

void boat_travel_waypoint(struct Boat *boat) {
	char op;
	int val;
	while (fscanf(boat->file, "%c%d\n", &op, &val) != EOF) {
		switch (op) {
		case 'N':
			boat_move_waypoint(boat, 0, val);
			break;
		case 'E':
			boat_move_waypoint(boat, val, 0);
			break;
		case 'S':
			boat_move_waypoint(boat, 0, -val);
			break;
		case 'W':
			boat_move_waypoint(boat, -val, 0);
			break;
		case 'L':
			boat_rotate_waypoint(boat, -val);
			break;
		case 'R':
			boat_rotate_waypoint(boat, val);
			break;
		case 'F':
			boat_move_forward_to_waypoint(boat, val);
			break;
		}
	}
}

int main() {
	struct Boat *boat = boat_create("in/day_12.txt");
	boat_travel(boat);
	int manual_dist = abs(boat->x) + abs(boat->y);
	printf("distance after the journey\n%d\n", manual_dist);
	boat_rewind(boat);
	boat_travel_waypoint(boat);
	int waypoint_dist = abs(boat->x) + abs(boat->y);
	printf("\ndistance after the journey using waypoints\n%d\n", waypoint_dist);
	boat_destroy(boat);
	return 0;
}
