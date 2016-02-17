#!/usr/bin/bash

########## defaults
img_dir=
output=
tile_width=30
font=
pointsize=16

########## parse options
this=$(basename "$0")

function usage() {
    cat <<EOF
usage: $this [-h] [-f font] [-o output] [-p pt]
    [-t tilewidth] img_dir
       -f font         use the specified font (see identify -list font for a
                       list of supported fonts)
       -h              display this message and exit
       -o output       the file to save the grid to (default $img_dir-grid.jpg)
       -p pt           font point size to use (default 16)
       -t tilewidth    the width, in pixels, of each tile (default 30)
       img_dir         the directory to find images in

ex: $this ~/Pictures/project/src
ex: $this -f Source-Sans-Pro -o output.jpg -p 18 ~/Pictures/project/src
EOF
}

while getopts ":hf:o:p:t:" opt; do
    case $opt in
        f) font="$OPTARG" ;;
        h) usage; exit 0 ;;
        o) output="$OPTARG" ;;
        p) pointsize="$OPTARG" ;;
        t) tilewidth="$OPTARG" ;;
        ?) usage; exit 1 ;;
    esac
done

shift $(($OPTIND-1))

########## pre-run checks and setup
if [ -z "$1" ]; then
    echo "error: no image directory specified"
    usage
    exit 1
else
    if [ -d "$1" ]; then
        img_dir="$1"
    else
        echo "error: $2 is not a valid directory"
        exit 1
    fi
fi

if [ -z "$output" ]; then
    output="$(basename "$img_dir")-grid.jpg"
else
    if [ -e "$output" ]; then
        echo "warning: $output exists and will be overwritten"
    fi
fi

if ! [ -z "$font" ]; then
    font_option="-font $font"
fi

#if ! [ "$pointsize" -eq "$pointsize" ] 2> /dev/null; then
#    echo "error: $pointsize is not an integer"
#    exit 1
#fi
#
#if ! [ "$tilewidth" -eq "$tilewidth" ] 2> /dev/null; then
#    echo "error: $pointsize is not an integer"
#    exit 1
#fi

width=$(bc <<< "sqrt($(find "$img_dir" -type f | wc -l))+1")
export MAGICK_TMPDIR=/home/$USER/

########## generate grid
# extract iso date data, prepend it to a string, sort it, and use the sorted
# data to build arguments for imagemagick montage
(find "$img_dir" -type f | while read img; do
    creation_date_iso=$(exiftool "$img" | grep Create\ Date | \
        awk '{printf $4}' | tr ":" "-")
    if [ -z "$creation_date_iso" ]; then
        creation_date_iso=unknown
    fi
    echo $creation_date_iso $img
done | sort | while read iso_date img; do
    echo "-label"
    date --date=$iso_date "+%d %b %Y"
    echo $img
done && echo "$output") | tr "\n" "\0" | xargs -0 montage \
    $font_option \
    -pointsize $pointsize \
    -tile ${width}x${width} \
    -geometry +2+2 \
    -limit memory 32mb \
    -limit map 64mb \
    -define jpeg:size=${tile_width}x${tile_width}
