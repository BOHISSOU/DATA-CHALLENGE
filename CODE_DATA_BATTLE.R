library(dplyr)
library(lubridate)
library(ggplot2)

data <- read.csv("segment_alerts_all_airports_train.csv")
View(data)
head(data)

data$date <- ymd_hms(data$date)

storm_data <- data %>%
  filter(!is.na(airport_alert_id)) %>%
  group_by(airport, airport_alert_id) %>%
  summarise(
    start_time   = min(date, na.rm = TRUE),
    end_time     = max(date, na.rm = TRUE),
    duration_min = as.numeric(difftime(end_time, start_time, units = "mins")),
    n_lightning  = n(),
    dist_mean    = mean(dist, na.rm = TRUE),
    dist_sd      = sd(dist, na.rm = TRUE),
    amp_mean     = mean(amplitude, na.rm = TRUE),
    amp_max      = max(abs(amplitude), na.rm = TRUE),
    azimuth_sd   = sd(azimuth, na.rm = TRUE),
    .groups = "drop"
  )
storm_num <- storm_data %>%
  select(duration_min, n_lightning, dist_mean, dist_sd, amp_mean, amp_max, azimuth_sd)

storm_num$dist_sd[is.na(storm_num$dist_sd)] <- 0
storm_num$azimuth_sd[is.na(storm_num$azimuth_sd)] <- 0
storm_scaled <- scale(storm_num)
nrow(storm_scaled)


set.seed(123)
k <- min(3, nrow(storm_scaled))
kmeans_res <- kmeans(storm_scaled, centers = k)

storm_data$cluster <- kmeans_res$cluster

table(storm_data$cluster)


library(dplyr)

storm_data %>%
  group_by(cluster) %>%
  summarise(
    duration = mean(duration_min),
    n_flash  = mean(n_lightning),
    dist     = mean(dist_mean),
    amp      = mean(amp_mean),
    dispersion = mean(azimuth_sd)
  )


ggplot(storm_data, aes(duration_min, n_lightning, color = factor(cluster))) +
  geom_point(size = 2) +
  theme_minimal()
table(storm_data$airport, storm_data$cluster)

