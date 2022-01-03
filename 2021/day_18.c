#include <stdio.h>
#include <stdlib.h>

#define BUFFER_SIZE 2048

enum SnailNType {
	REGULAR,
	PAIR,
};

struct SnailN {
	enum SnailNType type;
	int depth;
	union {
		struct {
			struct SnailN* prev;
			struct SnailN* next;
			int value;
		};
		struct {
			struct SnailN* left;
			struct SnailN* right;
		};
	};
};

struct SnailN* snail_number(int value) {
	struct SnailN* snail = malloc(sizeof(struct SnailN));
	snail->type = REGULAR;
	snail->depth = 1;
	snail->prev = NULL;
	snail->next = NULL;
	snail->value = value;
	return snail;
}

void snail_set_depth(struct SnailN* snail, int depth) {
	if (snail == NULL) {
		return;
	}
	snail->depth = depth;
	if (snail->type == PAIR) {
		snail_set_depth(snail->left, depth + 1);
		snail_set_depth(snail->right, depth + 1);
	}
}

struct SnailN* snail_min(struct SnailN* snail) {
	if (snail != NULL && snail->type == PAIR) {
		return snail_min(snail->left);
	}
	return snail;
}

struct SnailN* snail_max(struct SnailN* snail) {
	if (snail != NULL && snail->type == PAIR) {
		return snail_max(snail->right);
	}
	return snail;
}

void snail_add_inplace(
		struct SnailN* snail,
		struct SnailN* left,
		struct SnailN* right) {
	snail->type = PAIR;
	snail->left = left;
	snail->right = right;
	snail_set_depth(left, snail->depth + 1);
	snail_set_depth(right, snail->depth + 1);
	struct SnailN* joint_left = snail_max(left);
	struct SnailN* joint_right = snail_min(right);
	joint_left->next = joint_right;
	joint_right->prev = joint_left;
}

struct SnailN* snail_add(struct SnailN* left, struct SnailN* right) {
	struct SnailN* snail = malloc(sizeof(struct SnailN));
	snail->depth = 1;
	snail_add_inplace(snail, left, right);
	return snail;
}

void snail_free(struct SnailN* snail) {
	if (snail->type == PAIR) {
		snail_free(snail->left);
		snail_free(snail->right);
	}
	free(snail);
}

struct SnailN* snail_clone(struct SnailN* snail) {
	if (snail->type == REGULAR) {
		return snail_number(snail->value);
	} else {
		return snail_add(snail_clone(snail->left), snail_clone(snail->right));
	}
}

void snail_explode(struct SnailN* snail) {
	snail->type = REGULAR;
	struct SnailN* left = snail->left;
	struct SnailN* right = snail->right;
	snail->prev = left->prev;
	snail->next = right->next;
	snail->value = 0;
	if (left->prev != NULL) {
		left->prev->next = snail;
		left->prev->value += left->value;
	}
	if (right->next != NULL) {
		right->next->prev = snail;
		right->next->value += right->value;
	}
	free(left);
	free(right);
}

void snail_split(struct SnailN* snail) {
	int lvalue = snail->value / 2;
	int rvalue = snail->value - lvalue;
	struct SnailN* left = snail_number(lvalue);
	struct SnailN* right = snail_number(rvalue);
	left->prev = snail->prev;
	right->next = snail->next;
	if (snail->prev != NULL) {
		snail->prev->next = left;
	}
	if (snail->next != NULL) {
		snail->next->prev = right;
	}
	snail_add_inplace(snail, left, right);
}

void snail_reduce_explosions(struct SnailN* snail) {
	if (snail != NULL && snail->type == PAIR) {
		snail_reduce_explosions(snail->left);
		snail_reduce_explosions(snail->right);
		if (snail->depth > 4) {
			snail_explode(snail);
			snail_reduce_explosions(snail->prev);
		}
	}
}

void snail_reduce_splits(struct SnailN* snail) {
	if (snail == NULL) {
		return;
	}
	if (snail->type == REGULAR) {
		if (snail->value > 9) {
			snail_split(snail);
			snail_reduce_explosions(snail);
			if (snail->type == REGULAR) {
				// we exploded
				snail_reduce_splits(snail->prev);
			}
			snail_reduce_splits(snail);
		}
	} else {
		snail_reduce_splits(snail->left);
		snail_reduce_splits(snail->right);
	}
}

void snail_reduce(struct SnailN* snail) {
	snail_reduce_explosions(snail);
	snail_reduce_splits(snail);
}

int snail_magnitude(struct SnailN* snail) {
	if (snail->type == REGULAR) {
		return snail->value;
	} else {
		return
			3 * snail_magnitude(snail->left) +
			2 * snail_magnitude(snail->right);
	}
}

void snail_show(struct SnailN* snail) {
	if (snail->type == REGULAR) {
		printf("%d", snail->value);
	} else {
		printf("[");
		snail_show(snail->left);
		printf(", ");
		snail_show(snail->right);
		printf("]");
	}
}

struct SnailN* snail_read(FILE* file) {
	char code;
	do {
		code = fgetc(file);
		if (feof(file)) {
			return NULL;
		}
	} while (code == ' ' || code == '\n' || code == '\r');
	if (code == '[') {
		struct SnailN* left = snail_read(file);
		fgetc(file); // ,
		struct SnailN* right = snail_read(file);
		fgetc(file); // ]
		return snail_add(left, right);
	} else {
		return snail_number((int)(code - '0'));
	}
}

int main() {
	FILE *file = fopen("in/day_18.txt", "r");
	struct SnailN* snails[BUFFER_SIZE];
	int limit = 0;
	for (int i = 0; i < BUFFER_SIZE; i += 1, limit += 1) {
		struct SnailN* snail = snail_read(file);
		if (snail == NULL) {
			break;
		}
		snails[i] = snail;
	}
	struct SnailN* acc = NULL;
	for (int i = 0; i < limit; i += 1) {
		struct SnailN* snail = snail_clone(snails[i]);
		acc = acc == NULL ? snail : snail_add(acc, snail);
		snail_reduce(acc);
	}
	int mag_max = 0;
	for (int i = 0; i < limit; i += 1) {
		for (int j = 0; j < limit; j += 1) {
			if (i == j) {
				continue;
			}
			struct SnailN* forward = snail_add(
					snail_clone(snails[i]), snail_clone(snails[j]));
			snail_reduce(forward);
			struct SnailN* backward = snail_add(
					snail_clone(snails[j]), snail_clone(snails[i]));
			snail_reduce(backward);
			int mag_forward = snail_magnitude(forward);
			int mag_backward = snail_magnitude(backward);
			int mag = mag_forward > mag_backward ? mag_forward : mag_backward;
			if (mag > mag_max) {
				mag_max = mag;
			}
			snail_free(forward);
			snail_free(backward);
		}
	}
	printf("magnitude of snail number sum\n%d\n", snail_magnitude(acc));
	printf("\nmax magnitude of pairs of snail numbers\n%d\n", mag_max);
	snail_free(acc);
	return 0;
}
