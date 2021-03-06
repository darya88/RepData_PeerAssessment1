setwd("C:/Users/deepak.d.arya/Desktop/Trainings/Data Science - Coursera/Reproducible research/Week 2")
activity <- read.table("activity.csv", sep=",", header=T)
totalSteps <- aggregate(steps ~ date, data = activity, sum, na.rm = TRUE)

##What is mean total number of steps taken per day?
hist(totalSteps$steps,col="blue",main="Histogram of Total Steps taken per day",xlab="Total Steps taken per day",cex.axis=1,cex.lab = 1)
mean_steps <- mean(totalSteps$steps)
median_steps <- median(totalSteps$steps)

## What is the average daily activity pattern?
steps_interval <- aggregate(steps ~ interval, data = activity, mean, na.rm = TRUE)
plot(steps ~ interval, data = steps_interval, type = "l", xlab = "Time Intervals (5-minute)", ylab = "Mean number of steps taken (all Days)", main = "Average number of steps Taken at 5 minute Intervals",  col = "blue")
maxStepInterval <- steps_interval[which.max(steps_interval$steps),"interval"]

## Imputing missing values
missing_rows <- sum(!complete.cases(activity))
getMeanStepsPerInterval <- function(interval){
  steps_interval[steps_interval$interval==interval,"steps"]
}
complete.activity <- activity
flag = 0
for (i in 1:nrow(complete.activity)) {
  if (is.na(complete.activity[i,"steps"])) {
    complete.activity[i,"steps"] <- getMeanStepsPerInterval(complete.activity[i,"interval"])
    flag = flag + 1
  }
}
total.steps.per.days <- aggregate(steps ~ date, data = complete.activity, sum)
hist(total.steps.per.days$steps, col = "blue", xlab = "Total Number of Steps", 
     ylab = "Frequency", main = "Histogram of Total Number of Steps taken each Day")
showMean <- mean(total.steps.per.days$steps)
showMedian <- median(total.steps.per.days$steps)

## Are there differences in activity patterns between weekdays and weekends?
complete.activity$day <- ifelse(as.POSIXlt(as.Date(complete.activity$date))$wday%%6 == 
                                  0, "weekend", "weekday")
complete.activity$day <- factor(complete.activity$day, levels = c("weekday", "weekend"))
steps.interval= aggregate(steps ~ interval + day, complete.activity, mean)
library(lattice)
xyplot(steps ~ interval | factor(day), data = steps.interval, aspect = 1/2, 
       type = "l")

