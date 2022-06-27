#!/bin/bash
# This file is generated automatically by example.sh
# @date: Tue 08 Feb 2022 01:08:05 PM HKT
set -o errexit
set -o nounset
set -o pipefail

run(){
	file="$*"
	./${file};
}

if [ 0 -eq $# ]; then
	begin=4;
	end=28;
	for ((i = begin; i < end; i++));
	do
		align=$(printf "%02d" ${i});
		run "example${align}.pl";
	done
else
	run "$*"
fi

exit 0;