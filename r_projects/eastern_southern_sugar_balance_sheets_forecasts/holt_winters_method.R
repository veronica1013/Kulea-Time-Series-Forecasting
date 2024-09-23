library(forecast)
library(ggplot2)
library(lubridate)
library(readxl)
library(tseries)
data <- read_excel("Mauritius.xlsx",
                   sheet = "Mauritius_Copy", skip = 1)
head(data)
num_col <- ncol(data)
col_names <- colnames(data)
print(col_names)
sel_data <- data[, c("Month", "Production"
)]
print(head(sel_data))
print(class(sel_data))
end_date <- as.Date("2026-06-01 00:00:00")
sel_data_2 <- sel_data[sel_data$Month <= end_date, ]
print(tail(sel_data_2))
ts_data <- ts(sel_data_2$`Production`,
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

# Fit Holt-Winters model
holt_winters_model <- HoltWinters(ts_data, beta = FALSE, gamma = FALSE)

# Forecast with Holt-Winters
forecast_horizon <- 2 * 12  # Forecast for 2 years (assuming monthly data)
forecast_mauritius_production <- forecast(holt_winters_model, h = forecast_horizon)

# Print the forecast
print(forecast_mauritius_production)

# Plot the forecast
plot(forecast_mauritius_production)

# file_path <- "forecast_mauritius_production_2026_2028.csv"

# # Save the forecast to a CSV file
# write.csv(forecast_mauritius_production, file = file_path, row.names = TRUE)