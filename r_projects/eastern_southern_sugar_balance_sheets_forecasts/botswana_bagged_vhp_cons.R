library(forecast)
library(ggplot2)
library(lubridate)
library(readxl)
library(tseries)
data <- read_excel("D:\\kulea_projects\\r_project\\east_south_sugar\\Botswana.xlsx",
                   sheet = "Botswana_Copy", skip = 1)
head(data)
num_col <- ncol(data)
col_names <- colnames(data)
print(col_names)
sel_data <- data[, c("Month", "Bagged VHP Cons"
)]
print(head(sel_data))
print(class(sel_data))
end_date <- as.Date("2025-12-01 00:00:00")
sel_data_2 <- sel_data[sel_data$Month <= end_date, ]
print(tail(sel_data_2))
ts_data <- ts(sel_data_2$`Bagged VHP Cons`,
              start = c(year(sel_data_2$Month[1]),
                        month(sel_data_2$Month[1])),
              frequency = 12)
print(ts_data)
print(sum(is.na(ts_data)))
ts_data_summary <- summary(ts_data)
print(ts_data_summary)
print(cycle(ts_data))
boxplot(ts_data ~ cycle(ts_data))
plot(ts_data)
decomposed_data <- decompose(ts_data, "multiplicative")
plot(decomposed_data)
plot(decomposed_data$trend)
plot(decomposed_data$seasonal)
plot(decomposed_data$random)
plot(sel_data_2)
plot(ts_data)
abline(reg = lm(ts_data ~ time(ts_data)))
cycle(ts_data)
boxplot(ts_data ~ cycle(ts_data))
# arima_model <- Arima(ts_data,
#                      order = c(0, 1, 1),
#                      seasonal = list(order = c(1, 0, 1), period = 48))

arima_model <- Arima(ts_data,
                     order = c(0, 1, 0),
                     seasonal = list(order = c(2, 0, 0), period = 24))

# arima_model <- auto.arima(ts_data)
# auto.arima(ts_data, ic = "aic", trace = TRUE)
# adf_test_results <- adf.test(arima_model$residuals)
# print(adf_test_results)
print(arima_model)
plot(arima_model$residuals)
print(mean(arima_model$residuals))
acf(arima_model$residuals, main = "ACF Residual")
pacf(arima_model$residuals, main = "PACF Residual")
forecast_botswana_consumption <- forecast(arima_model, level = c(95), h = 2 * 12)
plot(forecast_botswana_consumption)
print(forecast_botswana_consumption)
# lag_4_valid <- Box.test(arima_model$resid, lag = 4, type = "Ljung-Box")
# print(lag_4_valid)
# lag_10_valid <- Box.test(arima_model$resid, lag = 10, type = "Ljung-Box")
# print(lag_10_valid)
# lag_15_valid <- Box.test(arima_model$resid, lag = 15, type = "Ljung-Box")
# print(lag_15_valid)
# lag_1_valid <- Box.test(arima_model$resid, lag = 1, type = "Ljung-Box")
# print(lag_1_valid)
# lag_3_valid <- Box.test(arima_model$resid, lag = 3, type = "Ljung-Box")
# print(lag_3_valid)

file_path <- "forecast_botswana_bagged_vhp_consumption_2023_2026.csv"

# Save the forecast to a CSV file
write.csv(forecast_botswana_consumption, file = file_path, row.names = TRUE)