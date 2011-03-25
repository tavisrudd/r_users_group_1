## This example uses the ggplot2 charting library to plot
## cell phone subscription data from the World Bank:
## http://data.worldbank.org/indicator/IT.CEL.SETS.P2

## install.packages(c("ggplot2","WDI", "Cairo"))
require(WDI) 
require(ggplot2)
require(Cairo)

chart.world.bank.celldata <- function (indicator="IT.CEL.SETS.P2",
                                      start=1993,
                                      end=2008,
                                      title="Mobile cellular subscriptions (per 100 people)",
                                      ylab="Subscriptions per 100 people") {
  df <- WDI(country=c("US","CA","CN", "DE","JP"), indicator=indicator, start=start, end=end)
  ## df stands for data.frame
  chart <- (
         ggplot(df, mapping=aes_string(x="year", y=indicator))
            + aes(color=country) # aes stands for aesthetic
            + geom_point()
            #+ geom_smooth()
            + geom_line()
            + theme_bw()
            + opts(title=title)
            + ylab(ylab)
            + xlab("Year"))
  print(chart)
}

chart.world.bank.celldata() # plots to screen

################################################################################
plot.to.png <- function (chart.callback, filename, width=1200, height=800) {
  chart.dev <- CairoPNG(filename=filename, width=width, height=height, bg="white")
  chart.callback()
  dev.off(chart.dev)
}
plot.to.png(chart.world.bank.celldata, "cellphone_chart.png")
