#!/bin/bash
#Globals
OFS=";"
SORT="cat"

DATFILE="dinosaur.dat"
#max 16 min 17
DINOA=$1
DINOALST=""
DINOB=$2
DINOBBLST=""

YES_COUNT=0
NO_COUNT=0

# Do some initial filtering here with awk
#Functions
overlap_ma(){
	if (( $(echo "$3 < $5" | bc -l) )) && (( $(echo "$6 < $2" | bc -l) )) ; then
		YES_COUNT=$(($YES_COUNT + $1 + $4))
	else
		NO_COUNT=$(($NO_COUNT + $1 + $4))
	fi
}

setDinoALst() {
	DINOALST=$(cat $DATFILE | awk -v FS=$'\t' -v IGNORECASE=1 "\$6 ~ /$DINOA/ { print \$16, \$17; }" | sort | uniq -c)
} 

setDinoBLst() {
	DINOBLST=$(cat $DATFILE | awk -v FS=$'\t' -v IGNORECASE=1 "\$6 ~ /$DINOB/ { print \$16, \$17; }" | sort | uniq -c)
}

setDinoALst
setDinoBLst
while read -r lineA
do
	while read -r lineB 
	do
		overlap_ma $lineA $lineB	
	done < <(echo "$DINOBLST")
done < <(echo "$DINOALST")

#Parameter Parsing
#There is no parameter parsing to be done since the input should always be 
#A pair of two dinosaur names

# Recall the pseudocode from README.md:
#
#For each *unique* Allosaurus occurrence:
#      NUM_ALLOSAUR = number of times this Allosaurus timespan occurs
#      For each *unique* Stegosaurus occurrence:
#          NUM_STEGOSAUR = number of times this Stego timespan occurs
#          YN = overlap_ma(dinoA_maxma, dinoA_minma, dinoB_maxma, dinoB_minma)
#          if YN equals 1
#              yes_count += NUM_ALLOSAUR + NUM_STEGOSAUR
#          else
#              no_count += NUM_ALLOSAUR + NUM_STEGOSAUR

# Use bc to calculate $OVERLAP
#Call Utilities

OVERLAP=$(echo "$YES_COUNT / ($NO_COUNT + $YES_COUNT)"| bc -l)
OVERLAP=$(echo "$OVERLAP * 100" | bc -l | awk '{print int($1)}')

echo "dinoverlap between $DINOA and $DINOB is $OVERLAP%"

#cat $DATFILE | awk -v FS=$'\t' -v OFS=$OFS -v IGNORECASE=1 '$6~/tyran/ {print}' | head -n 10

# Here's your ASCII art for this assignment!
#                __
#               / _)
#      _.----._/ /
#     /         /
#  __/ (  | (  |
# /__.-'|_|--|_|
#
# Imagine entering a time machine and setting the dial
# for -100 million years.  The door opens and humid air
# enters the machine.  Palm trees sway and a sauropod
# turns its long neck slowly toward you.  In the
# distance, a volcano emits steam and smoke.  A raptor
# suddenly leaps and runs toward you!  You look at the
# fuel gauge: if you jump again, you can make it home,
# but never return to the land of the dinosaurs.  Out
# of the corner of your eye you glance the emergency
# blaster pack. Fully charged, but locked behind the
# safety glass.  You just might have time to grab it,
# if you run now, right now.
#
# Do you punch JUMP or RUN?
#

