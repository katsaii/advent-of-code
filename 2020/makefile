CLANG := $(shell clang --version 2> /dev/null)
GCC := $(shell gcc --version 2> /dev/null)

all:
	@echo 'please supply a day number'

1:
	@nodejs day_1.js

2:
	@ruby day_2.js

3:
ifneq "$(or $(CLANG),$(GCC))" ""
ifdef CLANG
	@clang day_3.c
else
	@gcc day_3.c
endif
	@./a.out
	@rm a.out
else
	@echo 'missing c compiler'
endif

%:
	@echo 'unknown day number'
