## This example is an extension of what Saem and Harvey did during the
## first meetup using property tax data from:
## http://data.vancouver.ca/datacatalogue/propertyTax.htm


################################################################################
## This block is essentially what Saem and Harvey did during the meetup:
## first download and unzip:
## "ftp://webftp.vancouver.ca/OpenData/csv/property_tax_report_csv.zip"

df = read.csv("property_tax_report.csv", as.is=TRUE)
df <- subset(df,
             subset=(CURRENT_LAND_VALUE < 3000000
                     & CURRENT_LAND_VALUE > 10000
                     & LEGAL_TYPE != "OTHER"
                     & YEAR_BUILT > 1950
                     & YEAR_BUILT < 2010),
             select=c("PID", "LEGAL_TYPE", "CURRENT_LAND_VALUE",  "YEAR_BUILT"))

hist(df$CURRENT_LAND_VALUE, freq=TRUE, col=TRUE, breaks=100)
## see van_housing_orig.png

################################################################################
## I (Tavis) added the rest of this after the meetup. It's clear in
## their histogram that there's a bimodal distribution of property
## values and we guessed it was actually two different distributions:
## condos vs houses. I used ggplot to explore that hypothesis and to
## view the change in the distributions by decade.

library(ggplot2)
library(Cairo)
CairoX11(width=16, height=8)

decade <- function (y) (y %/% 10) * 10
df$DECADE <- factor(decade(df$YEAR_BUILT))

fmtDollar <- function (x) {
  if (x < 1000) {
    "$1K"
  } else if (x < 1e+05) {
    paste("", round_any(x/1000, 0.1) , "K", sep="")
  } else {
    paste("", round_any(x/1e+06, 0.1) , "M", sep="")
  }
}

vanprop.plot <- function (mapping, facet) {
  (ggplot(df, mapping)
   + geom_bar(binwidth=50000)
   + facet_grid(facet)
   + scale_x_continuous(formatter=function (x) sapply(x, fmtDollar))
   + xlab("")
   + ylab("Number Of Properties")
   + theme_bw()
   + opts(title="Vancouver Assessed Property Value By Decade Built",
          plot.margin=unit(c(0,0,0,0), "char")))
}

print.vanplot <- function (p, filename, width=16, height=8) {
  print(p) # first print to screen
  png.dev <- CairoPNG(filename=filename, width=width*100, height=height*100, bg="white")
  print(p)
  dev.off(png.dev)
}

print.vanplot(vanprop.plot(aes(CURRENT_LAND_VALUE), ". ~ DECADE"),
              "van_housing_facet_by_decade.png")

print.vanplot(vanprop.plot(aes(CURRENT_LAND_VALUE), "LEGAL_TYPE ~ DECADE"),
              "van_housing_facet_by_type_and_decade.png")

print.vanplot(vanprop.plot(aes(CURRENT_LAND_VALUE, fill=LEGAL_TYPE), ". ~ DECADE"),
              "van_housing_facet_by_decade_colour_by_type.png")

print.vanplot(vanprop.plot(aes(CURRENT_LAND_VALUE, fill=LEGAL_TYPE), "LEGAL_TYPE ~ DECADE"),
              "van_housing_facet_by_type_and_decade_colour_by_type.png")

print.vanplot((vanprop.plot(aes(CURRENT_LAND_VALUE, fill=LEGAL_TYPE), "LEGAL_TYPE ~ DECADE")
               + opts(strip.text.y = theme_blank())),
              "van_housing_facet_by_type_and_decade_colour_by_type_final.png")

