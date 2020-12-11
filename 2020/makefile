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

7: bin
	@swipl -o bin/day_7.out -g main -c day_7.pl 2> /dev/null
	@./bin/day_7.out

8: bin
	@rustc -o bin/day_8.out day_8.rs
	@./bin/day_8.out

9:
	@python3 day_9.py

10:
	@python3 day_10.py

11:
	@rustc -o bin/day_11.out day_11.rs
	@./bin/day_11.out

%:
	@echo 'unknown day number'
