#!/usr/bin/bash
# use getalltags.sh to get all of the tags from songsoftheweek.dsv

delimiter="@"
delay=1 # how long to wait between each api request
output=output/songtags.dsv
archive_xml_dir=xml # save all xml data to a directory. leave blank to avoid

get_info="$(dirname "$0")/getsonginfo.sh"
song_dsv="$(dirname "$0")/output/songsoftheweek.dsv"

! [ -f "$get_info" ] && echo "error: could not find getsonginfo.sh" && exit 1
! [ -f "$song_dsv" ] && echo "error: could not find songsoftheweek.dsv" && exit 1
! [ -z "$archive_xml_dir" ] && mkdir -p "$archive_xml_dir"

function extract_tags() {
    cat "$1" | sed -n "/<tag>/,/<\/tag>/p" | grep -oP "(?<=\<name\>).*(?=\</name\>)"
}

echo "ARTIST${delimiter}SONG${delimiter}TAGS" > "$output"
tail -n +2 "$song_dsv" | while read line; do
    artist="$(cut -d "$delimiter" -f 2 <<< "$line")"
    song="$(cut -d "$delimiter" -f 3 <<< "$line" | sed "s/*$//")"

    skip=false
    if [ -z "$archive_xml_dir" ]; then
        raw_tags="$(extract_tags <("$get_info" "$artist" "$song"))"
    else
        outfile="$archive_xml_dir/$(tr "/" "_" <<< "$artist - $song").xml"
        if [ -f "$outfile" ]; then
            raw_tags="$(extract_tags "$outfile")"
            skip=true
        else
            "$get_info" "$artist" "$song" > "$outfile"
            raw_tags="$(extract_tags "$outfile")"
        fi
        if [ -z "$raw_tags" ]; then
            rm "$outfile"
        fi
    fi
    tags="$(tr "\n" "," <<< "$raw_tags" | sed "s/,$//" | tr "[:upper:]" "[:lower:]")"

    echo "$artist${delimiter}$song${delimiter}$tags" | tee -a "$output"
    ! $skip && sleep $delay
done
