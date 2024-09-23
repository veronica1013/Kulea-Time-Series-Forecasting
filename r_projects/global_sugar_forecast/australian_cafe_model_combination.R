library(forecast)
library(ggplot2)
library(lubridate)
library(readxl)
library(tseries)
library(fpp2)

plot(auscafe)

train <- window(auscafe, end=c(2012,9))
h <- length(auscafe) - length(train)
ETS <- forecast(ets(train), h=h)
ARIMA <- forecast(auto.arima(train, lambda=0, biasadj=TRUE),
  h=h)
STL <- stlf(train, lambda=0, h=h, biasadj=TRUE)
NNAR <- forecast(nnetar(train), h=h)
TBATS <- forecast(tbats(train, biasadj=TRUE), h=h)
Combination <- (ETS[["mean"]] + ARIMA[["mean"]] +
  STL[["mean"]] + NNAR[["mean"]] + TBATS[["mean"]])/5

# autoplot(auscafe) +
#   autolayer(ETS, series="ETS", PI=FALSE) +
#   autolayer(ARIMA, series="ARIMA", PI=FALSE) +
#   autolayer(STL, series="STL", PI=FALSE) +
#   autolayer(NNAR, series="NNAR", PI=FALSE) +
#   autolayer(TBATS, series="TBATS", PI=FALSE) +
#   autolayer(Combination, series="Combination") +
#   xlab("Year") + ylab("$ billion") +
#   ggtitle("Australian monthly expenditure on eating out")

# Plot the original time series
plot(close_prices, type = "l", xlab = "Year", ylab = "Close Price", main = "SBY00 2024 Forecast")

# Add forecasted series to the plot
lines(ETS_forecast$mean, col = "blue", lty = 2, lwd = 2)
lines(ARIMA_forecast$mean, col = "red", lty = 2, lwd = 2)
lines(NNAR_forecast$mean, col = "green", lty = 2, lwd = 2)
lines(TBATS_forecast$mean, col = "purple", lty = 2, lwd = 2)
lines(Combination, col = "orange", lty = 2, lwd = 2)

# Add legend
legend("topright", legend = c("ETS", "ARIMA", "NNAR", "TBATS", "Combination"),
       col = c("blue", "red", "green", "purple", "orange"), lty = 2, lwd = 2)


# data <- read_excel("D:\\kulea_projects\\r_project\\global_sugar\\global_brown_sugar_prices.xlsx",
#                    sheet = "sby00_daily_historical_data")

# # data <- read_excel("D:\\kulea_projects\\r_project\\work\\algeria.xlsx",
# #                    sheet = "Algeria_Copy", skip = 1)
# print(head(data))
# print(tail(data))

# # Having the data frame named 'data' with 'Month' and 'Price' columns rename them to 'Date' and 'Close' columns
# # # Rename columns to 'Date' and 'Close'
# colnames(data) <- c('Date', 'Close')
# # Convert 'Date' column to Date type
# data$Date <- as.Date(data$Date)


# # Convert the data frame to a time series object
# # close_prices <- ts(data$Close, start = min(data$Date), frequency = 365)
# close_prices <- ts(data$Close, frequency = 1)

# # Set the end date to December 31, 2018
# # end_date <- as.Date("2018-11-16")

# # Calculate the start date for the training data (5 years before the end date)
# # start_date <- end_date - months(60)

# # Create the training data window
# # train <- window(close_prices, start = start_date, end = end_date)
# # Create the training data window
# train <- window(close_prices, end = c(2018, 11))
# # train <- window(close_prices, start = min(time(close_prices)), end = end_date)

# # Print the end date of the training data for debugging
# # print(end(time(train)))

# # Calculate the forecast horizon
# h <- length(close_prices) - length(train)
# print(h)
# print(length(close_prices))
# print(length(train))

# # # Perform forecasts using different methods
# # if (h > 0) {
# #   ETS_forecast <- forecast(ets(train), h = h)
# #   ARIMA_forecast <- forecast(auto.arima(train, lambda = 0, biasadj = TRUE), h = h)
# #   STL_forecast <- stlf(train, lambda = 0, h = h, biasadj = TRUE)
# #   NNAR_forecast <- forecast(nnetar(train), h = h)
# #   TBATS_forecast <- forecast(tbats(train, biasadj = TRUE), h = h)

# #   # Calculate the combination forecast (simple average of forecasts)
# #   Combination <- (ETS_forecast$mean + ARIMA_forecast$mean +
# #                   STL_forecast$mean + NNAR_forecast$mean + TBATS_forecast$mean) / 5
# # } else {
# #   print("Forecast horizon exceeds available data.")
# # }

