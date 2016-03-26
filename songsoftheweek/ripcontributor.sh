#!/usr/bin/bash
# rip all songs from a given contributor
# usage: ./ripcontributor.sh "Contributor Name"
# Contributor Name is case sensitive and must be matched exactly

[ -z "$1" ] && echo "usage: $(basename "$0") Contributor Name" && exit 1

contributor="$@"
output="output/$contributor.txt"

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

while read article; do
    phantomjs <(echo "$dumpjs") $article | \
        w3m -dump -T text/html -cols 42000 | \
        sed -n "/${contributor}:/,/:$/p" | \
        head -n -1
done < "$articles" >> "$output"
