#!/usr/bin/bash

########## generate csv files

workdir=parsedResponses
outdir="data"
sep="|"

mkdir -p $workdir $outdir
(grep -rliE "^    user-agent:.*(android|iphone|windows phone)" responses/ && echo $workdir) | xargs cp
rm $outdir/*

echo "PHONE${sep}TASK${sep}RESULTS" | tee $outdir/raw.csv >  $outdir/byTrial.csv
for phone in android iphone "windows phone"; do
    grep -rli "^    user-agent:.*$phone" $workdir | while read file; do
        sed -n "s/^task: //p" $file | while read task; do
            results="$(grep -ozP "(?<=^task: $task\n    items: ).*(?=\n)" $file | tr -dc "[0-9],")" 
            if ! [ -z "$results" ]; then
                # dirty carriage return slipped in somewhere, tr -d "\r" needed

                tr -d "\r" <<< "${phone}${sep}${task}${sep}${results}" >> $outdir/raw.csv

                tr "," "\n" <<< "$results" | while read trial; do
                    tr -d "\r" <<< "${phone}${sep}${task}${sep}${trial}" >> $outdir/byTrial.csv
                done
            fi
        done
    done
done

rm -rf $workdir

########## generate R script

script=gengraphs.r
# labels should be in the same order as the loop below
labels="'Android','iPhone','Windows Phone'"

echo 'data <- read.csv(file="data/byTrial.csv",sep="|",header=TRUE)' > $script
for task in "2048!" "10000000 increments"; do
    echo -n "boxplot("
    for phone in android iphone "windows phone"; do
        echo -n "subset(data,PHONE == '$phone' & TASK == '$task')\$RESULTS,"
    done | head -c -1
    echo ",main='$task',xlab='Phone',ylab='Time (Milliseconds)',names=c($labels))"
done >> $script
