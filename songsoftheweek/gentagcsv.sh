#!/usr/bin/bash
# extremely messy and quick script to generate a csv of tag counts from last.fm
# api data

songtags=output/songtags.dsv
output=output/tagcount.csv

other_count=0
threshold=7 # minimum count needed to avoid being categorized as "other"
# regex of tags to be automatically categorized as "other"
exclude="[0-9]+s|beautiful|british|femalevocalists|love|oldies|soundtrack"

echo "COUNT,TAG" > "$output"

# sorry
tmp_output=$(mktemp -u gentagcsv-XXXXX)
tmp_count=$(mktemp -u gentagcsv-counter-XXXXX)
trap "(sleep 0.1 && rm $tmp_output $tmp_count) 2> /dev/null & disown" SIGINT SIGTERM
! [ -f "$songtags" ] && echo "error: songtags.dsv not found" || \
    cat "$songtags" | cut -d "@" -f 3 | tr "," "\n" | tr -d " -" | sort | \
    uniq -c | sed "s/^ *//g" | while read count tag; do
        echo $count $tag 2>&1 # for verbosity
        if [ $count -lt $threshold ] || grep -qE "$exclude" <<< $tag; then
            other_count=$[$other_count+$count]
            # bash was behaving weirdly and had this set as 0 after the loop
            echo $other_count > $tmp_count
        else
            if ! [ -z "$tag" ]; then
                echo $count $tag >> $tmp_output
            fi
        fi
    done
echo $(cat $tmp_count) other >> $tmp_output
rm $tmp_count
sort -V < $tmp_output | tr " " "," >> "$output"
rm $tmp_output
