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
	free(slope);
}

void slope_rewind(struct Slope *slope) {
	rewind(slope->file);
	slope->line_start = 0;
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

unsigned int slope_slide(struct Slope *slope, int dx, int dy) {
	unsigned int n = 0;
	int ch;
	slope_rewind(slope);
	while ((ch = slope_get_char(slope)) != EOF) {
		if (ch == '#') {
			n += 1;
		}
		for (int i = dx; i > 0; i -= 1) {
			slope_skip_column(slope);
		}
		for (int i = dy; i > 0; i -= 1) {
			slope_skip_row(slope);
		}
	}
	return n;
}

int main() {
	struct Slope *slope = slope_create("in/day_03.txt");
	unsigned int path_1x1 = slope_slide(slope, 1, 1);
	unsigned int path_3x1 = slope_slide(slope, 3, 1);
	unsigned int path_5x1 = slope_slide(slope, 5, 1);
	unsigned int path_7x1 = slope_slide(slope, 7, 1);
	unsigned int path_1x2 = slope_slide(slope, 1, 2);
	printf("tree intersection count for\n");
	printf(" - 1x1 path => %d\n", path_1x1);
	printf(" - 3x1 path => %d\n", path_3x1);
	printf(" - 5x1 path => %d\n", path_5x1);
	printf(" - 7x1 path => %d\n", path_7x1);
	printf(" - 1x2 path => %d\n", path_1x2);
	unsigned long long path_prod = path_1x1 * path_3x1 * path_5x1 * path_7x1 * path_1x2;
	printf("\nproduct of intersections\n%d * %d * %d * %d * %d = %llu\n",
			path_1x1, path_3x1, path_5x1, path_7x1, path_1x2, path_prod);
	slope_destroy(slope);
	return 0;
}
