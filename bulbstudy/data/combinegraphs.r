#!/usr/bin/Rscript
# generated with parse.sh

library(extrafont)

data <- read.csv(file='average_monthly_costs_cents-per-kWh.csv', sep=',', header=TRUE)
residential_cost <- data$AVERAGE.RESIDENTIAL.COST..cents.kWh.
commercial_cost <- data$AVERAGE.COMMERCIAL.COST..cents.kWh.
industrial_cost <- data$AVERAGE.INDUSTRIAL.COST..cents.kWh.
months_since_2010_01 <- data$MONTHS.SINCE.JANUARY.2010

w = 1200
h = 800
pt = 24
shape = 16
lmWidth = 5

citation="Data obtained from the U.S. Energy Information Administration's Electric Power Monthly, https://www.eia.gov/electricity/monthly/"
citation_scale=0.6

png(
    filename='graphs/combined.png',
    width=w,
    height=h,
    pointsize=pt,
    family='Ubuntu Light'
)

# create blank plot
plot(
    x=NULL,
    y=NULL,
    main='Average Electricity Costs from Oct 2010 to Jan 2016',
    xlab="Months since January 2010",
    ylab="Cost (cents per kWh)",
    xlim=range(min(months_since_2010_01):max(months_since_2010_01)),
    ylim=range(
        (min(residential_cost,commercial_cost,industrial_cost)-0.5):
        (max(residential_cost,commercial_cost,industrial_cost)+0.5)
    ),
    frame.plot=FALSE
)

# create regression lines
abline(
    lm(residential_cost ~ months_since_2010_01),
    lwd = lmWidth,
    col = "darkgreen"
)
abline(
    lm(commercial_cost ~ months_since_2010_01),
    lwd = lmWidth,
    col = "blue"
)
abline(
    lm(industrial_cost ~ months_since_2010_01),
    lwd = lmWidth,
    col = "black"
)

# plot points
points(
    months_since_2010_01,
    residential_cost,
    pch=shape,
    col="darkgreen",
)
points(
    months_since_2010_01,
    commercial_cost,
    pch=shape,
    col="blue"
)
points(
    months_since_2010_01,
    industrial_cost,
    pch=shape,
    col="black"
)

# create legend
legend(
       10,20,
    c("Residential","Commercial","Industrial"),
    lty=NULL,
    bty="n",
    pch=shape,
    col=c("darkgreen","blue","black"),
)


# add citation
mtext(citation,side=3,cex=citation_scale)

dev.off()
