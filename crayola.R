#http://learnr.wordpress.com/2010/01/21/ggplot2-crayola-crayon-colours/
library(Cairo)
library(XML)
library(ggplot2)
library(colorspace)

## scrape the data from Wikipedia
crayola <- readHTMLTable(
                         htmlParse("http://en.wikipedia.org/wiki/List_of_Crayola_crayon_colors"),
                         stringsAsFactors=FALSE)[[2]]


## take a subset and assign names to the columns
crayola <- crayola[, c("Hex Code", "Issued", "Retired")]
names(crayola) <- c("colour", "issued", "retired")


## remove duplicates
crayola <- crayola[!duplicated(crayola$colour), ]

crayola$retired[crayola$retired == ""] <- 2010

## colours <- ddply(crayola,
##                  .(colour),
##                  transform,
##                  year=issued:retired)

## p <- (ggplot(colours, aes(year, 1, fill=colour))
##       + geom_bar(width=1, position="fill", binwidth=1)
##       + theme_bw()
##       + scale_fill_identity())

p1 <- (ggplot(colours, aes(year, 1, fill=colour))
       + geom_area(position="fill", colour="white")
       + theme_bw() + scale_fill_identity())

## configure our axes
labels <- c(1903, 1949, 1958, 1972, 1990, 1998, 2010)
breaks <- labels - 1
p2 <- (p1
       + scale_x_continuous("", breaks=breaks, labels=labels, expand=c(0, 0))
       + scale_y_continuous("", expand=c(0, 0))
       + opts(axis.text.y=theme_blank(), axis.ticks=theme_blank()))

p2

sort.colours <- function(col) {
  c.rgb = col2rgb(col)
  c.RGB = RGB(t(c.rgb) %*% diag(rep(1/255, 3)))
  c.HSV = as(c.RGB, "HSV")@coords
  order(c.HSV[, 1], c.HSV[, 2], c.HSV[, 3])
}

colours <- ddply(colours,
  .(year),
  function(d) {
    d[rev(sort.colours(d$colour)),]
  })

p2 %+% colours

##  etags --language=none --regex='/\([^ \t]+\)[ \t]*<-[ \t]*function/\1/' *.R 
