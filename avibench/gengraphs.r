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
    subset(data,PHONE == 'android' & TASK == '10000000 increments')$RESULTS,subset(data,PHONE == 'iphone' & TASK == '10000000 increments')$RESULTS,subset(data,PHONE == 'windows phone' & TASK == '10000000 increments')$RESULTS,
    main='"10000000 increments" Completion Time',
    xlab='Operating System',
    ylab='Time (Milliseconds)',
    names=c('Android', 'iPhone', 'Windows Phone'), # should be same order as for loop
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
    subset(data,PHONE == 'android' & TASK == '2048!')$RESULTS,subset(data,PHONE == 'iphone' & TASK == '2048!')$RESULTS,subset(data,PHONE == 'windows phone' & TASK == '2048!')$RESULTS,
    main='"2048!" Completion Time',
    xlab='Operating System',
    ylab='Time (Milliseconds)',
    names=c('Android', 'iPhone', 'Windows Phone'), # should be same order as for loop
    col=c(androidcolor,iphonecolor,windowscolor),
    frame.plot=FALSE
)
dev.off()

png(
    filename='graphs/sjcl encrypt&decrypt 45248 characters.png',
    width=1280,
    height=800,
    pointsize=32,
    family='Ubuntu Light'
)
boxplot(
    subset(data,PHONE == 'android' & TASK == 'sjcl encrypt&decrypt 45248 characters')$RESULTS,subset(data,PHONE == 'iphone' & TASK == 'sjcl encrypt&decrypt 45248 characters')$RESULTS,subset(data,PHONE == 'windows phone' & TASK == 'sjcl encrypt&decrypt 45248 characters')$RESULTS,
    main='"sjcl encrypt&decrypt 45248 characters" Completion Time',
    xlab='Operating System',
    ylab='Time (Milliseconds)',
    names=c('Android', 'iPhone', 'Windows Phone'), # should be same order as for loop
    col=c(androidcolor,iphonecolor,windowscolor),
    frame.plot=FALSE
)
dev.off()

