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

void snail_inc_depth(struct SnailN* snail, int offset) {
	if (snail == NULL) {
		return;
	}
	snail->depth += offset;
	if (snail->type == PAIR) {
		snail_inc_depth(snail->left, offset);
		snail_inc_depth(snail->right, offset);
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

struct SnailN* snail_add(struct SnailN* left, struct SnailN* right) {
	struct SnailN* snail = malloc(sizeof(struct SnailN));
	snail->type = PAIR;
	snail->depth = 1;
	snail->left = left;
	snail->right = right;
	snail_inc_depth(left, 1);
	snail_inc_depth(right, 1);
	struct SnailN* joint_left = snail_max(left);
	struct SnailN* joint_right = snail_min(right);
	joint_left->next = joint_right;
	joint_right->prev = joint_left;
	return snail;
}

void snail_reduce(struct SnailN* snail) {

}

int main() {
	return 0;
}
