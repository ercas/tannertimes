#!/bin/sh
cd "$(dirname "$0")"
mkdir -p config output xml
echo "please enter last.fm api key then press enter: "
read apikey
echo $apikey > config/api\ key.txt
> config/articles.txt
echo "paste article urls into config/articles.txt to complete the setup."
