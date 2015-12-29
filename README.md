tannertimes
===========
projects related to work for the tanner times

avibench
--------
a small smartphone browser performance survey suite including a server and data parser. originally meant for the android vs iphone article, hence "avi"

**dependencies**: an http server with php support, r with extrafont package, GNU grep

**usage**: if you have docker installed, serve.sh can set up and start up a containerized server for you that will collect responses; otherwise:

1. place all files into the root http directory of your preferred server
2. create directories named responses/ and graphs/ in this directory
3. make sure those directories are readable by your server
4. make sure responses/ is writable by your server
5. start up the server

parse.sh is a script to parse the data and generate graphs from responses in the responses/ directory and put them in the graphs/ directory. graphs.php generates a page with all of these graphs.

superimposer
------------
love2d frontend for compositing images with imagemagick's convert tool

**dependencies**: love, imagemagick

**usage**: love superimposer/ /path/to/image1.jpg /path/to/image2.png ...

this will open a window where image1 serves as the base image and the other images are overlaid on top of it, one by one. left mouse drags, right mouse rotates, scroll wheel scales, middle click moves on to the next image.

the program quits when there are no images left and generates a script called superimposer.sh. superimposer.sh contains the commands needed to composite the images as specified during the gui usage.

![demo image](README-images/superimposer.gif)
