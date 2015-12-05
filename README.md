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
 3. start up the server
parse.sh is a script to parse the data and generate graphs from responses in the responses/ directory and put them in the graphs/ directory. graphs.php generates a page with all of these graphs.
