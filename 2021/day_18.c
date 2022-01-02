#include <stdio.h>
#include <stdlib.h>

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
	struct SnailN* snail = snail_read(file);
	snail_show(snail); printf("\n");
	snail_explode(snail->left->right->right->right);
	snail_show(snail); printf("\n");
	return 0;
}
