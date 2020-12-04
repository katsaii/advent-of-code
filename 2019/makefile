all:
	@echo 'please supply a day number'

bin:
	@mkdir $@

1: bin
	@ghc -o bin/day_1.out -odir bin/o -hidir bin/hi day_1.hs
	@./bin/day_1.out

%:
	@echo 'unknown day number'
