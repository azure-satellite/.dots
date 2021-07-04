#!/usr/bin/env bash

# https://github.com/ruyadorno/eslintme

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

	if hash eslint_d 2>/dev/null; then
		echo eslint_d
	elif [ -e "$globalbin/eslint_d" ]; then
		echo "$globalbin/eslint_d"
	elif [ -e "$localbin/eslint_d" ]; then
		echo "$localbin/eslint_d"
	elif [ -e "$currdir/node_modules/mantoni/eslint_d/bin/eslint_d.js" ]; then
		echo "$currdir/node_modules/mantoni/eslint_d/bin/eslint_d.js"
	fi
}

# Start server if not running
if [ ! -f ~/.eslint_d ]; then
	bin="$(find_binary)"
	"$bin" start
	sleep 0.1
fi

DATA=$(cat ~/.eslint_d)
PORT="$(echo $DATA | cut -d ' ' -f 1)"
TOKEN="$(echo $DATA | cut -d ' ' -f 2)"

# Uses netcat to lint the file
echo "$TOKEN $PWD ${@:2} --stdin --stdin-filename $1" | cat - $1 | nc 127.0.0.1 $PORT
