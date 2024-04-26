# Set working directory, and read in my datasets as .csv
setwd('C:/Users/fmm17241/OneDrive - University of Georgia/statisticalAnalysis/envStatsSpring2024')
install.packages("ggplot2")
install.packages("mgcv")
install.packages("itsadug")
install.packages("AER")
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

#Frank's Data
reefData<- read.csv('flatReef.csv',sep=',')

#Show clear difference in noise levels. Instrument manufacturer says anything
#above 650 is a challenging environment; flat is much louder than sunken.
summary(reefData$Noise)

model1<- lm(reefData~Noise(reefData))

ggplot(test)