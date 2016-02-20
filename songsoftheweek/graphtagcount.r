#!/usr/bin/Rscript
# generate a pie chart from tag count

library(extrafont)
data <- read.csv(file="output/tagcount.csv",sep=",",header=TRUE)

png(
    filename="output/tagcount.png",
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
