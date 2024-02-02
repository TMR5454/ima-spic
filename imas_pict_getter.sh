#!/bin/bash

# !!!!!!!!!!!!! CAUTION !!!!!!!!!!!!! #
# Don't use this tool for DOS Attack. #

# usage #
# ./imas_pict_getter.sh [loop_time] [frame_number]

MAX_CARD_NUM=3236
LOOP_TIME=1
frame_num=0

########################## functions ######################

function arg_check () {
	echo "LOOP_TIME=${LOOP_TIME}"
	echo ""
	
	if [ $# -eq 1 ]; then
		LOOP_TIME=$1	
	fi
	if [ $# -ge 2 ]; then
		frame_num=$2
		LOOP_TIME=1
	fi
}


function get_card_random_frame_num () {
	if [ ${frame_num} -eq 0 ]; then
		frame_num=$(($RANDOM % $MAX_CARD_NUM))
	fi

	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!START GET CARD!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	echo "get card frame_num is ${frame_num}"
}



function _get_card () {

	# check already have card or not
	if test -e "./frame${frame_num}.jpg"; then
		echo "already have frame${frame_num}.jpg card"
		echo ""
		return
	fi

	if [ ${frame_num} -gt 900 ]; then 
		# frame_num >= 1000
		wget "http://mill.tokyo/card/frame$(((${frame_num} + 99) / 100))/frame${frame_num}.jpg"
	else
		wget "http://mill.tokyo/card/frame0$(((${frame_num} + 99) / 100))/frame${frame_num}.jpg"
	fi

}

function get_card () {
	_get_card
}

function _main () {
	

	get_card_random_frame_num

	# get imas card
	get_card

	if [ -e /usr/bin/cygstart ]; then
		cygstart "./frame${frame_num}.jpg"
	fi
	if [ -e /usr/bin/wslstart ]; then
		cygstart "./frame${frame_num}.jpg"
	fi
	
	# for loop
	frame_num=0
}

function main () {
	for var in `seq 1 ${LOOP_TIME}`
	do
		_main
	done
}

function pre () {
	arg_check $*
}

function print_message () {
	echo ""
	echo ""
	echo "usage: ${0} [loop_time] [frame_num(1~${MAX_CARD_NUM})]"

}

function post () {
	print_message
}


##### start form here #####
pre $*
main
post

