require(zoo)
require(Cairo)
require(lattice)
require(timeDate)

df <- read.csv("/home/tavis/r_workspace/unit_stats_by_day.csv")
order.stats <- zoo(base::cbind(df[2:47]), as.Date(df$day))

## http://stackoverflow.com/questions/1169376/cumulative-sums-moving-averages-and-sql-group-by-equivalents-in-r
get.weeks <- function(x) {7 * ceiling(as.numeric(x-1)/7) + as.Date(3)}
get.months <- function(x) {as.Date(as.yearmon(x))}
get.qtrs <- function(x) {as.Date(as.yearqtr(x))}

by.bizday <- function(data) {
  days <- time(data)
  data[isBizday(as.timeDate(days), holidays=holidayNYSE(2006:2010))]
}
by.week <- function(data) aggregate(data, get.weeks, sum)
by.month <- function(data) aggregate(data, get.months, sum)
by.qtr <- function(data) aggregate(data, get.qtrs, sum)

order.stats.by.bizday <- by.bizday(order.stats)
order.stats.by.week <- by.week(order.stats)
order.stats.by.month <- by.month(order.stats)
order.stats.by.qtr <- by.qtr(order.stats)

################################################################################

subset.cols <- c('units', 'PFM', 'CAST_PARTIALS', 'CAPTEK')

days <- time(order.stats)
monthboundaries <- seq(as.Date(as.yearmon(min(days))),
                       max(days)+6,
                       "months")
yearboundaries <- seq(as.Date(format(min(days),"%Y-01-01")),
                      max(days)+6,
                      "years")
jan <- format(monthboundaries, "%m") == "01"
monthticks <- monthboundaries[!jan]
mlab <- substr(months(monthticks), 1, 1)

plot.volume.ts <- function(data=by.week(order.stats[, subset.cols]),
                      type="s",
                      show.trend=TRUE,
                      trend.span=1/10) {
  xyplot(data,
         plot.type = "multiple",
         type=type,
         lwd=.5,
         main="Unit Volume By Product Type",
         ylab="Units",
         xlab="Month/Year",
         between=list(y=.5),
         transparent=TRUE,
         xscale.components=function(...) {
           ans <- xscale.components.default(...)
           ans$top <- TRUE
           ans
         },
         panel=function(x,y, ...) {
           panel.axis("bottom",
                      check.overlap=TRUE,
                      outside=FALSE,
                      half=FALSE,
                      rot=0,
                      labels=mlab,
                      tck=.1,
                      at=monthticks,
                      text.col="grey",
                      )                   
           panel.grid(v=0)
           panel.abline(v=monthticks,
                        col="grey",
                        lwd=.2,
                        lty=1)
           panel.abline(v=yearboundaries,
                        col="black",
                        lwd=.5,
                        lty=1)
           panel.plot.default(x,y,...)
           if (show.trend) {
             panel.loess(x,y, span=trend.span, col="red")
           }
         })
}

if (0 && dev.cur()==1) {
  ##CairoX11()
  CairoPNG(filename='/tmp/test.png', width=800, height=600)
}

plot.volume.ts()
