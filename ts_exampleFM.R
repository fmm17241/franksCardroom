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
fullData<- na.omit(read.csv('flatReef.csv',sep=','))
fullData<- fullData[-(1:4),]
class(fullData)
fullData$timestamp<- as.POSIXct(fullData$DT, format = "%d-%b-%Y %H:%M:%S")

fullData<- fullData %>%
  na.omit()

fullData$HourlyDets[fullData$HourlyDets > 15] <- 6


####################################################################################
#Using it as a dataframe

library(lubridate)
library(timetk)
library(janitor)

fullData %>% 
  group_by(year(timestamp), month(timestamp, label = TRUE), day(timestamp)) %>% 
  summarize(Noise = mean(Noise))


monthly_data <- 
  fullData %>% 
  summarize_by_time(.date_var = timestamp,
                    .by = "month",
                    Noise = mean(Noise, na.rm = TRUE))

daily_data <- 
  fullData %>% 
  summarize_by_time(.date_var = timestamp,
                    .by = "day",
                    Noise = mean(Noise), na.rm = TRUE))

head(daily_data, 12)



ggplot(data = daily_data, aes(x = timestamp, y = Noise)) +
  geom_line() +
  geom_smooth(se = FALSE) +
  labs(x = "Daily Data", y = "HF Noise") +
  scale_x_datetime(date_breaks = "month", date_labels = "%b")

#################################################################################
#using it as a timeseries

library(TSstudio)
tk_tbl(fullData) %>% 
  filter_by_time(.start_date = "2019", .end_date = "2021") %>% 
  ggplot(aes(x = index, y = Noise)) +
  geom_line()


plot_stl_diagnostics(monthly_data, .date_var = timestamp, .value = Noise)


plot_seasonal_diagnostics(monthly_data, .date_var = timestamp, .value = Noise)






timeseries<- ts(data=reefData$Noise,frequency=24)
print(timeseries)


reefData<- reefData[, !names(reefData) %in% c("alongShore","waveHeight","surfaceTemp","Pings","DT","Season","Tilt")]

reefData<- cbind(timeseries,reefData)
class(reefData)

reefNoise<- reefNoise[,3]

class(reefNoise)

noise<- reefData$Noise


# Differences: found and plotted.
nw_ts<-diff(reefNoise,differences = 2)
plot(nw_ts)


nw_ts2 <- diff(nw_ts,lag=12)
plot(nw_ts2)