# # Perform forecasts using different methods
# ETS_forecast <- forecast(ets(train), h = h)
# ARIMA_forecast <- forecast(auto.arima(train, lambda = 1, biasadj = TRUE), h = h)
# # STL_forecast <- stlf(train, lambda = 0, h = h, biasadj = TRUE)
# NNAR_forecast <- forecast(nnetar(train), h = h)
# TBATS_forecast <- forecast(tbats(train, biasadj = TRUE), h = h)

# # Calculate the combination forecast (simple average of forecasts)
# Combination <- (ETS_forecast$mean + ARIMA_forecast$mean +
#                 NNAR_forecast$mean + TBATS_forecast$mean) / 4

# # # Calculate the combination forecast (simple average of forecasts)
# # Combination <- (ETS_forecast$mean + ARIMA_forecast$mean +
# #                 STL_forecast$mean + NNAR_forecast$mean + TBATS_forecast$mean) / 5

# # # # Print or use the forecasts as needed

# autoplot(close_prices) +
# autolayer(ETS_forecast, series = "ETS", PI = FALSE) +
# autolayer(ARIMA_forecast, series = "ARIMA", PI = FALSE) +
#   # autolayer(STL, series="STL", PI=FALSE) +
# autolayer(NNAR_forecast, series = "NNAR", PI = FALSE) +
# autolayer(TBATS_forecast, series = "TBATS", PI = FALSE) +
# autolayer(Combination, series = "Combination") +
# xlab("Year") + ylab("Close Price") +
# ggtitle("SBY00 2024 Forecast")

# # plot(TBATS_forecast)
# # Plot the original time series
# # plot(close_prices, type = "l", xlab = "Year", ylab = "Close Price", main = "SBY00 2024 Forecast")

# # # Add forecasted series to the plot
# # lines(ETS_forecast$mean, col = "blue", lty = 2, lwd = 2)
# # lines(ARIMA_forecast$mean, col = "red", lty = 2, lwd = 2)
# # lines(NNAR_forecast$mean, col = "green", lty = 2, lwd = 2)
# # lines(TBATS_forecast$mean, col = "purple", lty = 2, lwd = 2)
# # lines(Combination, col = "orange", lty = 2, lwd = 2)

# # # Add legend
# # legend("topright", legend = c("ETS", "ARIMA", "NNAR", "TBATS", "Combination"),
# #        col = c("blue", "red", "green", "purple", "orange"), lty = 2, lwd = 2)


























# # num_col <- ncol(data)
# # col_names <- colnames(data)
# # print(col_names)
# # sel_data <- data[, c("Month", "Price"
# # )]
# # print(head(sel_data))
# # print(class(sel_data))
# # end_date <- as.Date("2023-12-31 00:00:00")
# # sel_data_2 <- sel_data[sel_data$Month <= end_date, ]
# # # print(tail(sel_data_2))
# # ts_data <- ts(sel_data_2$`Price`,
# #               start = c(year(sel_data_2$Month[1]),
# #                         month(sel_data_2$Month[1])),
# #               frequency = 12)
# # # print(ts_data)
# # # print(sum(is.na(ts_data)))
# # ts_data_summary <- summary(ts_data)
# # # print(ts_data_summary)
# # # print(cycle(ts_data))
# # boxplot(ts_data ~ cycle(ts_data))
# # plot(ts_data)
# # decomposed_data <- decompose(ts_data, "multiplicative")
# # plot(decomposed_data)
# # # plot(decomposed_data$trend)
# # # plot(decomposed_data$seasonal)
# # # plot(decomposed_data$random)
# # # plot(sel_data_2)
# # # plot(ts_data)
# # # abline(reg = lm(ts_data ~ time(ts_data)))
# # # cycle(ts_data)
# # boxplot(ts_data ~ cycle(ts_data))
# # arima_model <- Arima(ts_data,
# #                      order = c(1, 1, 0),
# #                      seasonal = list(order = c(1, 0, 0), period = 12))
# # # # arima_model <- auto.arima(ts_data)
# # # arima_model = auto.arima(ts_data, ic = "aic", trace = TRUE)
# # # adf_test_results <- adf.test(arima_model$residuals)
# # # print(adf_test_results)
# # # print(arima_model)
# # plot(arima_model$residuals)
# # print(mean(arima_model$residuals))
# # acf(arima_model$residuals, main = "ACF Residual")
# # pacf(arima_model$residuals, main = "PACF Residual")
# # forecast_global_sugar <- forecast(arima_model, level = c(95), h = 12 * 48)
# # plot(forecast_global_sugar)
# # print(forecast_global_sugar)
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
# # # # print(forecast_morocco_production)

# # # file_path <- "forecast_algeria_imports_2023_2026.csv"

# # # # Save the forecast to a CSV file
# # # write.csv(forecast_algeria_imports, file = file_path, row.names = TRUE)