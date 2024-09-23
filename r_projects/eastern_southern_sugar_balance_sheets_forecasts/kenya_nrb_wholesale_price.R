library(forecast)
library(ggplot2)
library(lubridate)
library(readxl)
library(tseries)
library(dplyr)
data_2 <- read_excel("D:\\kulea_projects\\r_project\\east_south_sugar\\Wholesale Sugar Prices.xlsx",
                    sheet = "Sheet1",)
# Select only the "Date" and "nairobi" columns
nairobi_data <- data_2[, c("date", "nairobi")]

print(head(nairobi_data))

# exports_ts_data <- ts(nairobi_data$nairobi,
#                    start = c(year(nairobi_data$date[1]),
#                              month(nairobi_data$date[1]),
#                              day(nairobi_data$date[1])),
#                    frequency = 26)

exports_ts_data <- ts(nairobi_data$nairobi, frequency = 26)

# data <- read_excel("D:\\kulea_projects\\r_project\\east_south_sugar\\Kenya.xlsx",
#                    sheet = "Kenya", skip = 1)
# head(data)
# num_col <- ncol(data)
# col_names <- colnames(data)
# print(col_names)
# sel_data <- data[, c("Month", "Consumption", "Imports"
# )]
# print(head(sel_data))
# print(class(sel_data))
# end_date <- as.Date("2025-12-01 00:00:00")
# sel_data_2 <- sel_data[sel_data$Month <= end_date, ]
# print(tail(sel_data_2))
# export_ts_data <- ts(sel_data_2$Consumption,
#                      start = c(year(sel_data_2$Month[1]),
#                                month(sel_data_2$Month[1])),
#                      frequency = 12)

# raw_exports_ts_data <- ts(sel_data_2$`Imports`,
#                           start = c(year(sel_data_2$Month[1]),
#                                     month(sel_data_2$Month[1])),
#                           frequency = 12)

# # # Fit an ARIMA model to imports using consumption as an exogenous variable
# # arima_model <- auto.arima(raw_exports_ts_data, xreg = export_ts_data)

# arima_model <- auto.arima(exports_ts_data, ic = "aic", trace = TRUE)

# # auto.arima(raw_exports_ts_data, xreg = export_ts_data, ic = "aic", trace = TRUE)
# adf_test_results <- adf.test(arima_model$residuals)
# print(adf_test_results)

arima_model <- Arima(exports_ts_data,
                     order = c(0, 1, 1), #c(0,0,2)
#                      xreg = export_ts_data,
                     seasonal = list(order = c(3, 1, 0), period = 86)) # c(3, 0, 1) period=52

# # print(arima_model)
# # plot(arima_model$residuals)
# # acf(arima_model$residuals, main = "ACF Residual")
# # # pacf(arima_model$residuals, main = "PACF Residual")
# # mean_of_errors <- mean(arima_model$residuals)
# # print(mean_of_errors)
# # # # # Forecast price for the years 2023-2026
# # forecasted_imports_data <- forecast(arima_model, h = 5)
# forecast_results <- forecast(arima_model, h = 52)
# # Extract forecasted values
# forecast_values <- forecast_results$mean
# # Get the time index of the forecast
# forecast_time <- time(forecast_values)

# Specify the start date
start_date <- as.Date("2024-02-12")
# Define a function to check if a given date is Monday, Tuesday, or Friday
is_desired_day <- function(date) {
  wd <- weekdays(date)
  wd %in% c("Monday", "Tuesday", "Friday")
}

# # # Generate forecasted dates based on the frequency of the time series
# # forecast_dates <- start_date + (1:length(forecast_time) - 1) * 7  # Start from the specified start_date and increment by 7 days

# # # Filter out non-Monday, Tuesday, and Friday dates
# # forecast_dates <- forecast_dates[sapply(forecast_dates, is_desired_day)]

# # Generate forecasted dates based on the frequency of the time series
forecast_dates_monday <- start_date + (1:length(forecast_time) - 1) * 7  # Start from the specified start_date and increment by 7 days
forecast_dates_tuesday <- as.Date("2024-02-13") + (1:length(forecast_time) - 1) * 7  # Start from the specified start_date and increment by 7 days
forecast_dates_friday <- as.Date("2024-02-09") + (1:length(forecast_time) - 1) * 7  # Start from the specified start_date and increment by 7 days

# print(forecast_dates_monday)
Date_ <- c(forecast_dates_monday, forecast_dates_tuesday, forecast_dates_friday)
Date_ <- sort(Date_)
print(Date_)

