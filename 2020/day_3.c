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

void slope_rewind(struct Slope *slope) {
	rewind(slope->file);
	slope->line_start = 0;
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
	struct Slope *slope = slope_create("./day_3.input");
	unsigned int n = slope_slide(slope, 3, 1);
	printf("number of collisions with a gradient of -1/3\n%d\n", n);
	unsigned long collision_product
			= slope_slide(slope, 1, 1)
			* slope_slide(slope, 3, 1)
			* slope_slide(slope, 5, 1)
			* slope_slide(slope, 7, 1)
			* slope_slide(slope, 1, 2);
	printf("\ntree collision product\n%lu\n", collision_product);
	slope_destroy(slope);
	return 0;
}
