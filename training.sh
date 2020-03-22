#/usr/bin/env bash

#set -x

# ==============================================================================
SEQUENCE=$1
DURATION_STEP=$2
DURATION_REST=$3
NB_OF_CYCLE=$4
# ------------------------------------------------------------------------------
TOTAL_TIME_CYCLE=

# ------------------------------------------------------------------------------
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

PATH_MUSIC=$(cat playlist)
PATH_IMG=${CURRENT_DIR}/img
REST_IMG=${PATH_IMG}/rest.png

BELL=$(cat bell)
# ------------------------------------------------------------------------------

PAPLAY=$(which paplay)
MPLAYER=$(which mplayer)
VIEWER="$(which eog) --fullscreen"
# ==============================================================================

usage()
{
	echo "Usage training <FILE_SEQUENCE> <DURATION_STEP> <DURATION_REST> <NB_CYCLE>"
}

do_play_bell()
{
	${PAPLAY} ${BELL}
}

do_play_music()
{
	local selection=$1
	local track=$(ls -1 "${PATH_MUSIC}" | head -${selection} | tail -1)
	
	timeout ${TOTAL_TIME_CYCLE} ${MPLAYER} "${PATH_MUSIC}/${track}" &
}

do_training()
{
	local file=$1
	for round in $(seq 1 ${NB_OF_CYCLE}); do
		do_play_music ${round}
		do_cycle ${file}
	done	
}

do_cycle()
{
	local file=$1
	for exercice in $(cat $file); do
		timeout ${DURATION_STEP}s ${VIEWER} ${PATH_IMG}/${exercice}
		do_play_bell
		timeout ${DURATION_REST}s ${VIEWER} ${REST_IMG}
		do_play_bell
	done
}

# ==============================================================================
if [ $# -ne 4 ]; then
	usage
else
	TOTAL_TIME_CYCLE=$(expr $(expr $2 + $3) \* $(cat ${SEQUENCE} | wc -l))
	echo $TOTAL_TIME_CYCLE
	do_training $1 $2 $3 $4
fi

