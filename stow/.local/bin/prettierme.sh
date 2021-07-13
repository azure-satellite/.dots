#!/usr/bin/env bash

# https://github.com/ruyadorno/prettierme

if [ "$#" == 0 ]; then
  echo "$(basename $0) file [options]"
	exit 0;
fi

function find_binary() {
	source="${BASH_SOURCE[0]}"

	while [ -h "$source" ]; do
		currdir="$( cd -P "$( dirname "$source" )" && pwd )"
		source="$(readlink "$source")"
		[[ $source != /* ]] && source="$currdir/$source"
	done

	currdir="$( cd -P "$( dirname "$source" )" && pwd )"
	globalbin="$(npm bin -g)"
	localbin="$(npm bin)"

	if hash prettier_d_slim 2>/dev/null; then
		echo prettier_d_slim
	elif [ -e "$globalbin/prettier_d_slim" ]; then
		echo "$globalbin/prettier_d_slim"
	elif [ -e "$localbin/prettier_d_slim" ]; then
		echo "$localbin/prettier_d_slim"
	elif [ -e "$currdir/node_modules/@fsouza/prettier_d_slim/bin/prettier_d_slim.js" ]; then
		echo "$currdir/node_modules/@fsouza/prettier_d_slim/bin/prettier_d_slim.js"
	fi
}

# Start server if not running
if ! pgrep prettier_d_slim > /dev/null; then
  bin="$(find_binary)"
  "$bin" start
  sleep 0.1
fi

DATA=$(cat ~/.prettier_d_slim)
PORT="$(echo $DATA | cut -d ' ' -f 1)"
TOKEN="$(echo $DATA | cut -d ' ' -f 2)"

# Uses netcat to lint the file
RESULT=$(echo "$TOKEN $PWD ${@:2} --stdin --stdin-filepath $1" | cat - $1 | nc 127.0.0.1 $PORT)

echo "$RESULT"

if [[ "$RESULT" =~ \#\ exit\ 1$ ]]; then
  exit 1
fi
