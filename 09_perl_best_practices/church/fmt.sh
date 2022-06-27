#!/bin/bash
# This file is generated automatically by example.sh
# @date: Tue 08 Feb 2022 01:08:05 PM HKT
set -o errexit
set -o nounset
set -o pipefail

begin=1;
end=20;
for ((i = begin; i < end; i++));
do
	align=$(printf "%02d" ${i});
	echo ${align};
	perltidy -ce -l=128 -i=2 -nbbc -b example${align}.pl;
	rm -vf example${align}.pl.bak;
done
exit 0;
