library(forecast)
library(ggplot2)
library(lubridate)
library(readxl)

# Read the data
data <- read_excel("Mauritius.xlsx", sheet = "Mauritius_Copy", skip = 1)

# Extract relevant columns
sel_data <- data[, c("Month", "Production")]

# Prepare time series data
ts_data <- ts(sel_data$Production,
              start = c(year(sel_data$Month[1]), month(sel_data$Month[1])),
              frequency = 12)

# Decompose the time series
decomposed_data <- decompose(ts_data, "multiplicative")

# Fit ETS model
ets_model <- ets(ts_data)
print(ets_model)
print(accuracy(ets_model))
print(coef(ets_model))
print(summary(ets_model))
# Forecast with ETS
forecast_horizon <- 2 * 12  # Forecast for 2 years (assuming monthly data)
forecast_mauritius_production <- forecast(ets_model, h = forecast_horizon)

# Print the forecast
print(forecast_mauritius_production)

# Plot the forecast
plot(forecast_mauritius_production)

file_path <- "forecast_mauritius_ets_production_2026_2028.csv"

# Save the forecast to a CSV file
write.csv(forecast_mauritius_production, file = file_path, row.names = TRUE)