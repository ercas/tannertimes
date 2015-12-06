# generated with parse.sh

library(extrafont)
data <- read.csv(file='data/byTrial.csv', sep='|', header=TRUE)
androidcolor <- "#78c25a"
iphonecolor <- "#f7f9fa"
windowscolor <- "#0078d7"

png(
    filename='graphs/10000000 increments.png',
    width=1280,
    height=800,
    pointsize=32,
    family='Ubuntu Light'
)
boxplot(
    subset(data,PHONE == 'Android' & TASK == '10000000 increments')$RESULTS,subset(data,PHONE == 'iPhone' & TASK == '10000000 increments')$RESULTS,subset(data,PHONE == 'Windows Phone' & TASK == '10000000 increments')$RESULTS,
    main='Task: 10000000 increments',
    xlab='Operating System',
    ylab='Completion Time (Milliseconds)',
    names=c('Android','iPhone','Windows Phone'), # should be same order as for loop
    col=c(androidcolor,iphonecolor,windowscolor),
    frame.plot=FALSE
)
dev.off()

png(
    filename='graphs/2048!.png',
    width=1280,
    height=800,
    pointsize=32,
    family='Ubuntu Light'
)
boxplot(
    subset(data,PHONE == 'Android' & TASK == '2048!')$RESULTS,subset(data,PHONE == 'iPhone' & TASK == '2048!')$RESULTS,subset(data,PHONE == 'Windows Phone' & TASK == '2048!')$RESULTS,
    main='Task: 2048!',
    xlab='Operating System',
    ylab='Completion Time (Milliseconds)',
    names=c('Android','iPhone','Windows Phone'), # should be same order as for loop
    col=c(androidcolor,iphonecolor,windowscolor),
    frame.plot=FALSE
)
dev.off()

png(
    filename='graphs/75 regex replaces, 371 characters, 16 reps.png',
    width=1280,
    height=800,
    pointsize=32,
    family='Ubuntu Light'
)
boxplot(
    subset(data,PHONE == 'Android' & TASK == '75 regex replaces, 371 characters, 16 reps')$RESULTS,subset(data,PHONE == 'iPhone' & TASK == '75 regex replaces, 371 characters, 16 reps')$RESULTS,subset(data,PHONE == 'Windows Phone' & TASK == '75 regex replaces, 371 characters, 16 reps')$RESULTS,
    main='Task: 75 regex replaces, 371 characters, 16 reps',
    xlab='Operating System',
    ylab='Completion Time (Milliseconds)',
    names=c('Android','iPhone','Windows Phone'), # should be same order as for loop
    col=c(androidcolor,iphonecolor,windowscolor),
    frame.plot=FALSE
)
dev.off()

png(
    filename='graphs/SJCL encrypt, decrypt 371 characters, 32 reps.png',
    width=1280,
    height=800,
    pointsize=32,
    family='Ubuntu Light'
)
boxplot(
    subset(data,PHONE == 'Android' & TASK == 'SJCL encrypt, decrypt 371 characters, 32 reps')$RESULTS,subset(data,PHONE == 'iPhone' & TASK == 'SJCL encrypt, decrypt 371 characters, 32 reps')$RESULTS,subset(data,PHONE == 'Windows Phone' & TASK == 'SJCL encrypt, decrypt 371 characters, 32 reps')$RESULTS,
    main='Task: SJCL encrypt, decrypt 371 characters, 32 reps',
    xlab='Operating System',
    ylab='Completion Time (Milliseconds)',
    names=c('Android','iPhone','Windows Phone'), # should be same order as for loop
    col=c(androidcolor,iphonecolor,windowscolor),
    frame.plot=FALSE
)
dev.off()

