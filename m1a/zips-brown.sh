#!/bin/bash

# Chase Brown
# cbrown54@nd.edu
# 09/03/2020

# You may include some comments here for me to read while
# grading.  If you had particular trouble or thought
# something especially fun or confusing, let us know so we
# can think about it while applying partial credit.

# globals area

SORT="cat"

DATFILE="zipcodes.dat"

DELIM=";"

SEARCH=""  #"\$2==\"Groton\""

AWK="print \$1, \$2, \$3;"

# functions area, starting with usage()

usage() {
    cat 1>&2 <<EOF
Usage: $(basename $0)

-h	This help message.
-s	Sort by zipcode, city, and/or state.
-d	Set output delimiter
-l	Locate city by text.
-c	Data to display.

Available data:
a	Latitude
o	Longitude
t	Timezone offset from UTC
d	DST
g	Geolocation

Examples:

	Output sorted by state, then city, then zipcode.
	$0 -s scz

	Output sorted only by state.
	$0 -s s

	Output uses tabs instead of spaces.
	$0 -s s -d '\t'

	Display latitude and longitude with zipcodes.
	$0 -c ao

	Display timezone, longitude, then latitude.
	$0 -c toa

	Search for Rushville, sort by state/city/zip, delimit using tab.
	./zips.sh -s scz -c oa -d "\t" -l "Rushville"

EOF
    exit $1
}

sortBy() {
	local SORT_BY=$1
	for i in $(seq 0 ${#SORT_BY}); do
		case ${SORT_BY:$i:1} in
			s)local SORT$i="-k3,3";;
			c)local SORT$i="-k2,2";;
			z)local SORT$i="-k1,1h";;
		esac
	done
	SUB=$DELIM
	if [ $DELIM == "\t" ] ; then
		SUB="t"
	fi
	SORT="sort -t ; $SORT0 $SORT1 $SORT2" 	
}

setDelim() {
	DELIM=$1
}

locate() {
	local LOC=$1
	SEARCH="\$2 ~ \"$LOC\""
}

display() {
	local GETDATA=$1
	for i in $(seq 0 ${#GETDATA}); do
		case ${GETDATA:$i:1} in 
			a)local DATA$i=",\$4";;
			o)local DATA$i=",\$5";;
			t)local DATA$i=",\$6";;
			d)local DATA$i=",\$7";;
			g)local DATA$i=",\$8";;
		esac
	done 
	AWK="print \$1, \$2, \$3 $DATA0 $DATA1 $DATA2 $DATA3 $DATA4 $DATA5;"
}
# read parameters

while [ $# -gt 0 ]; do
	case $1 in
	-h) usage 0;;
	-s)shift; sortBy $1;;
	-d)shift; setDelim $1;;
	-l)shift; locate "$1";;	
	-c)shift; display $1;;
	*) usage 1;;
	esac
	shift
done

# call the utilities

cat $DATFILE | $SORT | awk -v FS=';' -v OFS=$DELIM "$SEARCH {$AWK}"

# Whew! Thanks for working hard on this assignment.
#
# Here's an ASCII fish I thought was cute:
#
#                O  o
#           _\_   o
# >('>   \\/  o\ .
#        //\___=
#           ''
# I especially like the little fish behind the big one.
# 
# I put it here as a reminder of how simple things, like
# a couple greater-than signs and a paren, can have
# a big meaning.  As you gain knowledge of this material,
# you will throw off the yoke put on you by most
# operating systems like Android, iOS, Windows, and yes
# even MacOS.  Those OSes are designed to keep you from
# making mistakes, but also to keep you contained.  They
# have you right where they want you, in your cell.
#
# Learn well, take the power into your own hands, and
# be free.
#
#            - cmc
