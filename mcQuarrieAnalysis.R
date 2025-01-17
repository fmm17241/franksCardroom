# Set working directory, and read in my datasets as .csv
setwd('C:/Users/fmm17241/OneDrive - University of Georgia/statisticalAnalysis/envStatsSpring2024')
#setwd('C:/Users/fmac4/OneDrive - University of Georgia/statisticalAnalysis/envStatsSpring2024')

#Installs and calls all packages. Probably too many, used them at one point.
install.packages("ggplot2")
install.packages("mgcv")
install.packages("itsadug")
install.packages("AER")
install.packages("TSA")
library(ggplot2)
library(mgcv)
library(itsadug)
library(AER)
install.packages("pscl")
library(pscl)
install.packages("rstan")
library(rstan)
library(ggplot2)
library(tidyverse)
install.packages("psych")
library(psych)
library(ggplot2)
library(gridExtra)
library(TSA)
library('zoo')


#Loading Frank's Data, more than a year's worth of one transceiver
fullData<- na.omit(read.csv('flatReef.csv',sep=','))
fullData<- fullData[-(1:4),]
class(fullData)
fullData$timestamp<- as.POSIXct(fullData$DT, format = "%d-%b-%Y %H:%M:%S")

fullData<- fullData %>%
  na.omit()

fullData$HourlyDets[fullData$HourlyDets > 15] <- 6


#################################################################

# This creates a number to represent the datetime value in my dataframe.
dateNumber<- 1:nrow(fullData)

#Creates a simple model using the full timeseries.
model1<- lm(data=fullData,Noise~windSpd+Temp+crossShore)
summary(model1)





#Plots simple graph. Something is wrong with my model.
win.graph(width=10, height=6,pointsize=8)
main<- plot(fullData$Noise~dateNumber,type='o',ylab='High-Freq. Noise (mV)',xlab='Hours', ylim=(c(500, 800)),main=('High-Frequency Noise on a Coastal Reef'))
#abline(model1) # add the fitted least squares line from model1


# Starts to look at seasonality
#I am not sure why this error occurs; I am attempting
# to detrend my data by removing the seasonality component.
#month.= season(fullData)
#Can't get this working.


#Frank's workaround: using spline fits and lowpass/highpass filtering techniques
lowpass.spline<- smooth.spline(dateNumber,fullData$Noise,spar=0.75)
lowpass.loess<- loess(fullData$Noise~dateNumber, data=fullData,span=0.4)

#Plot the low frequencies: seasonal, longer
win.graph(width=10, height=6,pointsize=8)
main<- plot(fullData$Noise~dateNumber,type='n',ylab='y',ylim=(c(500, 800)),main=('Lowpass Filters: Seasonal Diffs.'))
lines(predict(lowpass.spline, dateNumber), col = "red", lwd = 2)
lines(predict(lowpass.loess, dateNumber), col = "blue", lwd = 10)

#

#Just the high-frequencies, much less than the lower seasonal changes
highpass<- fullData$Noise - predict(lowpass.loess,dateNumber)

fullData$highpass<- highpass

#Plot the higher frequencies: noise, daily, etc.
dev.new()
plot(fullData$Noise~fullData$DT,type='n',ylab='High-Freq. Noise (mV)', xlim=c(5,length(fullData$Noise)), xlab='Hours', ylim=(c(-250, 150)),main=('Highpass Filters: Wind, Daily Signals'))
highLine1 <- lines(dateNumber,highpass,lwd=2)

dev.new()




# Sample data
convFM<- as.POSIXct(fullData$timestamp, tz = "UTC")

#All data
x <- fullData$timestamp
y1 <- fullData$highpass
y2 <- fullData$windSpd
y3 <- fullData$HourlyDet
df <- data.frame(x, y1, y2, y3)

#End of February Example
x <- fullData$timestamp[2300:2600]
y1 <- fullData$highpass[2300:2600]
y2 <- fullData$windSpd[2300:2600]
y3 <- fullData$HourlyDets[2300:2600]
df <- data.frame(x, y1, y2, y3)


# July Example
x <- fullData$timestamp[5600:5750]
y1 <- fullData$highpass[5600:5750]
y2 <- fullData$windSpd[5600:5750]
y3 <- fullData$HourlyDets[5600:5750]
df <- data.frame(x, y1, y2, y3)


# Create separate plots
plot1 <- ggplot(df, aes(x, y1)) + geom_line() + ggtitle("High-Frequency Noise: Highpass Filter") + ylab("Filtered HF Noise (mV)") + xlab("")
plot2 <- ggplot(df, aes(x, y2)) + geom_line() + ggtitle("Windspeeds (m/s)") + ylab("Wind Magnitude (m/s)") + xlab("")
plot3 <- ggplot(df, aes(x, y3)) + geom_line() + ggtitle("Hourly Detections") + ylab("Detections") + xlab("Date")

#Good for subset
plot1 <- plot1 + scale_x_datetime(date_breaks = "72 hours", date_labels = "%Y-%m-%d %H:%M")
plot2 <- plot2 + scale_x_datetime(date_breaks = "72 hours", date_labels = "%Y-%m-%d %H:%M")
plot3 <-plot3 + scale_x_datetime(date_breaks = "72 hours", date_labels = "%Y-%m-%d %H:%M")

#Good for whole view
plot1 <- plot1 + scale_x_datetime(date_labels = "%Y-%m-%d")
plot2 <- plot2 + scale_x_datetime(date_labels = "%Y-%m-%d")
plot3 <-plot3 + scale_x_datetime(date_labels = "%Y-%m-%d")

# Arrange plots in rows
multiplot <- gridExtra::grid.arrange(plot1, plot2, plot3, nrow = 3)

# Display the multiplot
print(multiplot)


















modela<- lm(data=fullData,highpass~windSpd+Temp+crossShore)
summary(modela)

modelb<- lm(data=fullData,Temp~Season+windSpd)
summary(modelb)



##
#Frank, professor testing 4/29/24
library(tseries)
#Augmented Dickey-Fuller Test, testing if the time series is stationary
#Full dataset:  DF, -6.77, Lag Order = 21
adf.test(fullData$Noise)
# Highpass filtered data: DF, -12.60
adf.test(highpass)


#KPSS test, testing if the trend is stationary. 
#In the main dataset, KPSS ==24.5, Truncation lag = 12
kpss.test(fullData$Noise)
# in the highpass filtered noise data, KPSS = 0.042
kpss.test(highpass)

#Auto and cross-covariance and -correlation function
acf(highpass)



x <- 1:9
Y<- c(50,48,26,21,28,9,4,9,5)