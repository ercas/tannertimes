#!/usr/bin/Rscript
# generated with parse.sh

library(extrafont)
data <- read.csv(file='average_monthly_costs_cents-per-kWh.csv', sep=',', header=TRUE)
w=1200
h=800
pt=24
shape=16

citation="Data obtained from the U.S. Energy Information Administration's Electric Power Monthly, https://www.eia.gov/electricity/monthly/"
citation_scale=0.6

png(
    filename='graphs/residential.png',
    width=w,
    height=h,
    pointsize=pt,
    family='Ubuntu Light'
)
plot(
    data$MONTHS.SINCE.JANUARY.2010,
    data$AVERAGE.RESIDENTIAL.COST..cents.kWh.,
    main='Average Residential Electricity Costs from Oct 2010 to Jan 2016',
    xlab='Months since January 2010',
    ylab='Average Cost (cents/kWh)',
    pch=shape,
    frame.plot=FALSE,
    col="darkgreen"
)
mtext(citation,side=3,cex=citation_scale)
dev.off()

png(
    filename='graphs/commercial',
    width=w,
    height=h,
    pointsize=pt,
    family='Ubuntu Light'
)
plot(
    data$MONTHS.SINCE.JANUARY.2010,
    data$AVERAGE.COMMERCIAL.COST..cents.kWh.,
    main='Average Commercial Electricity Costs from Oct 2010 to Jan 2016',
    xlab='Months since January 2010',
    ylab='Average Cost (cents/kWh)',
    pch=shape,
    frame.plot=FALSE,
    col="blue"
)
mtext(citation,side=3,cex=citation_scale)
dev.off()

png(
    filename='graphs/industrial',
    width=w,
    height=h,
    pointsize=pt,
    family='Ubuntu Light'
)
plot(
    data$MONTHS.SINCE.JANUARY.2010,
    data$AVERAGE.INDUSTRIAL.COST..cents.kWh.,
    main='Average Industrial Electricity Costs from Oct 2010 to Jan 2016',
    xlab='Months since January 2010',
    ylab='Average Cost (cents/kWh)',
    pch=shape,
    frame.plot=FALSE,
    col="black"
)
mtext(citation,side=3,cex=citation_scale)
dev.off()