forecast_df <- data.frame(
  Date_,
  Forecasted_Values = forecast_results
)
print(forecast_df)
# Plot forecasted data
plot(forecast_results, main = "ARIMA Forecast", xlab = "Date", ylab = "Values")
# # # Filter out non-Monday, Tuesday, and Friday dates
# forecast_dates_monday <- forecast_dates_monday[sapply(forecast_dates_monday, is_desired_day)]
# forecast_dates_tuesday <- forecast_dates_tuesday[sapply(forecast_dates_tuesday, is_desired_day)]
# forecast_dates_friday <- forecast_dates_friday[sapply(forecast_dates_friday, is_desired_day)]

# # # Combine forecasted dates and values into a dataframe
# forecast_df <- data.frame(
#   Date = c(forecast_dates_monday, forecast_dates_tuesday, forecast_dates_friday),
#   Forecasted_Values = forecast_results
# )
# print(forecast_df)
# # Create separate data frames for Monday, Tuesday, and Friday
# forecast_df_monday <- data.frame(Date = forecast_dates_monday, Forecasted_Values = forecast_results)
# forecast_df_tuesday <- data.frame(Date = forecast_dates_tuesday, Forecasted_Values = forecast_results)
# forecast_df_friday <- data.frame(Date = forecast_dates_friday, Forecasted_Values = forecast_results)

# # Concatenate the data frames
# forecast_df_2 <- rbind(forecast_df_monday, forecast_df_tuesday, forecast_df_friday)

# print(forecast_df_2)
# # Print forecasted dates
# # print(forecast_dates)

# # Generate forecasted dates based on the frequency of the time series
# # forecast_dates <- seq(start_date, by = 1/26, length.out = length(forecast_time))
# # forecast_dates <- seq(start_date, length.out = length(forecast_time))

# # # Combine forecasted dates and values into a dataframe
# # forecast_df <- data.frame(Date = forecast_dates, Forecasted_Values = forecast_values)

# # # Print forecast results
# # print(forecast_values)

# # Plot forecasted data
# plot(forecast_results, main = "ARIMA Forecast", xlab = "Date", ylab = "Values")

# # Combine forecasted dates and values into a dataframe
# forecast_df <- data.frame(Date = forecast_dates, Forecasted_Values = forecast_results)
# print(forecast_df)
# # Save the forecasted dates and results to a table
# # write.csv(forecast_df, file = "forecast_results.csv", row.names = FALSE)


# # print(forecast_time)
# # # # # print(ts_data)
# # # # # print(sum(is.na(ts_data)))
# # # # # ts_data_summary <- summary(ts_data)
# # # # # print(ts_data_summary)
# # # # # print(cycle(ts_data))
# # # # # boxplot(ts_data ~ cycle(ts_data))
# # # # # plot(ts_data)
# # # # # decomposed_data <- decompose(ts_data, "multiplicative")
# # # # # plot(decomposed_data)
# # # # # plot(decomposed_data$trend)
# # # # # plot(decomposed_data$seasonal)
# # # # # plot(decomposed_data$random)
# # # # # plot(sel_data_2)
# # # # # plot(cons_ts_data)
# # # # # plot(import_ts_data)
# # # # # # abline(reg = lm(ts_data ~ time(ts_data)))
# # # # # # cycle(ts_data)
# # # # # # boxplot(ts_data ~ cycle(ts_data))
# # # # # # arima_model <- Arima(ts_data,
# # # # # #                      order = c(2, 0, 2), 
# # # # # #                      seasonal = list(order = c(0, 0, 2), period = 12))
# # # # # # arima_model <- auto.arima(ts_data)
# # # # # print(arima_model)
# # # # # auto.arima(ts_data, ic = "aic", trace = TRUE)
# # # # # adf_test_results <- adf.test(arima_model$residuals)
# # # # # print(adf_test_results)
# # # # # plot(arima_model$residuals)
# # # # # acf(arima_model$residuals, main = "ACF Residual")
# # # # # pacf(arima_model$residuals, main = "PACF Residual")
# # # # # # forecast_niger_cons_imports <- forecast(arima_model, level = c(95), h = 4 * 12)
# # # # plot(forecasted_imports_data)

# # file_path <- "forecast_kenya_imports_2026_2028.csv"

# # # Save the forecast to a CSV file
# # write.csv(forecasted_imports_data, file = file_path, row.names = TRUE)