#!/usr/bin/bash
# retrieve song tags using the last.fm api

api_key_path="$(dirname "$0")/config/api_key.txt"
api_key=$(cat $api_key_path)
artist="$(tr " " "+" <<< "$1")"
track="$(tr " " "+" <<< "$2")"

function error() {
    echo "error: $1"
    echo "usage: $(basename "$0") \"artist\" \"track\""
    exit 1
}

[ -z "$api_key" ] && echo "error: no api key. save your api key to $api_key_path" && exit 1
[ -z "$artist" ] && error "no artist"
[ -z "$track" ] && error "no track"

wget -qO - "https://ws.audioscrobbler.com/2.0/?method=track.getinfo&api_key=$api_key&artist=$artist&track=$track" | \
    sed -n "/<tag>/,/<\/tag>/p" | grep -oP "(?<=\<name\>).*(?=\</name\>)"
