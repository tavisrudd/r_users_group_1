# install.packages(c("ggplot2","WDI", "Cairo"))
require(WDI) 
require(ggplot2)
require(Cairo)

demo.world.bank.celldata <- function (indicator="IT.CEL.SETS.P2",
                                      start=1993,
                                      end=2008,
                                      title="Mobile cellular subscriptions (per 100 people)",
                                      ylab="Subscriptions per 100 people") {
  df <- WDI(country=c("US","CA","CN", "DE","JP"), indicator=indicator, start=start, end=end)
  p1 <- (
         ggplot(df, mapping=aes_string(x="year", y=indicator))
         + aes(color=country)
         + geom_point(stat="identity")
         + geom_smooth(stat="identity")
         + theme_bw()
         + opts(title=title)
         + ylab(ylab)
         + xlab("Year"))
  print(p1)
}

plot.to.png <- function (chart.callback, filename, width=1200, height=800) {
  chart.dev <- CairoPNG(filename=filename, width=width, height=height, bg="white")
  chart.callback()
  dev.off(chart.dev)
}

demo.world.bank.celldata() # plots to screen

plot.to.png(demo.world.bank.celldata, "cellphone_chart.png")
