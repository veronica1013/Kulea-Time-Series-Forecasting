data_url = "D:\\kulea_projects\\r_project\\global_sugar\\global_brown_sugar_prices.xlsx"

library(forecast)
library(ggplot2)
library(lubridate)
library(readxl)
library(tseries)
library(dplyr)
data <- read_excel(data_url,
                   sheet = "sby00_daily_historical_data")
head(data)
num_col <- ncol(data)
col_names <- colnames(data)
print(col_names)
sel_data <- data[, c("Month", "Price"
)]
print(class(sel_data))
print(head(sel_data))
print(tail(sel_data))
end_date <- as.Date("2023-11-17 00:00:00")
# # sel_data_2 <- sel_data[sel_data$Month <= end_date, ]
# # print(tail(sel_data_2))
# # Convert 'Month' column to Date class
sel_data$Month <- as.Date(sel_data$Month)

ts_data <- ts(sel_data$`Price`,)
            #   start = c(year(sel_data$Month[1]),
            #             month(sel_data$Month[1]),
            #             # day(sel_data$Month[1]),
            #   frequency = 12))
# print(tail(ts_data))
# # # ts_data_2 <- ts_data[ts_data$Month <= end_date, ]
# # # print(ts_data_2)
# # # print(sum(is.na(ts_data)))
# # ts_data_summary <- summary(ts_data)
# # print(ts_data_summary)
# # # # print(cycle(ts_data))
boxplot(ts_data ~ cycle(ts_data))
# plot(ts_data)

# # Plotting with true dates on the x-axis
# plot(time(ts_data), ts_data, type = "l",
#      xlab = "Date", ylab = "Price",
#      main = "Time Series Plot of Brown Sugar Prices")

# decomposed_data <- decompose(ts_data, "multiplicative")
# plot(decomposed_data)
# # # # plot(decomposed_data$trend)
# # # # plot(decomposed_data$seasonal)
# # # # plot(decomposed_data$random)
# # # # plot(sel_data_2)
# # # # plot(ts_data)
# # abline(reg = lm(ts_data_2 ~ time(ts_data_2)))
# # abline(reg = lm(ts_data ~ time(ts_data)))
# # cycle(ts_data_2)
# # # boxplot(ts_data_2 ~ cycle(ts_data_2))

# arima_model <- auto.arima(ts_data, ic = "aic", trace = TRUE)

# # auto.arima(ts_data, ic = "aic", trace = TRUE)
arima_model <- Arima(ts_data,
                     order = c(0, 1, 0),
                     seasonal = list(order = c(1, 0, 2), period = 36))
print(arima_model)
# # auto.arima(ts_data_2, ic = "aic", trace = TRUE)
# adf_test_results <- adf.test(arima_model$residuals)
# print(adf_test_results)

# plot(arima_model$residuals)
# print(mean(arima_model$residuals))
# acf(arima_model$residuals, main = "ACF Residual")
# pacf(arima_model$residuals, main = "PACF Residual")
# forecast_brown_sugar_11 <- forecast(arima_model, level = c(90), h = 12 * 2)
# plot(forecast_brown_sugar_11)
# print(forecast_brown_sugar_11)

# Determine the end date of the original data
end_date <- tail(sel_data$Month, 1)
print(end_date)
# # Generate dates for the forecast
forecast_dates <- seq(end_date + 1, by = "day", length.out = 2 * 30)  # Adjust the length.out as needed
print(forecast_dates)
# # Forecast daily prices
forecast_brown_sugar_11 <- forecast(arima_model, level = c(90), h = length(forecast_dates), xreg = forecast_dates)
print(forecast_brown_sugar_11)
plot(forecast_brown_sugar_11)
# # Plot forecast with original data
# plot(forecast_brown_sugar_11, main = "Brown Sugar Prices with Daily Forecast", xlab = "Date", ylab = "Price")
# lines(sel_data$Month, sel_data$Price, col = "black")
# legend("topright", legend = c("Observed", "Forecast"), col = c("black", "red"), lty = c(1, 1))


# # Plot forecast with original data
# plot(sel_data$Month, sel_data$Price, type = "l", xlab = "Date", ylab = "Price", main = "Brown Sugar Prices with Forecast")
# plot(forecast_brown_sugar_11, main = "Brown Sugar Prices with Forecast", xlab = "Date", ylab = "Price")
# lines(forecast_brown_sugar_11$mean, col = "red")
# lines(forecast_brown_sugar_11$lower[, "90%"], col = "blue", lty = 2)
# lines(forecast_brown_sugar_11$upper[, "90%"], col = "blue", lty = 2)
# legend("topright", legend = c("Observed", "Forecast", "90% Prediction Interval"),
#        col = c("black", "red", "blue"), lty = c(1, 1, 2))

# # Plot forecast with original data
# plot(forecast_brown_sugar_11, main = "Brown Sugar Prices with Forecast", xlab = "Date", ylab = "Price")
# lines(sel_data$Month, sel_data$Price, col = "black")
# legend("topright", legend = c("Observed", "Forecast"), col = c("black", "red"), lty = c(1, 1))

# Print forecast details
# print(forecast_brown_sugar_11)


# # # # lag_4_valid <- Box.test(arima_model$resid, lag = 4, type = "Ljung-Box")
# # # # print(lag_4_valid)
# # # # lag_10_valid <- Box.test(arima_model$resid, lag = 10, type = "Ljung-Box")
# # # # print(lag_10_valid)
# # # # lag_15_valid <- Box.test(arima_model$resid, lag = 15, type = "Ljung-Box")
# # # # print(lag_15_valid)
# # # # lag_1_valid <- Box.test(arima_model$resid, lag = 1, type = "Ljung-Box")
# # # # print(lag_1_valid)
# # # # lag_3_valid <- Box.test(arima_model$resid, lag = 3, type = "Ljung-Box")
# # # # print(lag_3_valid)

# file_path <- "forecast_brown_sugar_11_2023_2024.csv"

# # Save the forecast to a CSV file
# write.csv(forecast_brown_sugar_11, file = file_path, row.names = TRUE)