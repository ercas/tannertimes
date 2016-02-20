#!/usr/bin/Rscript

library(extrafont)
data <- read.csv(file="output/contributorcount.csv",sep=",",header=TRUE)

# top 10 bar chart
rows <- nrow(data)
data_cropped <- data[c((rows-9):rows),]
png(
    filename="output/contributorcount-top10-bar.png",
    width=2000,
    height=600,
    pointsize=18,
    family="Ubuntu Light"
)
barplot(
    data_cropped$COUNT,
    names=data_cropped$CONTRIBUTOR,
    main="Contributions of Top 10 Contributors",
    ylab="Songs",
    xlab="Contributor",
    col=cm.colors(10),
)
dev.off()
