# http://flowingdata.com/2010/03/29/how-to-make-a-scatterplot-with-a-smooth-fitted-line/
library(ggplot2)
unemployment <- read.csv("http://datasets.flowingdata.com/unemployment-rate-1948-2010.csv",
                         sep=",")

p1 <- (ggplot(unemployment, aes(x=1:length(Value), y=Value))
       + geom_point()
       + geom_smooth())
print(p1)
