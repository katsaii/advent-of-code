#!/bin/bash

function requires-command {
	missing=''
	for arg in "$@"; do
		if ! command -v "$arg" &> /dev/null; then
			echo "missing command: $arg"
			missing=1
		fi
	done
	if [[ "$missing" ]]; then
		if [[ -n "$note" ]]; then
			echo "note: $note"
		fi
		exit
	fi
}

filePath="$1"
fileExt="${filePath#*.}"
fileName="`basename "$filePath" ".$fileExt"`"
fileDir="`dirname "$filePath"`"
in="./$fileName.$fileExt"
if [ "$fileDir" = "/" ]; then
	echo 'nice try!'
	exit
fi
(
cd "$fileDir"
in="./$fileName.$fileExt"
if [ ! -e "$in" ]; then
	echo "a file does not exist at the path '$in' relative to the directory '$fileDir'"
	exit
fi
binDir="./bin"
outDir="./out"
if [ ! -d "$binDir" ]; then
	mkdir "$binDir"
fi
if [ ! -d "$outDir" ]; then
	mkdir "$outDir"
fi
bin="$binDir/$fileName.out"
out="$outDir/$fileName.txt"
case $fileExt in
c)
	requires-command clang
	clang -o "$bin" "$in"
	"$bin" | tee "$out"
	;;
ck)
	note="Chuck can be installed at https://chuck.stanford.edu/release/" requires-command chuck
	chuck "$in" | tee "$out"
	;;
cpp)
	requires-command clang++
	clang++ -o "$bin" "$in"
	"$bin" | tee "$out"
	;;
erl)
	requires-command erl
	echo "not supported"
	;;
go)
	requires-command go
	goObj="$binDir/o/$fileName.o"
	go tool compile -o "$goObj" "$in"
	go tool link -o "$bin" "$goObj"
	"$bin" | tee "$out"
	;;
hs)
	requires-command ghc
	ghc -o "$bin" -odir "$binDir/o" -hidir "$binDir/h" "$in"
	"$bin" | tee "$out"
	;;
hx)
	requires-command haxe python3
	haxeMain="$binDir/Main.hx"
	haxeTarget="$binDir/$fileName.py"
	cp "$in" "$haxeMain"
	haxe -p "$binDir" --python "$haxeTarget" --main Main
	python3 "$haxeTarget" | tee "$out"
	;;
js)
	requires-command node
	node "$in" | tee "$out"
	;;
kats)
	note="KatScript can be installed at https://github.com/NuxiiGit/katscript-lang" requires-command katscript
	katscript "$in" | tee "$out"
	;;
lua)
	requires-command lua
	lua "$in" | tee "$out"
	;;
ml)
	requires-command ocamlc
	echo "not supported"
	;;
nim)
	requires-command nim
	echo "not supported"
	;;
pl)
	requires-command swipl
	swipl -o "$bin" -g main -c "$in" 2> /dev/null
	"$bin" | tee "$out"
	;;
py)
	requires-command python3
	python3 "$in" | tee "$out"
	;;
rb)
	requires-command ruby
	ruby "$in" | tee "$out"
	;;
rs)
	requires-command rustc
	rustc -o "$bin" "$in"
	"$bin" | tee "$out"
	;;
sh)
	chmod +x "$in"
	"$in" | tee "$out"
	;;
zig)
	requires-command zig
	echo "not supported"
	;;
*)
	echo "unknown file extension .$fileExt"
	;;
esac
)
