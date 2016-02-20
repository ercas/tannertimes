#!/usr/bin/bash
# generate a csv from songs of the week contributions, delimited by "${delimiter}"
# depends on phantom.js and w3m

delimiter="@"                    # delimiter to use in the output file
output=output/songsoftheweek.dsv        # path of the output file
max_track_characters=100           # maximum number of characters in a song name
max_contributor_characters=30    # maximum number of characters in a contributor's name

################################################################################

articles="$(dirname "$0")/config/articles.txt"

if ! [ -f "$articles" ]; then
    echo "error: could not find $articles"
    echo "$articles should be a list of all articles to scrape."
    exit 1
fi


dumpjs='
// dump the html of a page after letting scripts run for some time
// usage: phantomjs dump.js url [timeout]
//     url        the url to dump html from
//     timeout    the time, in seconds, to wait before dumping
var page = require("webpage").create();
var system = require("system");
var timeout = 4000;

if (system.args.length < 2) {
    console.log("url not specified");
    phantom.exit();
}
if (system.args.length > 2) {
    timeout = system.args[3]*1000;
}

page.open(system.args[1], function(status) {
    window.setTimeout(function() {
        console.log(page.content);
        phantom.exit();
    }, timeout);
});
'

contributor=

echo "CONTRIBUTOR${delimiter}ARTIST${delimiter}SONG${delimiter}ARTICLE_URL" > "$output"
while read article; do
    contributor=
    
    phantomjs <(echo "$dumpjs") $article | w3m -dump -T text/html -cols 666 | \
        sed "s/\s\{1,\}$//" | while read line; do

        # contributor text should have a colon at the end and be less than
        # $max_contributor_characters characters
        if grep -q ":$" <<< "$line" && \
            [ $(wc -c <<< "$line") -lt $max_contributor_characters ]; then
            contributor=$(sed "s/:$//" <<< "$line")

        # song text should have a " - " in the middle and be less than
        # $max_track_characters characters
        elif grep -q " - " <<< "$line" && \
            [ $(wc -c <<< "$line") -lt $max_track_characters ]; then
            #row="$contributor${delimiter}$line${delimiter}$article"
            line_delimited=$(sed "s/ - /$delimiter/" <<< "$line")
            artist="$(cut -d "$delimiter" -f 1 <<< "$line_delimited")"
            song="$(cut -d "$delimiter" -f 2 <<< "$line_delimited")"
            row="$contributor${delimiter}$artist${delimiter}$song${delimiter}$article"

            echo "$row"
            # output to stderr for verbosity
            echo "$row" >&2
        fi
    done
    
done < "$articles" >> "$output"
