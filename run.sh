#!/bin/bash

function requires_command {
	MISSING=''
	for ARG in "$@"; do
		if ! command -v "$ARG" &> /dev/null; then
			echo "missing command: $ARG"
			MISSING=1
		fi
	done
	if [[ "$MISSING" ]]; then
		if [[ -n "$NOTE" ]]; then
			echo "note: $NOTE"
		fi
		exit
	fi
}

FILEPATH="$1"
FILEEXT="${FILEPATH#*.}"
FILENAME="`basename "$FILEPATH" ".$FILEEXT"`"
FILEDIR="`dirname "$FILEPATH"`"
IN="./$FILENAME.$FILEEXT"
if [ "$FILEDIR" = "/" ]; then
	echo 'nice try!'
	exit
fi
(
cd "$FILEDIR"
IN="./$FILENAME.$FILEEXT"
if [ ! -e "$IN" ]; then
	echo "a file does not exist at the path '$IN' relative to the directory '$FILEDIR'"
	exit
fi
BINDIR="./bin"
OUTDIR="./out"
if [ ! -d "$BINDIR" ]; then
	mkdir "$BINDIR"
fi
if [ ! -d "$OUTDIR" ]; then
	mkdir "$OUTDIR"
fi
BIN="$BINDIR/$FILENAME.out"
OUT="$OUTDIR/$FILENAME.txt"
case $FILEEXT in
	c)
		requires_command clang
		clang -o "$BIN" "$IN"
		"$BIN" | tee "$OUT"
		;;
	ck)
		NOTE="Chuck can be installed at https://chuck.stanford.edu/release/" requires_command chuck
		chuck "$IN" | tee "$OUT"
		;;
	cpp)
		requires_command clang++
		clang++ -o "$BIN" "$IN"
		"$BIN" | tee "$OUT"
		;;
	erl)
		requires_command erl
		echo "not supported"
		;;
	go)
		requires_command go
		GO_OBJ="$BINDIR/o/$FILENAME.o"
		go tool compile -o "$GO_OBJ" "$IN"
		go tool link -o "$BIN" "$GO_OBJ"
		"$BIN" | tee "$OUT"
		;;
	hs)
		requires_command ghc
		ghc -o "$BIN" -odir "$BINDIR/o" -hidir "$BINDIR/h" "$IN"
		"$BIN" | tee "$OUT"
		;;
	hx)
		requires_command haxe python3
		HAXE_MAIN="$BINDIR/Main.hx"
		HAXE_TARGET="$BINDIR/$FILENAME.py"
		cp "$IN" "$HAXE_MAIN"
		haxe -p "$BINDIR" --python "$HAXE_TARGET" --main Main
		python3 "$HAXE_TARGET" | tee "$OUT"
		;;
	js)
		requires_command node
		node "$IN" | tee "$OUT"
		;;
	kats)
		NOTE="KatScript can be installed at https://github.com/NuxiiGit/katscript-lang" requires_command katscript
		katscript "$IN" | tee "$OUT"
		;;
	lua)
		requires_command lua
		lua "$IN" | tee "$OUT"
		;;
	ml)
		requires_command ocamlc
		echo "not supported"
		;;
	nim)
		requires_command nim
		echo "not supported"
		;;
	pl)
		requires_command swipl
		swipl -o "$BIN" -g main -c "$IN" 2> /dev/null
		"$BIN" | tee "$OUT"
		;;
	py)
		requires_command python3
		python3 "$IN" | tee "$OUT"
		;;
	rb)
		requires_command ruby
		ruby "$IN" | tee "$OUT"
		;;
	rs)
		requires_command rustc
		rustc -o "$BIN" "$IN"
		"$BIN" | tee "$OUT"
		;;
	sh)
		"$IN" | tee "$OUT"
		;;
	zig)
		requires_command zig
		echo "not supported"
		;;
	*)
		echo "unknown file extension .$FILEEXT"
		;;
esac
)
