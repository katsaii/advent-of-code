#include <stdio.h>
#include <stdlib.h>

struct Slope {
	FILE *file;
	unsigned int line_start;
};

struct Slope *slope_create(char *s) {
	FILE *file = fopen(s, "r");
	struct Slope *slope = malloc(sizeof (struct Slope));
	slope->file = file;
	slope->line_start = 0;
	return slope;
}

void slope_destroy(struct Slope *slope) {
	fclose(slope->file);
}

int slope_get_char(struct Slope *slope) {
	fflush(slope->file);
	unsigned int pos = ftell(slope->file);
	int ch = fgetc(slope->file);
	fseek(slope->file, pos, SEEK_SET);
	return ch;
}

void slope_skip_column(struct Slope *slope) {
	fgetc(slope->file);
	switch (slope_get_char(slope)) {
	case '\n':
	case '\r':
		fseek(slope->file, slope->line_start, SEEK_SET);
		break;
	}
}

void slope_skip_row(struct Slope *slope) {
	fflush(slope->file);
	unsigned int offset = ftell(slope->file) - slope->line_start;
	while (1) {
		int ch = fgetc(slope->file);
		if (ch == EOF) {
			return;
		}
		if (ch == '\n') {
			break;
		}
	}
	slope->line_start = ftell(slope->file);
	fseek(slope->file, slope->line_start + offset, SEEK_SET);
}

unsigned int slope_3x1(struct Slope *slope) {
	unsigned int n = 0;
	int ch;
	while ((ch = slope_get_char(slope)) != EOF) {
		if (ch == '#') {
			n += 1;
		}
		slope_skip_column(slope);
		slope_skip_column(slope);
		slope_skip_column(slope);
		slope_skip_row(slope);
	}
	return n;
}

int main() {
	struct Slope *slope = slope_create("./day_3.input");
	unsigned int n = slope_3x1(slope);
	printf("number of collisions with a gradient of -1/3\n%d\n", n);
	slope_destroy(slope);
	return 0;
}
