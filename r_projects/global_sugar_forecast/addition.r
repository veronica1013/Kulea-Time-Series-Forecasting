library(forecast)
library(ggplot2)
library(lubridate)
library(readxl)
library(xts)
library(tseries)

# data <- read_excel("D:\\kulea_projects\\r_project\\global_sugar\\global_brown_sugar_prices.xlsx",
#                    sheet = "sby00_daily_historical_data")

data <- read_excel("D:\\kulea_projects\\r_project\\global_sugar\\global_brown_sugar11_data_feb_09_2024.xlsx",
                   sheet = "sby00_daily_historical_data")

print(head(data))

num_col <- ncol(data)
col_names <- colnames(data)
print(col_names)
# sel_data <- data[, c("Month", "Price"
# )]
# print(head(sel_data))
# print(class(sel_data))
print(class(data$Date))

# # Convert 'Month' column to Date class
# sel_data$Month <- as.Date(sel_data$Month)

# end_date <- as.Date("2023-11-17 00:00:00")
end_date <- as.Date("2023-11-17 00:00:00")
sel_data_2 <- data[data$Date <= end_date, ]
# print(head(sel_data_2))
# print(tail(sel_data_2))
plot(data)

# # Create a time series object
# ts_data <- xts(sel_data_2$Price, order.by = sel_data_2$Month)
# # ts_data <- ts(sel_data_2$Price,)

# # Create a time series object
# ts_data <- xts(data$Price, order.by = data$Date)
# ts_data <- ts(data$Price,)

# ts_data <- ts(data$Price,
#               start = c(year(data$Date[1]),
#                         month(data$Date[1])),
#                         # day(sel_data_2$Month[1])),
#               frequency = 365)
# # print(ts_data)
# plot(ts_data)


# # Convert strings to Date objects
# period1 <- as.Date('2014-06-02')
# period2 <- as.Date('2019-03-17')

# Convert strings to Date objects
period1 <- as.Date('2019-06-02')
period2 <- as.Date('2019-06-03')

# Split data into training, validation, and testing sets
training <- data[data$Date <= period1, ]
# validation <- data[data$Date > period1 & data$Date <= period2, ]
testing <- data[data$Date > period2, ]

# Print shapes of the datasets
cat('Training Data Shape - ', dim(training), '\n')
cat('Validation Data Shape - ', dim(validation), '\n')
cat('Testing Data Shape - ', dim(testing), '\n')

# Extract training data for period 1
training_data_p1 <- data[data$Date <= period2, ]
train_data <- training_data_p1$Price

# Extract test data
test_data <- testing$Price

# Extract Validation data
validation_data <- validation$Price

# Print shapes of the datasets
cat('Training Data Shape - ', length(train_data), '\n')
cat('Testing Data Shape - ', length(test_data), '\n')


# Convert train_data and test_data to time series objects
train_ts <- ts(train_data, frequency = 1)
test_ts <- ts(test_data, frequency = 1)

# Create empty vector to store predictions
arima_predictions <- vector("numeric", length(test_data))

# Perform rolling ARIMA forecast
history <- train_ts
for (i in 1:length(test_data)) {
  # Fit ARIMA model
  arima_model <- Arima(history, order=c(5,1,0))
  
  # Forecast next value
  forecast_value <- forecast(arima_model, h=1)$mean
  
  # Store forecasted value
  arima_predictions[i] <- forecast_value
  
  # Update history with observed value
  history <- c(history, test_ts[i])
  
  # Print progress every 100 iterations
  if (i %% 100 == 0) {
    cat('Predicted=', forecast_value, ', Expected=', test_ts[i], '\n')
  }
}

# Calculate RMSE
arima_rmse <- sqrt(mean((test_data - arima_predictions)^2))
cat('Test RMSE: ', sprintf('%.3f', arima_rmse), '\n')

# Calculate R2
arima_r2 <- 1 - sum((test_data - arima_predictions)^2) / sum((test_data - mean(test_data))^2)
cat('Test R2: ', sprintf('%.3f', arima_r2), '\n')

# Calculate MSE
arima_error <- mean((test_data - arima_predictions)^2)
cat('Test MSE: ', sprintf('%.3f', arima_error), '\n')


# # # Create a date range for the forecasted period (30 days per month for 12 months)
# # forecast_dates <- seq(as.Date("2020-12-01"), as.Date("2024-04-17"), by = "day")
forecast_dates <- seq(end_date, end_date + 1179, by = "day")  # Forecast for 1 year (365 days) from the end date

# # Combine forecasted dates with forecasted values
forecast_df <- data.frame(Date = forecast_dates, Forecast = arima_predictions) # The forecast dates and arima predictions length should be the same.

# forecast_global_sugar_11_2024 <- forecast(arima_model, level = c(95), h = 24 * 12)
# plot(forecast_global_sugar_11_2024)
# # Forecast 1 year from the end date
# forecast_dates <- seq(end_date + 1, end_date + 365, by = "day")  # Forecast for 1 year (365 days) from the end date

# forecast_values <- forecast(arima_model, h = 365)  # Forecast for 365 days (1 year)

# Print the forecast DataFrame
print(forecast_df)
