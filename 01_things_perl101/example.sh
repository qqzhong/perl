#!/bin/bash
# @filename           :  /data/rust/example.sh
# @author             :  Copyright (C) Church.Zhong
# @date               :  Sat 09 Oct 2021 03:53:53 PM HKT
# @function           :  automatically do something what you want by shell.
# @see                :  GNU bash, version 5.0.17
# @require            :  OpenSSL 1.1.1f  31 Mar 2020/Ubuntu 20.04.2 LTS/
#set -x
SECONDS=0
EX_OK=0
#EX_USAGE=64

set -o errexit
set -o nounset
set -o pipefail

# get absolute path of a path name
function abspath() {
	[[ -n  "$1" ]] && ( cd "$1" 2>/dev/null && pwd;)
}

function err() {
	echo "# [$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

function log() {
	echo "$*" >&2
}

WORK_DIR=$(abspath "$(dirname "$0")")
echo "# WORK_DIR = ${WORK_DIR}"
OS_DATE_DAY=$(date +%Y-%m-%d)
echo "# OS_DATE_DAY = ${OS_DATE_DAY}"
OS_DATE_SECOND=$(date "+%Y_%m_%d_%H%M%S")
echo "# OS_DATE_SECOND = ${OS_DATE_SECOND}"
OUTPUT=${WORK_DIR}/${OS_DATE_SECOND}
OUTPUT=${WORK_DIR}/debug
#OUTPUT=${WORK_DIR}/church
echo "# OUTPUT = ${OUTPUT}"


# -------------------------------- main --------------------------------
#DATE=$(date)
DATE="Sun 12 Jun 2022 12:38:31 PM HKT"

function main() {
	echo "write examples into ${OUTPUT}"
	rm -rf "${OUTPUT}"
	mkdir -p "${OUTPUT}"


	i=0;
	while read -r line;
	do
		#echo "${line}";
		# startswith
		[[ "${line}" == "#"* ]] && { i=$((i+1)); continue; }
		chapter=$(echo "${line}" | awk '{print $1}');
		#echo "${chapter}";
		i=$((i+1));
		align=$(printf "%02d" ${i});
		#echo "${align}";
		{
			cat "${WORK_DIR}/template.pl";
			echo "# chapter${align}:${chapter}";
			echo "# ${DATE}";
			echo "# f=\"${OUTPUT}/example${align}.pl\";perltidy -ce -l=128 -i=2 -nbbc -b \${f};";
		} > "${OUTPUT}/example${align}.pl";
	done < "${WORK_DIR}/toc.txt";
}

main "$@"

log "# Done"
# do some work( or time yourscript.sh)
duration=${SECONDS}
log "# $((duration / 60)) minutes and $((duration % 60)) seconds elapsed."
exit ${EX_OK}
# -------------------------------- exit --------------------------------

# #shellcheck -s bash /data/rust/example.sh
