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

ts_data <- ts(data$Price,
              start = c(year(data$Date[1]),
                        month(data$Date[1])),
                        # day(sel_data_2$Month[1])),
              frequency = 365)
# print(ts_data)
plot(ts_data)

# # Plotting with true dates on the x-axis
# plot(time(ts_data), ts_data, type = "l",
#      xlab = "Date", ylab = "Price",
#      main = "Time Series Plot of Brown Sugar Prices",)
#     #  axis = seq(start(time(ts_data)), end(time(ts_data)), by = "3 years"))
#     #  axes = FALSE)  # Disable default axis

# # Add custom axis with 3-year intervals
# # axis(1, at = seq(start(time(ts_data)), end(time(ts_data)), by = "1 years"), labels = TRUE)
# # # # print(sum(is.na(ts_data)))


ts_data_summary <- summary(ts_data)
print(ts_data_summary)
# print(cycle(ts_data))
# # boxplot(ts_data ~ cycle(ts_data))
boxplot(ts_data ~ cycle(ts_data))
# # plot(ts_data)
decomposed_data <- decompose(ts_data, "multiplicative")
plot(decomposed_data)


# # # plot(decomposed_data$trend)
# # # plot(decomposed_data$seasonal)
# # # plot(decomposed_data$random)
# # # plot(sel_data_2)
# # # plot(ts_data)
# abline(reg = lm(ts_data ~ time(ts_data)))
# print(cycle(ts_data))
boxplot(ts_data ~ cycle(ts_data))
arima_model <- Arima(ts_data,
                     order = c(5, 1, 0),
                     seasonal = list(order = c(0, 0, 0), period = 36))
# arima_model <- auto.arima(ts_data,  ic = "aic", trace = TRUE)
print(arima_model)
# # # arima_model_2 <- auto.arima(ts_data, ic = "aic", trace = TRUE)
# # # print(arima_model_2)
adf_test_results <- adf.test(arima_model$residuals)
print(adf_test_results)
plot(arima_model$residuals)
# acf(arima_model$residuals, main = "ACF Residual")
# pacf(arima_model$residuals, main = "PACF Residual")
forecast_global_sugar_11_2024 <- forecast(arima_model, level = c(95), h = 24 * 12)
plot(forecast_global_sugar_11_2024)
# print(mean(arima_model$residuals))
# # lag_5_valid <- Box.test(arima_model$resid, lag = 5, type = "Ljung-Box")
# # print(lag_5_valid)
# # lag_10_valid <- Box.test(arima_model$resid, lag = 10, type = "Ljung-Box")
# # print(lag_10_valid)
# # lag_15_valid <- Box.test(arima_model$resid, lag = 15, type = "Ljung-Box")
# # print(lag_15_valid)
# # lag_1_valid <- Box.test(arima_model$resid, lag = 1, type = "Ljung-Box")
# # print(lag_1_valid)
# # lag_3_valid <- Box.test(arima_model$resid, lag = 3, type = "Ljung-Box")
# # print(lag_3_valid)
# # print(forecast_cameroon_production)
# # print(arima_model)

# # file_path <- "forecast_cameroon_production_2023_2026.csv"

# # # Save the forecast to a CSV file
# # write.csv(forecast_cameroon_production, file = file_path, row.names = TRUE)


