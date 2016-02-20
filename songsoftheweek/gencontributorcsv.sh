#!/usr/bin/bash

song_dsv=output/songsoftheweek.dsv
output=output/contributorcount.csv

echo "COUNT,CONTRIBUTOR" > "$output"
cut -d "@" -f 1 "$song_dsv" | \
    sort | uniq -c | sed "s/^ *//g" | sort -V  | \
    awk '{ print $1","$2,$3 }' >> "$output"