#!/bin/bash
#
# Download TLE catalog or SATCAT from the web
#
# Created by Chiara Tardioli, 20/05/2015
# Copiright (c) Stardust ITN
# ---------------------------------------------------
usage () {
    echo ' '
    echo "   Usage: download_cat.sh "
    echo ' '
    echo "   Choose an option:  "
    echo "   1) Dowload the entire TLE catalog from Space.Track"
    echo "   2) Dowload the entire SATCAT from Celestrack"
    echo "   3) Check only for update in the SpaceTrack TLE website"
    echo ' '
    read -p "   Your option, followed by [ENTER] : " myopt
    echo ' '
}

# Read secret string
read_secret()
{
    # Disable echo.
    stty -echo

    # Set up trap to ensure echo is enabled before exiting if the script
    # is terminated while echo is disabled.
    trap 'stty echo' EXIT

    # Read secret.
    read -t 60 -p "your password: " "$@"

    # Enable echo.
    stty echo
    trap - EXIT

    # Print a newline because the newline entered by the user after
    # entering the passcode is not echoed. This ensures that the
    # next line of output begins at a new line.
    echo
}

# 
if [ $# -lt 1 ]; then
    usage
else
    let "myopt = $1";
fi


# =============================================================================

if [ $myopt == 1 ]; then 

    ########################################################################
    #           SPACE.TRACK : TLE catalog (3 lines)
    ########################################################################

    # ------------- Connect to the website using your credential -------------

    FILE=./cookies.txt;

    if [ ! -f $FILE ]; then

	# Request credentials
	echo "   Space.Track website, credentials required";
	read -t 60 -p "your username: " myusername;
	#    read -s -t 60 -p "your password: " mypassword
	#    echo ' '
	read_secret mypassword;

	echo " Generate cookies up to 4 hours"
	curl -c cookies.txt -b cookies.txt \
	    -k https://www.space-track.org/ajaxauth/login \
	    -d "identity=$myusername&password=$mypassword" ;
    fi

    # ----------------------- Download TLE catalog ----------------------------
    echo "   Download latest TLE catalog from Space.Track"

    # Latest TLE (3 lines)
    rm -f tle_latest.txt;
    curl --limit-rate 100K --cookie cookies.txt \
	https://www.space-track.org/basicspacedata/query/class/tle_latest/ORDINAL/1/EPOCH/%3Enow-30/orderby/NORAD_CAT_ID/format/3le \
	-o tle_latest.txt

    # Json
    rm -f boxscore.json;
    curl --limit-rate 100KdateDownloaded.txt --cookie cookies.txt \
	https://www.space-track.org/basicspacedata/query/class/boxscore \
	-o boxscore.json

    # Difference index between the previous catalog
    curl --limit-rate 100K --cookie cookies.txt \
	https://www.space-track.org/basicspacedata/query/class/tle_latest/predicates/FILE/ORDINAL/1/orderby/FILE%20desc/limit/1 \
	-o tmp

    diff tmp .bookmark;
    mv tmp .bookmark;

    # ----------------------- The end ----------------------------

    NUMLIN=$(cat tle_latest.txt | wc -l ); # no. of objects
    echo "No. of objects: $((NUMLIN/3))";

    echo "   Save the date ";
    stat -f "%m%t%Sm %N" tle_latest.txt;    
    stat -f "%m%t%Sm %N" tle_latest.txt  > tmp;

    FILE=./.dateDownloaded;
    if [ ! -f $FILE ]; then
	mv tmp $FILE;
    else
	cat $FILE >> tmp;
	mv tmp $FILE;
    fi

elif [ $myopt == 2 ]; then
    
    ########################################################################
    #                             SATCAT catalog
    ########################################################################

    echo "   Download SATCAT catalog from Celestrack, no credentials required"
    echo "   Write output into file satcat.txt"
    
    rm -f satcat.txt
    curl -O "http://www.celestrak.com/pub/satcat.txt"

    NUMLIN=$(cat satcat.txt | wc -l ); # no. of objects
    echo "No. of objects: $NUMLIN";

    # ----------------------- The end ----------------------------

    echo "   Save the date ";
    stat -f "%m%t%Sm %N" satcat.txt;
    stat -f "%m%t%Sm %N" satcat.txt  > tmp;

    FILE=./.dateDownloaded;
    if [ ! -f $FILE ]; then
	mv tmp $FILE;
    else
	cat $FILE >> tmp;
	mv tmp $FILE;
    fi

elif [ $myopt == 3 ]; then 
    echo "   not implemented yet";
fi
