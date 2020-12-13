#!/bin/bash
FILEPATH="$1"
FILEEXT="${FILEPATH#*.}"
FILENAME="`basename "$FILEPATH" ".$FILEEXT"`"
FILEDIR="`dirname "$FILEPATH"`"
if [ "$FILEDIR" = "/" ]; then
	echo 'nice try!'
	exit 1
fi
if [ ! -d "$FILEDIR/bin" ]; then
	mkdir "$FILEDIR/bin"
fi
IN="./$FILENAME.$FILEEXT"
OUTDIR="./bin"
OUT="$OUTDIR/$FILENAME.out"
(cd "$FILEDIR"
case $FILEEXT in
	c)
		clang -o "$OUT" "$IN"
		"$OUT"
		;;
	hs)
		ghc -o "$OUT" -odir "$OUTDIR/o" -hidir "$OUTDIR/h" "$IN"
		"$OUT"
		;;
	js)
		nodejs "$IN"
		;;
	pl)
		swipl -o "$OUT" -g main -c "$IN" 2> /dev/null
		"$OUT"
		;;
	py)
		python3 "$IN"
		;;
	rb)
		ruby "$IN"
		;;
	rs)
		rustc -o "$OUT" "$IN"
		"$OUT"
		;;
	*)
		echo "unknown file extension .$FILEEXT"
		;;
esac)
