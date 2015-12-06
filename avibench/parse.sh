#!/usr/bin/bash

# these should be in the order and capitalization that will be displayed in the graph
operatingSystems=(Android iPhone "Windows Phone")

########## generate csv files

workdir=parsedResponses
datadir="data"
sep="|"

# setup
mkdir -p $workdir $datadir
rm $datadir/*
>$datadir/tasks.config
echo "PHONE${sep}TASK${sep}RESULTS" | tee $datadir/raw.csv >  $datadir/byTrial.csv

# copy all files with proper user-agent strings into $workdir
(grep -riE "^    user-agent:.*($(printf "%s|" "${operatingSystems[@]}" | head -c -1))" responses/ | \
    grep -iv "ipod" | cut -d ":" -f1 && \
    echo $workdir) | xargs cp

# iterate over all phones in the $operatingSystems array, grep -r for test data
# about those phones, extract the test data, and write to files in $datadir
for phone in "${operatingSystems[@]}"; do
    grep -rli "^    user-agent:.*$phone" $workdir | while read file; do
        sed -n "s/^task: //p" $file | while read task; do
            results="$(grep -ozP "(?<=^task: $task\n    items: ).*(?=\n)" $file | tr -dc "[0-9],")" 
            if ! [ -z "$results" ]; then
                # dirty carriage return slipped in somewhere, tr -d "\r" needed
                task=$(tr -d "\r" <<< "$task")
                
                # this is essentially just the test data reformatted
                echo "${phone}${sep}${task}${sep}${results}" >> $datadir/raw.csv

                # this separates the "(?<=items: ).*" list by commas and puts
                # each result on a separate line of the csv
                tr "," "\n" <<< "$results" | while read trial; do
                    echo "${phone}${sep}${task}${sep}${trial}" >> $datadir/byTrial.csv
                done
                
                # automatically generate a list of tasks
                echo $task >> $datadir/tasks.config
            fi
        done
    done
done

# remove duplicates from task list
sort $datadir/tasks.config | uniq > tasks.config.temp
mv tasks.config.temp $datadir/tasks.config

# cleanup
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

# iterate over every task in the tasks.config file generated earlier and create
# side by side box plots for each one, using subsets of the data frame for each
# box plot
cat $datadir/tasks.config | while read task; do
    subsets=$(for phone in "${operatingSystems[@]}"; do
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
    main='Task: $task',
    xlab='Operating System',
    ylab='Completion Time (Milliseconds)',
    names=c($(printf "'%s'," "${operatingSystems[@]}" | head -c -1)), # should be same order as for loop
    col=c(androidcolor,iphonecolor,windowscolor),
    frame.plot=FALSE
)
dev.off()

EOF
done

Rscript $script
