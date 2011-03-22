## http://nsaunders.wordpress.com/2009/12/23/the-life-scientists-at-friendfeed-2009-summary/

library(ggplot2) # also loads library plyr
source("calendarHeat.R") # unfortunately not a real library


setwd("~/r_users_group_1/")


tls <- read.csv("tls-20091223.unique.csv", header=T)
# dim(tls)

posts <- as.data.frame(table(tls$date))
# dim(posts)
lc <- ddply(tls, c("date"),
            function(df) {
              data.frame(likes=sum(df$likes),
                         comments=sum(df$comments))
            })
          

## create calendar heatmap for posts
png(filename="tls-posts.png", type="cairo", width=640)
calendarHeat(posts$Var1, posts$Freq, varname="The Life Scientists 2009: Posts", color="r2b")
dev.off()

                                        ## similarly for likes and comments (latter not shown)
png(filename="tls-likes.png", type="cairo", width=640)
calendarHeat(lc$date, lc$likes, varname="The Life Scientists 2009: Likes", color="r2b")
dev.off()

## fivenum() = minimum, lower-hinge, median, upper-hinge, maximum

## stats per day
fivenum(posts)

fivenum(lc$likes)

fivenum(lc$comments)

## stats per post
fivenum(tls$likes)

fivenum(tls$comments)




## qplot likes (comments done in similar way)
## qplot stands for 'quick plot' http://had.co.nz/ggplot2/book/qplot.pdf
png(filename="tls-likes-dist.png", type="cairo", width=640)
qplot(likes, data=tls, main="Life Scientists 2009: likes distribution")
dev.off()

# likes/comments correlation
# first do cor.test(tls$likes, tls$comments, method="kendall")
# then do cor.test(lc$likes, lc$comments, method="kendall")
# then e.g.
png(filename="date-lc.png", type="cairo", width=640)
qplot(likes, comments, data=lc,
      main="Life Scientists 2009 likes/comments/by date: Kendall: z = 15.159, tau = 0.556")
dev.off()


## list the top 10 posts by comment activity
tls[sort.list(tls$comments, decreasing=T),][1:10,]

## list top 10 by 'likes'
tls[sort.list(tls$likes, decreasing=T),][1:10,]


# write out list of entry IDs from R, e.g. for likes
write(as.vector(tls[sort.list(tls$likes, decreasing=T),][1:10,1]), "likes.list")
## # fetch JSON in bash
## for i in $(cat likes.list); do curl "http://friendfeed-api.com/v2/entry/$i?pretty=1" >> likes.json; done
