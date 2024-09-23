library(forecast)
library(ggplot2)
library(lubridate)
library(readxl)
library(tseries)
library(dplyr)
data_2 <- read_excel("D:\\kulea_projects\\r_project\\east_south_sugar\\Eastern_Congo_Data_2.xlsx",
                    sheet = "EasternDRC", skip = 1)
# Filter data for consumption from 2015 to 2026
consumption_data <- data_2 %>%
filter(year(Month) >= 2026 & year(Month) <= 2027) %>% select(Month, Consumption)

print(tail(consumption_data))

cons_data <- ts(consumption_data$Consumption,
                start = c(year(consumption_data$Month[1]),
                          month(consumption_data$Month[1])),
                frequency = 12)

data <- read_excel("D:\\kulea_projects\\r_project\\east_south_sugar\\Eastern_Congo.xlsx",
                   sheet = "EasternDRC_Copy", skip = 1)
head(data)
num_col <- ncol(data)
col_names <- colnames(data)
print(col_names)
sel_data <- data[, c("Month", "Consumption", "Imports"
)]
print(head(sel_data))
print(class(sel_data))
end_date <- as.Date("2025-12-01 00:00:00")
sel_data_2 <- sel_data[sel_data$Month <= end_date, ]
print(tail(sel_data_2))
cons_ts_data <- ts(sel_data_2$Consumption,
                   start = c(year(sel_data_2$Month[1]),
                             month(sel_data_2$Month[1])),
                   frequency = 12)

import_ts_data <- ts(sel_data_2$Imports,
                     start = c(year(sel_data_2$Month[1]),
                               month(sel_data_2$Month[1])),
                     frequency = 12)

# # Fit an ARIMA model to imports using consumption as an exogenous variable
# arima_model <- auto.arima(import_ts_data, xreg = cons_ts_data)

# auto.arima(import_ts_data, xreg = cons_ts_data, ic = "aic", trace = TRUE)
# adf_test_results <- adf.test(arima_model$residuals)
# print(adf_test_results)

arima_model <- Arima(import_ts_data,
                     order = c(0, 0, 1),
                     xreg = cons_ts_data,
                     seasonal = list(order = c(0, 1, 0), period = 12))

print(arima_model)
plot(arima_model$residuals)
acf(arima_model$residuals, main = "ACF Residual")
pacf(arima_model$residuals, main = "PACF Residual")
mean_of_errors <- mean(arima_model$residuals)
print(mean_of_errors)
# # # Forecast imports for the years 2023-2026
forecasted_imports_data <- forecast(arima_model, xreg = cons_data, h = 2)

# # # Print the forecasted values
print(forecasted_imports_data)
# plot(forecasted_imports_data)

# # # print(ts_data)
# # # print(sum(is.na(ts_data)))
# # # ts_data_summary <- summary(ts_data)
# # # print(ts_data_summary)
# # # print(cycle(ts_data))
# # # boxplot(ts_data ~ cycle(ts_data))
# # # plot(ts_data)
# # # decomposed_data <- decompose(ts_data, "multiplicative")
# # # plot(decomposed_data)
# # # plot(decomposed_data$trend)
# # # plot(decomposed_data$seasonal)
# # # plot(decomposed_data$random)
# # # plot(sel_data_2)
# # # plot(cons_ts_data)
# # # plot(import_ts_data)
# # # # abline(reg = lm(ts_data ~ time(ts_data)))
# # # # cycle(ts_data)
# # # # boxplot(ts_data ~ cycle(ts_data))
# # # # arima_model <- Arima(ts_data,
# # # #                      order = c(2, 0, 2), 
# # # #                      seasonal = list(order = c(0, 0, 2), period = 12))
# # # # arima_model <- auto.arima(ts_data)
# # # print(arima_model)
# # # auto.arima(ts_data, ic = "aic", trace = TRUE)
# # # adf_test_results <- adf.test(arima_model$residuals)
# # # print(adf_test_results)
# # # plot(arima_model$residuals)
# # # acf(arima_model$residuals, main = "ACF Residual")
# # # pacf(arima_model$residuals, main = "PACF Residual")
# # # # forecast_niger_cons_imports <- forecast(arima_model, level = c(95), h = 4 * 12)
# # plot(forecasted_imports_data)

# # # # print(forecast_niger_cons_imports)

file_path <- "forecast_eastern_congo_imports_2026_2028.csv"

# Save the forecast to a CSV file
write.csv(forecasted_imports_data, file = file_path, row.names = TRUE)