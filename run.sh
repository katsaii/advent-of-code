#!/bin/bash

function check_commands_exist {
	MISSING=''
	for ARG in "$@"; do
		if ! command -v "$ARG" &> /dev/null; then
			echo "missing command: $ARG"
			MISSING=1
		fi
	done
	if [[ "$MISSING" ]]; then
		if [[ -n "$NOTE" ]]; then
			echo "$NOTE"
		fi
		exit
	fi
}

FILEPATH="$1"
FILEEXT="${FILEPATH#*.}"
FILENAME="`basename "$FILEPATH" ".$FILEEXT"`"
FILEDIR="`dirname "$FILEPATH"`"
if [ "$FILEDIR" = "/" ]; then
	echo 'nice try!'
	exit 1
fi
(
cd "$FILEDIR"
BINDIR="./bin"
OUTDIR="./out"
if [ ! -d "$BINDIR" ]; then
	mkdir "$BINDIR"
fi
if [ ! -d "$OUTDIR" ]; then
	mkdir "$OUTDIR"
fi
IN="./$FILENAME.$FILEEXT"
BIN="$BINDIR/$FILENAME.out"
OUT="$OUTDIR/$FILENAME.txt"
case $FILEEXT in
	c)
		clang -o "$BIN" "$IN"
		"$BIN" | tee "$OUT"
		;;
	cpp)
		clang++ -o "$BIN" "$IN"
		"$BIN" | tee "$OUT"
		;;
	go)
		GO_OBJ="$BINDIR/o/$FILENAME.o"
		go tool compile -o "$GO_OBJ" "$IN"
		go tool link -o "$BIN" "$GO_OBJ"
		"$BIN" | tee "$OUT"
		;;
	hs)
		ghc -o "$BIN" -odir "$BINDIR/o" -hidir "$BINDIR/h" "$IN"
		"$BIN" | tee "$OUT"
		;;
	hx)
		HAXE_MAIN="$BINDIR/Main.hx"
		HAXE_TARGET="$BINDIR/$FILENAME.py"
		cp "$IN" "$HAXE_MAIN"
		haxe -p "$BINDIR" --python "$HAXE_TARGET" --main Main
		python3 "$HAXE_TARGET" | tee "$OUT"
		;;
	js)
		nodejs "$IN" | tee "$OUT"
		;;
	lua)
		lua "$IN" | tee "$OUT"
		;;
	pl)
		swipl -o "$BIN" -g main -c "$IN" 2> /dev/null
		"$BIN" | tee "$OUT"
		;;
	py)
		python3 "$IN" | tee "$OUT"
		;;
	rb)
		ruby "$IN" | tee "$OUT"
		;;
	rs)
		rustc -o "$BIN" "$IN"
		"$BIN" | tee "$OUT"
		;;
	*)
		echo "unknown file extension .$FILEEXT"
		;;
esac
)
