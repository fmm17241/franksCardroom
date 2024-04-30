# Set working directory, and read in my datasets as .csv
setwd('C:/Users/fmm17241/OneDrive - University of Georgia/statisticalAnalysis/envStatsSpring2024')
setwd('C:/Users/fmac4/OneDrive - University of Georgia/statisticalAnalysis/envStatsSpring2024')

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
reefData<- na.omit(read.csv('flatReef.csv',sep=','))

class(reefData)

reefData$DT<- as.POSIXct(reefData$DT, format = "%d-%b-%Y %H:%M:%S")
timeseries<- ts(data=reefData$DT,frequency=24)
print(timeseries)


reefData<- reefData[, !names(reefData) %in% c("alongShore","waveHeight","surfaceTemp","Pings","DT")]

reefData<- cbind(timeseries,reefData)

print(reefData)
class(reefData)

noise<- reefData$Noise

nw_ts<-diff(reefData[,1:6],differences = 2)
plot(nw_ts)

