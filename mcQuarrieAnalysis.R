# Set working directory, and read in my datasets as .csv
setwd('C:/Users/fmm17241/OneDrive - University of Georgia/statisticalAnalysis/envStatsSpring2024')

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



#Loading Frank's Data, more than a year's worth of one transceiver
reefData<- na.omit(read.csv('flatReef.csv',sep=','))

#Creates variables from the dataset
Noise<- reefData$Noise
Temperature<-  reefData$Temp
summary(reefData$Noise)


# This creates a number to represent the datetime value in my dataframe.
dateNumber<- 1:nrow(reefData)

#Creates a simple model using the full timeseries.
model1<- lm(data=reefData,dateNumber~Noise)
summary(model1)


#Plots simple graph. Something is wrong with my model.
win.graph(width=4.875, height=2.5,pointsize=8)
plot(reefData$Noise~dateNumber,type='o',ylab='y',ylim=(c(-100, 800)))
abline(model1) # add the fitted least squares line from model1


# Starts to look at seasonality
#I am not sure why this error occurs; I am attempting
# to detrend my data by removing the seasonality component.
month.= season(reefData)

#Frank's workaround: using spline fits and lowpass/highpass filtering techniques
lowpass.spline<- smooth.spline(dateNumber,reefData$Noise,spar=0.6)
lowpass.loess<- loess(reefData$Noise~dateNumber, data=reefData,span=0.3)

lines(predict(lowpass.spline, dateNumber), col = "red", lwd = 2)
lines(predict(lowpass.loess, dateNumber), col = "blue", lwd = 2)

highpass<- reefData$Noise - predict(lowpass.loess,dateNumber)
lines(dateNumber,highpass,lwd=2)





dev.new()
grid.arrange(noiseCat1,noiseCat2,noiseCat3,noiseCat4,noiseCat5,noiseCat6, ncol=2)
windows.options(width=10, height=10)