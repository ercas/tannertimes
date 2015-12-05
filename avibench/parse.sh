#!/usr/bin/bash

########## generate csv files

workdir=parsedResponses
datadir="data"
sep="|"

mkdir -p $workdir $datadir
(grep -rliE "^    user-agent:.*(android|iphone|windows phone)" responses/ && echo $workdir) | xargs cp
rm $datadir/*

>$datadir/tasks.config
echo "PHONE${sep}TASK${sep}RESULTS" | tee $datadir/raw.csv >  $datadir/byTrial.csv
for phone in android iphone "windows phone"; do
    grep -rli "^    user-agent:.*$phone" $workdir | while read file; do
        sed -n "s/^task: //p" $file | while read task; do
            results="$(grep -ozP "(?<=^task: $task\n    items: ).*(?=\n)" $file | tr -dc "[0-9],")" 
            if ! [ -z "$results" ]; then
                # dirty carriage return slipped in somewhere, tr -d "\r" needed
                task=$(tr -d "\r" <<< "$task")

                echo "${phone}${sep}${task}${sep}${results}" >> $datadir/raw.csv

                tr "," "\n" <<< "$results" | while read trial; do
                    echo "${phone}${sep}${task}${sep}${trial}" >> $datadir/byTrial.csv
                done

                echo $task >> $datadir/tasks.config
            fi
        done
    done
done
sort $datadir/tasks.config | uniq > tasks.config.temp
mv tasks.config.temp $datadir/tasks.config

rm -rf $workdir

########## generate and run R script to create graphs

script=gengraphs.r
graphdir=graphs

mkdir -p $graphdir
rm $graphdir/*

cat << EOF > $script
# generated with parse.sh

library(extrafont)
data <- read.csv(file='data/byTrial.csv', sep='|', header=TRUE)
androidcolor <- "#78c25a"
iphonecolor <- "#f7f9fa"
windowscolor <- "#0078d7"

EOF
cat $datadir/tasks.config | while read task; do
    subsets=$(for phone in android iphone "windows phone"; do
        echo -n "subset(data,PHONE == '$phone' & TASK == '$task')\$RESULTS,"
    done | head -c -1)
    cat << EOF >> $script
png(
    filename='$graphdir/$task.png',
    width=1280,
    height=800,
    pointsize=32,
    family='Ubuntu Light'
)
boxplot(
    $subsets,
    main='"$task" Completion Time',
    xlab='Operating System',
    ylab='Time (Milliseconds)',
    names=c('Android', 'iPhone', 'Windows Phone'), # should be same order as for loop
    col=c(androidcolor,iphonecolor,windowscolor),
    frame.plot=FALSE
)
dev.off()

EOF
done

Rscript $script
