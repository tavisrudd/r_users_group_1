## http://www.statistik.tuwien.ac.at/public/filz/students/seminar/ws1011/bauer_Rcode.R
## this 

## install.packages("ggplot2")

library(ggplot2)
data(diamonds)


set.seed(1410)
dsmall <- diamonds[sample(nrow(diamonds), 100), ]	# create random sample of 100 diamonds

qplot(carat, price, data=diamonds)

## qplot(log(carat), log(price), data=diamonds)	# log the axes
qplot(carat, price, data=diamonds, log="xy")	# does the same

qplot(carat, price, data=diamonds, alpha=I(1/10))	# makes the points semi-transparent



## Boxplots and jittered points

qplot(color, price/carat, data=diamonds, geom="jitter", alpha=I(1/10))

qplot(color, price/carat, data=diamonds, geom="boxplot")

## Histogram and density plots

qplot(carat, data=diamonds, geom="histogram", binwidth=0.1)

qplot(carat, data=diamonds, geom="density")


## Facets

qplot(carat, data=diamonds, facets=color ~., geom="histogram", binwidth=0.1, xlim=c(0,3))

qplot(carat, ..density..,  data=diamonds, facets=color ~.,
      geom="histogram", binwidth=0.1, xlim=c(0,3))


### Layer Examples #########################################################

p <- ggplot(diamonds, aes(carat, price, colour=cut))	# creates plot object
p <- p + layer(geom="point")
print(p)

p <- ggplot(diamonds, aes(x=carat))		# complex example
p <- p + layer(
	geom="bar", 
	geom_params=list(fill="steelblue"), 
	stat="bin", 
	stat_params=list(binwidth = 2))

p

p <- ggplot(diamonds, aes(x=carat))		# the same example but simplified
p <- p + geom_histogram(binwidth=2, fill="steelblue")

p

