tannertimes
===========
projects related to work for the tanner times

avibench
--------
a small smartphone browser performance survey suite including a server and data parser. originally meant for the android vs iphone article, hence "avi".

**dependencies**: an http server with php support, r with extrafont package, GNU grep

**usage**: if you have docker installed, serve.sh can set up and start up a containerized server for you that will collect responses. otherwise:

1. place all files into the root http directory of your preferred server
2. create directories named responses/ and graphs/ in this directory
3. make sure those directories are readable by your server
4. make sure responses/ is writable by your server
5. start up the server

parse.sh is a script to parse the data and generates graphs from responses in the responses/ directory, putting them in the graphs/ directory. graphs.php generates a page using these images

songsoftheweek
--------------
tools to grab and analyze data concerning songs of the week articles. the last.fm api is used to gather individual song data.

**dependencies**: wget, GNU grep, r with extrafont package, phantom.js, w3m

**directory info**
* config/ - a directory to store runtime data in. this should contain api\_key.txt (containing a last.fm api key) and articles.txt (containing a list of all articles, separated by newlines)
* output/ - this is where output from scripts will be stored. other scripts access this directory to process the output from previous scripts.
* xml/ - this may or may not exist depending on if the $archive\_xml\_dir variable is set in getalltags.sh. if so, this is a cache of downloaded last.fm api data to prevent api overuse from multiple runs.

**script info**
ordered according to which scripts should run first:
* ripsongsoftheweek.sh - download the raw html of all links, run the scripts and let the page render using phantom.js, render the resulting html with w3m, and save parsed contributor information to output/songsoftheweek.dsv (delimited by "@").
* ripcontributor.sh - similar to ripsongsoftheweek.sh, saves all contributions by a single contributor to a text file in output/.
* getsonginfo.sh - a small wrapper script to fetch last.fm api data, given an artist and song title. this is not used directly; rather, it is used by getalltags.sh.
* getalltags.sh - parse output/songsoftheweek.dsv and feed information to getsonginfo.sh to generate songtags.dsv (delimited by "@"), containing track and tag data.
* gentagcsv.sh - parse output/songtags.dsv to create a sorted list of tag frequencies, stored at output/tagcount.csv.
* graphtagcount.r - parse output/tagcount.csv to create a pie chart, output/tagcount-pie.png, and a bar chart, output/tagcount-top10-bar.png.
* gencontributorcsv.sh - parse output/songsoftheweek.dsv to create a sorted list of contributors, stored output/contributorcount.csv
* graphcontributors.r - parse output/contributorcount.csv to create a bar chart, output/contributorcount-top10-bar.png

superimposer
------------
love2d frontend for compositing images with imagemagick's convert tool

**dependencies**: love, imagemagick

**usage**: love superimposer/ /path/to/baseImage.jpg /path/to/image2.png ...

this will open a window where baseImage serves as the base image and the other images are overlaid on top of it one at a time. a minimum of two images (one base and one overlay) must be supplied. images can be either jpg or png files. left mouse drags, right mouse rotates, scroll wheel scales, middle click moves on to the next image.

the program generates a shell script called superimposer.sh and quits when there are no images left to overlay. superimposer.sh contains the commands needed to composite the images as specified during the gui usage.

![demo image](README-images/superimposer.gif)

scripts
-------
miscellaneous small scripts

**dependencies**: imagemagick

* sortedimagegrid.sh - produces an almost square grid of images from a directory of images, ordered by increasing exif creation date and labeled with dd Month yyyy
