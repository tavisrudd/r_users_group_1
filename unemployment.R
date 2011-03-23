## This example is derived from the following blog post and its comments:
## http://flowingdata.com/2010/03/29/how-to-make-a-scatterplot-with-a-smooth-fitted-line/2
##

## install.packages("ggplot2")
library(ggplot2)

unemployment <- read.csv("http://datasets.flowingdata.com/unemployment-rate-1948-2010.csv", sep=",")
main_title <- "United States Unemployment Rate, 1948-2010"

chart.unemployment.with.ggplot <- function () {
  chart <- (ggplot(unemployment, aes(x=Year, y=Value))
            + geom_point(color="grey")
            + geom_line(color="lightgrey")
            + geom_smooth()
            + opts(title=main_title)
            + ylab("% Unemployment")
            + xlab("Year"))
  print(chart)
}

chart.unemployment.with.ggplot() ## renders to screen

chart.unemployment.with.base.graphics <- function () {
  ## http://flowingdata.com/2010/03/29/how-to-make-a-scatterplot-with-a-smooth-fitted-line/#comment-41502
  x <- 1:length(unemployment$Value)
  y <- unemployment$Value
  plot(x, y, ylim=c(0,11), col="gray", axes=FALSE, xlab='', ylab='')
  axis(1, c(1, (1:4)*15*12),
       labels=c('1948', '1963', '1978', '1993', '2008'),
       cex.axis=0.8,
       font=3)
  axis(2, seq(0,10,2), labels=FALSE)
  labels=paste(seq(0,10,2), '%', sep='')
  text(-40, seq(0,10,2), labels=labels, cex=0.8, pos=2, xpd=TRUE)
  text(-130, 12, labels=main_title, xpd=TRUE, pos=4)
  abline(h=seq(0,10,2), col="lightgray", lty="dotted")
  l <- loess(y~x) # a type of localized regression curve (like geom_smooth)
  lines(x, predict(l), lwd=3)
  text(-130, -3,
       labels='Source:Bureau of Labor Statistics | FlowingData, http://flowingdata.com',
       cex=0.5, font=3, pos=4, xpd=TRUE)
}
