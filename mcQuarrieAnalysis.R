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
win.graph(width=10, height=6,pointsize=8)
main<- plot(reefData$Noise~dateNumber,type='o',ylab='y',ylim=(c(-100, 800)),main=('High-Frequency Noise on a Coastal Reef'))
#abline(model1) # add the fitted least squares line from model1


# Starts to look at seasonality
#I am not sure why this error occurs; I am attempting
# to detrend my data by removing the seasonality component.
#month.= season(reefData)
#Can't get this working.


#Frank's workaround: using spline fits and lowpass/highpass filtering techniques
lowpass.spline<- smooth.spline(dateNumber,reefData$Noise,spar=0.6)
lowpass.loess<- loess(reefData$Noise~dateNumber, data=reefData,span=0.3)

#Plot the low frequencies: seasonal, longer
win.graph(width=10, height=6,pointsize=8)
main<- plot(reefData$Noise~dateNumber,type='n',ylab='y',ylim=(c(500, 800)),main=('Lowpass Filters: Seasonal Diffs.'))
lines(predict(lowpass.spline, dateNumber), col = "red", lwd = 2)
lines(predict(lowpass.loess, dateNumber), col = "blue", lwd = 2)


#Just the high-frequencies, much less than the lower seasonal changes
highpass<- reefData$Noise - predict(lowpass.loess,dateNumber)

#Plot the higher frequencies: noise, daily, etc.
win.graph(width=10, height=6,pointsize=8)
plot(reefData$Noise~dateNumber,type='n',ylab='y',ylim=(c(-250, 150)),main=('Highpass Filters: Wind, Daily Signals'))
highLine1 <- lines(dateNumber,highpass,lwd=2)



