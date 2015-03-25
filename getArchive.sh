#!/bin/bash

# Author	:	starkDbl07
# Date		:	2015-03-25
# Purpose	:	Download plaintext of not-yet-downloaded sailfish-irc logs 'http://www.merproject.org/logs/%23sailfishos-porters'

archive_dir="archive"
temp_dir="temp"

mkdir -p "$temp_dir"
mkdir -p "$archive_dir"

source includes/timestamps.func
source includes/pasties.func

function getArchiveForDate {
	date="$1"
	#curl -s "http://www.merproject.org/logs/%23sailfishos-porters/%23sailfishos-porters.$date.log.html" | grep 'class="nick"' | sed -e 's^<tr id="t\([^"]*\)"><[^>]*>\([^<]*\)</th><td[^>]*>\(.*\)^\1  \2    \3^; s^</td><[^<]*><[^<]*>[^>]*</a></td></tr>$^^' > $archive_dir/$date.txt
	curl -s "http://www.merproject.org/logs/%23sailfishos-porters/%23sailfishos-porters.$date.log" > $archive_dir/$date.txt
	updateIRCLogTimestamp "$date.txt"
}

function getIndexes {
	curl -s "http://www.merproject.org/logs/%23sailfishos-porters/index.html" | grep '</li>' | sed -n '2,$p'| awk -F'>' '{print $3}' | awk '{print $1}' | sort -n
}

function updateIRC {
	echo "Getting Date Indexes..."
	getIndexes > $temp_dir/indexes

	echo "Fetching Archive as text..."
	count=0
	while read index
	do 
		if [ ! -e "$archive_dir/$index.txt" ]
		then
			let count=count+1
			echo -e "\t - $index"
			getArchiveForDate $index
		fi
	done < $temp_dir/indexes

	if [ $count -eq 0 ]
	then
		echo ""
		echo "No newer archive found."
		echo ""
	fi
}

function usage {
	echo "Usage:"
	echo "============="
	echo ""
	echo "$0 irc"
	echo -e "\t - Update local IRC archive"
	echo ""
	echo "$0 pasties pastebin|piratepad|opensuse"
	echo -e "\t - Update local pasties archive"
	echo ""
	echo "$0 timestamp update-ircLogs"
	echo -e "\t - Update timestamps of ircLogs as dated"
	echo ""

	exit 1
}

if [ "$1" == "pasties" ]
then
	if [ -z "$2" ]
	then
		usage
	fi
	fetchNewerLinks $2
elif [ "$1" == "irc" ]
then
	updateIRC
elif [ "$1" == "timestamp" -a "$2" == "update-ircLogs" ]
then
	updateIRCLogTimestamp	
else
	usage	
fi
