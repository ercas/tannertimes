mkdir -p responses/
chmod a+w responses/
docker run -d \
    -p 80:80 \
    -v $(pwd):/var/www/localhost/htdocs/ \
    ercas/lighttpd-fastcgi
