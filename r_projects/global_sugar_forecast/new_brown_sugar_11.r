library(forecast)
library(ggplot2)
library(lubridate)
library(readxl)
library(tseries)
data <- read_excel("D:\\kulea_projects\\r_project\\global_sugar\\global_brown_sugar_prices.xlsx",
                   sheet = "sby00_daily_historical_data")
head(data)
num_col <- ncol(data)
col_names <- colnames(data)
print(col_names)
sel_data <- data[, c("Month", "Price"
)]
print(head(sel_data))
print(class(sel_data))
end_date <- as.Date("2022-12-30 00:00:00")
sel_data_2 <- sel_data[sel_data$Month <= end_date, ]
print(tail(sel_data_2))
ts_data <- ts(sel_data_2$`Price`,
              start = c(year(sel_data_2$Month[1]),
                        month(sel_data_2$Month[1])),
                        # day(sel_data_2$Month[1])),
              frequency = 12)
# print(ts_data)
# # print(sum(is.na(ts_data)))
ts_data_summary <- summary(ts_data)
print(ts_data_summary)
# print(cycle(ts_data))
boxplot(ts_data ~ cycle(ts_data))
plot(ts_data)
decomposed_data <- decompose(ts_data, "multiplicative")
plot(decomposed_data)
# plot(decomposed_data$trend)
# plot(decomposed_data$seasonal)
# plot(decomposed_data$random)
# plot(sel_data_2)
# plot(ts_data)
# abline(reg = lm(ts_data ~ time(ts_data)))
# cycle(ts_data)
# boxplot(ts_data ~ cycle(ts_data))
arima_model <- auto.arima(ts_data, ic = "aic", trace = TRUE)
print(arima_model)
# arima_model <- Arima(ts_data,
#                      order = c(0, 1, 0), #
#                      seasonal = list(order = c(0, 0, 1), period = 12)) #2, 1,1

# # adf_test_results <- adf.test(arima_model$residuals)
# # print(adf_test_results)
# print(arima_model)
# plot(arima_model$residuals)
# print(mean(arima_model$residuals))
# print(accuracy(arima_model))
# acf(arima_model$residuals, main = "ACF Residual")
# # pacf(arima_model$residuals, main = "PACF Residual")
# forecast_brown_sugar_prices_new_2024 <- forecast(arima_model, level = c(95), h = 5 * 12)
# plot(forecast_brown_sugar_prices_new_2024)
# print(forecast_brown_sugar_prices_new_2024)
# # lag_4_valid <- Box.test(arima_model$resid, lag = 4, type = "Ljung-Box")
# # print(lag_4_valid)
# # lag_10_valid <- Box.test(arima_model$resid, lag = 10, type = "Ljung-Box")
# # print(lag_10_valid)
# # lag_15_valid <- Box.test(arima_model$resid, lag = 15, type = "Ljung-Box")
# # print(lag_15_valid)
# # lag_1_valid <- Box.test(arima_model$resid, lag = 1, type = "Ljung-Box")
# # print(lag_1_valid)
# # lag_3_valid <- Box.test(arima_model$resid, lag = 3, type = "Ljung-Box")
# # print(lag_3_valid)

# file_path <- "forecast_brown_sugar_11.csv"

# # Save the forecast to a CSV file
# write.csv(forecast_brown_sugar_prices_new_2024, file = file_path, row.names = TRUE)