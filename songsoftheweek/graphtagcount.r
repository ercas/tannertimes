#!/usr/bin/Rscript

library(extrafont)
data <- read.csv(file="output/tagcount.csv",sep=",",header=TRUE)

# pie chart
png(
    filename="output/tagcount-pie.png",
    width=2000,
    height=2000,
    pointsize=16,
    family="Ubuntu Light"
)
pie(
    data$COUNT,
    labels=data$TAG,
    main="Most Popular Tags",
    edges=666,
    radius=0.9
)
dev.off()

# top 10 bar chart (excluding "other")
rows <- nrow(data)
data_cropped <- data[c((rows-10):(rows-1)),]
png(
    filename="output/tagcount-top10-bar.png",
    width=2000,
    height=600,
    pointsize=21,
    family="Ubuntu Light"
)
barplot(
    data_cropped$COUNT,
    names=data_cropped$TAG,
    main="Frequencies of Most Popular Tags (excluding \"other\")",
    ylab="Frequency",
    xlab="Tag",
    col=cm.colors(10),
)
dev.off()
