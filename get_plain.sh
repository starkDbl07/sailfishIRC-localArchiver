#!/bin/bash

archive_dir="archive"
temp_dir="temp"

mkdir -p "$temp_dir"

function getArchiveForDate {
	date="$1"
	curl -s "http://www.merproject.org/logs/%23sailfishos-porters/%23sailfishos-porters.$date.log.html" | grep 'class="nick"' | sed -e 's^<tr id="t\([^"]*\)"><[^>]*>\([^<]*\)</th><td[^>]*>\(.*\)^\1  \2    \3^; s^</td><[^<]*><[^<]*>[^>]*</a></td></tr>$^^' > $archive_dir/$date.txt
}

function getIndexes {
	curl -s "http://www.merproject.org/logs/%23sailfishos-porters/index.html" | grep '</li>' | sed -n '2,$p'| awk -F'>' '{print $3}' | awk '{print $1}' | sort -n
}

function main {
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

main
