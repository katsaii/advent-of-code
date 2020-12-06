all:
	@echo 'please supply a day number'

bin:
	@mkdir $@

1:
	@nodejs day_1.js

2:
	@ruby day_2.rb

3: bin
	@clang -o bin/day_3.out day_3.c
	@./bin/day_3.out

4: bin
	@ghc -o bin/day_4.out -odir bin/o -hidir bin/hi day_4.hs
	@./bin/day_4.out

5:
	@python3 day_5.py

6: bin
	@ghc -o bin/day_6.out -odir bin/o -hidir bin/hi day_6.hs
	@./bin/day_6.out

%:
	@echo 'unknown day number'
