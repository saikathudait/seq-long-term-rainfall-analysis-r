# Data Import and Initial Exploration
# Install all required packages first (if not then run)
#install.packages("dplyr")
#install.packages("ggplot2")
#install.packages("maps")
#install.packages("lubridate")

# Load all necessary libraries
library(dplyr)
library(ggplot2)
library(maps)
library(lubridate)

# Import metadata and station data
meta_data <- read.csv("D:/ghcnd_meta_data (1).csv")
station_data <- read.csv("D:/station_data.csv")

# Check the structure of the data
str(meta_data)
str(station_data)

# Section 1: Preprocessing the meta data
## Question 1.1: Filtering SEQ Stations with Precipitation Data Over 110 Years
# Filter stations based on criteria
seq_stations <- meta_data %>%
  filter(
    element == "PRCP", # Stations that record precipitation
    (last_year - first_year + 1) >= 110, # At least 110 years of data
    longitude >= 138 & longitude <= 155, # Between longitude 138°E and 155°E
    latitude >= -29.5 & latitude <= -26 # Between latitude 29.5°S and 26°S
  )

# Display the first few rows of the filtered data
head(seq_stations)

## Question 1.2: Create a new data frame with stations meeting specific criteria
# Count the number of stations
nrow(seq_stations)

# Section 2: Exploratory Visualization
## Question 2.1: Mapping Station Locations in South East Queensland
# Get Australia map data
aus_map <- map_data("world", region = "Australia")

# Create visualization of station locations
ggplot() +
  geom_polygon(data = aus_map, aes(x = long, y = lat, group = group), 
               fill = "lightgray", color = "gray") +
  geom_point(data = seq_stations, aes(x = longitude, y = latitude), 
             color = "blue", size = 3, alpha = 0.7) +
  geom_text(data = seq_stations, aes(x = longitude, y = latitude, label = name), 
            size = 2.5, hjust = 0, vjust = 0, nudge_x = 0.2, nudge_y = 0.2) +
  coord_fixed(xlim = c(138, 155), ylim = c(-30, -25)) +
  labs(title = "Weather Stations in South East Queensland",
       subtitle = "Stations with precipitation data spanning at least 110 years",
       x = "Longitude (°E)", y = "Latitude (°S)") +
  theme_minimal()


# Section 3: Summary Statistics
## Question 3.1: Merging Precipitation Records with Station Metadata
# Merge station data with SEQ metadata
seq_station_data <- station_data %>%
  inner_join(seq_stations, by = "id")

# Check the first few rows of the combined data
head(seq_station_data)

## Question 3.2: Mean and Median Rainfall per Station (Excluding Zeros)
# Exclude zero observations and calculate mean and median precipitation by station
station_summary <- seq_station_data %>%
  filter(prcp > 0) %>%
  group_by(name) %>%
  summarise(
    mean_prcp = mean(prcp, na.rm = TRUE),
    median_prcp = median(prcp, na.rm = TRUE)
  ) %>%
  arrange(desc(mean_prcp))

# Display the summary table
station_summary

## Question 3.3: Comparative Boxplot of Rainfall Across SEQ Stations
# Create a boxplot of precipitation by station
ggplot(seq_station_data %>% filter(prcp > 0), aes(x = reorder(name, prcp, FUN = median), y = prcp)) +
  # Add boxplot
  geom_boxplot(fill = "lightblue", alpha = 0.7) +
  # Add mean points with distinctive shape and color
  stat_summary(fun = mean, geom = "point", shape = 23, size = 3, fill = "red") +
  # Add labels and title
  labs(title = "Distribution of Precipitation at South East Queensland Stations",
       subtitle = "Excluding zero rainfall observations",
       x = "Weather Station",
       y = "Precipitation (mm)") +
  # Adjust theme for readability
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(face = "bold"),
        panel.grid.minor = element_blank()) +
  # Use log scale for better visualization of skewed precipitation data
  scale_y_log10()

# Section 4: Hypothesis Testing
## Question 4.1: Top 5 Rainfall Records at Selected Post Office Station
# First check available post office stations in our filtered dataset
post_offices <- seq_stations %>%
  filter(grepl("POST OFFICE", name))
print("Available post office stations in the dataset:")
print(unique(post_offices$name))

# Select TIBOOBURRA POST OFFICE based on surname "Gulam" (A-M)
post_office_name <- "TIBOOBURRA POST OFFICE"

# Create a new data frame for the selected post office
post_office_station <- seq_station_data %>%
  filter(name == post_office_name)

# Check if we have data for this station
print(paste("Number of records for", post_office_name, ":", nrow(post_office_station)))

# Display the top 5 largest recorded precipitation totals
top_rainfall <- post_office_station %>%
  arrange(desc(prcp)) %>%
  head(5)
print("Top 5 largest precipitation totals:")
print(top_rainfall)

## Question 4.2: Day-of-Week Analysis of Peak Rainfall Events
# Add day of the week column
post_office_station <- post_office_station %>%
  mutate(date = as.Date(date),
         wday = weekdays(date))

# Check on which days the top 5 largest precipitation events occurred
top_days <- post_office_station %>%
  arrange(desc(prcp)) %>%
  select(date, wday, prcp) %>%
  head(5)
print("Days of the week for top 5 largest precipitation events:")
print(top_days)


## Question 4.5: Perform the statistical test
# Calculate the observed frequencies for each day of the week
observed_freq <- table(post_office_station$wday)
print(observed_freq)

# Only run the chi-square test if you have valid data
if(sum(observed_freq > 0) >= 2) {  
  # Calculate the expected frequencies (assuming equal distribution)
  total_days <- sum(observed_freq)
  days_in_week <- 7
  expected_freq <- rep(total_days / days_in_week, days_in_week)
  
  # Perform chi-square goodness-of-fit test
  chi_sq_test <- chisq.test(observed_freq)
  print(chi_sq_test)
} else {
  print("Insufficient data for chi-square test")
}




