# http://flowingdata.com/2010/11/23/how-to-make-bubble-charts/

crime <- read.csv("http://datasets.flowingdata.com/crimeRatesByState2008.csv",
                  header=TRUE, sep="\t")

## initial attempt
symbols(crime$murder, crime$burglary, circles=crime$population)

## Add population proportional circle sizing
radius <- sqrt(crime$population/ pi)
symbols(crime$murder, crime$burglary, circles=radius)

## Add colours and labels
symbols(crime$murder, crime$burglary, circles=radius,
        inches=0.35, fg="white", bg="red",
        xlab="Murder Rate", ylab="Burglary Rate")

## the following line would graph it with squares instead of circles
## symbols(crime$murder, crime$burglary, squares=sqrt(crime$population), inches=0.5)

## Add State names
text(crime$murder, crime$burglary, crime$state, cex=0.5)
