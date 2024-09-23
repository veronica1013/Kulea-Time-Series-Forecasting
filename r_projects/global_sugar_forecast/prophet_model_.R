# Load required libraries
# library(rstan)
library(forecast)
library(ggplot2)
# library(lubriTime)
library(readxl)
library(tseries)
library(prophet)
library(dplyr)

# Load data
df <- read_excel("D:\\kulea_projects\\r_project\\global_sugar\\SBY00_2000_01_03_to_2024_02_21_Y_M_D.xlsx",
sheet = "SBY00_daily_2024-01-01_2024-02-")
# print(head(df))

# select the Time and Close columns
selected_df <- df %>% select(Time, Close)

# # Rename columns to 'ds' and 'y'
colnames(selected_df) <- c('ds', 'y')
selected_df$ds <- as.Date(selected_df$ds)
# Convert 'Time' column to Time format if it's not already in Time format
selected_df$ds <- as.Date(selected_df$ds)
# Reorder the dataframe by the 'Time' column in ascending order
selected_df <- arrange(selected_df, ds)

# Order the dataframe by the 'Date' column in ascending order
# selected_df <- selected_df[order(selected_df$ds), ]
print(tail(selected_df))
print(head(selected_df))
# # # Rename columns to 'ds' and 'y'
# colnames(selected_df) <- c('ds', 'y')

# # Initialize Prophet model
# model <- prophet()

# # Fit the model to your data
# model_fit <- fit.prophet(model, df)

# # Forecast 1 year into the future
# future <- make_future_dataframe(model_fit, periods = 365)

# # Predict using the trained model
# forecast <- predict(model_fit, future)

# # Compute performance metrics
# mape <- mean(abs((df$y - forecast$yhat) / df$y)) * 100
# rmse <- sqrt(mean((df$y - forecast$yhat)^2))
# r2 <- 1 - sum((df$y - forecast$yhat)^2) / sum((df$y - mean(df$y))^2)

# # Print metrics
# print(paste("MAPE:", mape))
# print(paste("RMSE:", rmse))
# print(paste("R-squared:", r2))

# # Save forecasted results
# write.csv(forecast[c('ds', 'yhat')], "forecasted_results.csv", row.names = FALSE)
