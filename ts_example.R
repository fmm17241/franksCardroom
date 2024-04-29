install.packages('forecast')
install.packages('timetk')
install.packages('UKgrid')
install.packages('janitor')
install.packages('TSstudio')
install.packages('fable')

library(forecast)
data <- co2
nw_ts<-diff(data,differences = 2)
plot(nw_ts)
nw_ts2 <- diff(nw_ts,lag=12)
plot(nw_ts2)



library(tidyverse)
dates_df <- read_csv("https://raw.githubusercontent.com/PacktPublishing/Hands-On-Time-Series-Analysis-with-R/master/Chapter02/dates_formats.csv")
glimpse(dates_df)
library(lubridate)
dates_df %>% 
  mutate(US_format = mdy(US_format))
dates_df %>% 
  mutate(US_long_format = mdy(US_long_format))

library(timetk)
library(UKgrid)
library(janitor)

uk_data <- 
  UKgrid %>% 
  # lowercase all column names
  clean_names() %>% 
  select(timestamp, nd)
glimpse(uk_data)

uk_data %>% 
  group_by(year(timestamp), month(timestamp, label = TRUE)) %>% 
  summarize(nd = sum(nd))


uk_monthly_data <- 
  uk_data %>% 
  summarize_by_time(.date_var = timestamp,
                    .by = "month",
                    nd = sum(nd, na.rm = TRUE))

head(uk_monthly_data, 12)

uk_monthly_data <- 
  uk_monthly_data %>% 
  filter_by_time(.date_var = timestamp, 
                 .start_date = "2006",
                 .end_date = "2018")

head(uk_monthly_data)



## Visualization

ggplot(data = uk_monthly_data, aes(x = timestamp, y = nd)) +
  geom_line() +
  geom_smooth(se = FALSE) +
  labs(x = "Monthly Data", y = "Electricity Demand") +
  scale_x_datetime(date_breaks = "year", date_labels = "%b-%Y")

# interactiver version 
plot_time_series(uk_monthly_data, 
                 .date_var = timestamp, 
                 .value = nd,
                 .interactive = TRUE,
                 .x_lab = "Monthy Data",
                 .y_lab = "Electricity Demand")






## TS Pattern in the data 


library(TSstudio)
tk_tbl(USUnRate) %>% 
  filter_by_time(.start_date = "1990", .end_date = "2016") %>% 
  ggplot(aes(x = index, y = value)) +
  geom_line()


plot_stl_diagnostics(uk_monthly_data, .date_var = timestamp, .value = nd)


plot_seasonal_diagnostics(uk_monthly_data, .date_var = timestamp, .value = nd)

uk_monthly_data <- 
  uk_monthly_data %>% 
  mutate(time_trend = row_number())


uk_monthly_data <- 
  uk_monthly_data %>% 
  mutate(seasonal_trend = factor(month(timestamp, label = TRUE), ordered = FALSE))




glimpse(uk_monthly_data)




library(rsample)
library(broom)
uk_monthly_split <- initial_time_split(uk_monthly_data, prop = 150/156)

uk_training <- training(uk_monthly_split)
uk_testing <- testing(uk_monthly_split)


forecast_1 <- lm(nd ~ time_trend, data = uk_training)
broom::tidy(forecast_1)

library(broom)
augment(forecast_1, newdata = uk_training)

ggplot(data = uk_monthly_data, aes(x = timestamp, y = nd)) +
  # plot the raw data
  geom_line() +
  # add the forecast
  geom_line(data = augment(forecast_1, newdata = uk_training), 
            aes(x = timestamp, y = .fitted),
            color = "red") +
  labs(x = "Monthly Data", y = "Electricity Demand") +
  scale_x_datetime(date_breaks = "year", date_labels = "%b-%Y")




forecast_2 <- lm(nd ~ time_trend + seasonal_trend, data = uk_training)
tidy(forecast_2)



ggplot(data = uk_monthly_data, aes(x = timestamp, y = nd)) +
  # plot the raw data
  geom_line() +
  # add the first forecast (time trend)
  geom_line(data = augment(forecast_1, newdata = uk_training), 
            aes(x = timestamp, y = .fitted),
            color = "red") +
  # add the second forecast (time + seasonal trends)
  geom_line(data = augment(forecast_2, newdata = uk_training), 
            aes(x = timestamp, y = .fitted),
            color = "skyblue") +
  labs(x = "Monthly Data", y = "Electricity Demand") +
  scale_x_datetime(date_breaks = "year", date_labels = "%b-%Y")



forecast_3 <- lm(nd ~ time_trend + I(time_trend^2) + seasonal_trend, 
                 data = uk_training)
tidy(forecast_2)

ggplot(data = uk_monthly_data, aes(x = timestamp, y = nd)) +
  # plot the raw data
  geom_line() +
  # add the first forecast (time trend)
  geom_line(data = augment(forecast_1, newdata = uk_training), 
            aes(x = timestamp, y = .fitted),
            color = "red") +
  # add the second forecast (time + seasonal trends)
  geom_line(data = augment(forecast_2, newdata = uk_training), 
            aes(x = timestamp, y = .fitted),
            color = "skyblue") +
  # add the third forecast (time + seasonal trends + polynomial)
  geom_line(data = augment(forecast_3, newdata = uk_training), 
            aes(x = timestamp, y = .fitted),
            color = "darkgreen") +
  labs(x = "Monthly Data", y = "Electricity Demand") +
  scale_x_datetime(date_breaks = "year", date_labels = "%b-%Y")




ggplot(data = uk_monthly_data, aes(x = timestamp, y = nd)) +
  # plot the raw data
  geom_line() +
  # add the second forecast (time + seasonal trends)
  geom_line(data = augment(forecast_2, newdata = uk_training), 
            aes(x = timestamp, y = .fitted),
            color = "skyblue") +
  # add the test data
  geom_line(data = augment(forecast_2, newdata = uk_testing), 
            aes(x = timestamp, y = .fitted),
            color = "red", lty = 2) +
  labs(x = "Monthly Data", y = "Electricity Demand") +
  scale_x_datetime(date_breaks = "year", date_labels = "%b-%Y")




bind_rows(
  glance(forecast_1),
  glance(forecast_2),
  glance(forecast_3)
)



## fable package 

library(fable)
library(tsibble)

ts_uk_training <- 
  uk_training %>% 
  mutate(timestamp = yearmonth(timestamp)) %>% 
  as_tsibble(index = timestamp)

ts_uk_testing <- 
  uk_testing %>% 
  mutate(timestamp = yearmonth(timestamp)) %>% 
  as_tsibble(index = timestamp)

ts_uk_monthly <- 
  uk_monthly_data %>% 
  mutate(timestamp = yearmonth(timestamp)) %>% 
  as_tsibble(index = timestamp)

glimpse(ts_uk_training)



tslm_fit <- 
  ts_uk_training %>% 
  model(trend_fit = TSLM(nd ~ trend()),
        ts_fit = TSLM(nd ~ trend() + season()),
        ts_2_fit = TSLM(nd ~ trend() + season() + I(trend()^2)))



tidy(tslm_fit)






