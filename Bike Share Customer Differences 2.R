#Install required packages
#tidyverse for data import and wrangling
#lubridate for date functions
#ggplot for visualization
library(tidyverse)
library(lubridate)
library(ggplot2)


#getwd() #displays working directory
#setwd() #sets working directory
getwd()
setwd("C:/Users/MyNitoCreations1989/Documents/Coursera/Data Analytics/Course 8/Case Study 1/cleaned data/csv")


#Upload datasets
Aug_2021 <- read_csv("2021_08.csv")
Sep_2021 <- read_csv("2021_09.csv")
Oct_2021 <- read_csv("2021_10.csv")
Nov_2021 <- read_csv("2021_11.csv")
Dec_2021 <- read_csv("2021_12.csv")
Jan_2022 <- read_csv("2022_01.csv")
Feb_2022 <- read_csv("2022_02.csv")
Mar_2022 <- read_csv("2022_03.csv")
Apr_2022 <- read_csv("2022_04.csv")
May_2022 <- read_csv("2022_05.csv")
Jun_2022 <- read_csv("2022_06.csv")
Jul_2022 <- read_csv("2022_07.csv")


#Combine all data into one dataframe
all_trips <- bind_rows(Aug_2021, Sep_2021, Oct_2021, Nov_2021, Dec_2021, Jan_2022, Feb_2022, Mar_2022, Apr_2022, May_2022, Jun_2022, Jul_2022)


#View column names
colnames(all_trips)


#Delete unnecessary columns
all_trips <- all_trips %>%  
  select(-c(start_lat, start_lng, end_lat, end_lng))


#Add columns that list the date, month, day, and year of each ride seperately
all_trips$date <- as.Date(all_trips$started_at)
all_trips$month <- format(as.Date(all_trips$date), "%m")
all_trips$day <- format(as.Date(all_trips$date), "%d")
all_trips$year <- format(as.Date(all_trips$date), "%Y")
all_trips$day_of_week <- format(as.Date(all_trips$date), "%A")


#Add a "ride_length" calculation to all_trips (in seconds)
all_trips$ride_length <- difftime(all_trips$ended_at,all_trips$started_at)


#str() Inspect the structure of the columns
str(all_trips)


#Convert "ride_length" to numeric
all_trips$ride_length <- as.numeric(all_trips$ride_length)
is.numeric(all_trips$ride_length)


#Created new data frame for removing negative ride lengths and NULL bike data
all_trips_v2 <- all_trips[!(all_trips$start_station_name == "HQ QR" | all_trips$ride_length<0),] %>% 
  drop_na(ride_length)


#Analysis of ride_length
mean(all_trips_v2$ride_length) #average ride length
median(all_trips_v2$ride_length) #midpoint number in the ascending array of ride lengths
max(all_trips_v2$ride_length) #longest ride
min(all_trips_v2$ride_length) #shortest ride


#Compare members and casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = mean)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = median)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = max)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = min)


#Average ride time by each day for members vs casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)


#Order days of the week
all_trips_v2$day_of_week <- ordered(all_trips_v2$day_of_week, levels=c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))


#Average ride time by day for members vs casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)


#Count of riders and average ride duration by type and weekday
all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%  #creates weekday field using wday()
  group_by(member_casual, weekday) %>%  #groups by usertype and weekday
  summarise(number_of_rides = n(),   #calculates the number of rides
  average_duration = mean(ride_length)) %>%  #calculates the average duration
  arrange(member_casual, weekday)  #sorts


#Visualize the number of rides by rider type
all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n(),
            average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")


#Visualization for average duration
all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%
  group_by(member_casual, weekday) %>%
  summarise(number_of_rides = n(),
            average_duration = mean(ride_length)) %>%
  arrange(member_casual, weekday)  %>%
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge")

# Create a csv file
write.csv(all_trips_v2, file = "C:/Users/MyNitoCreations1989/Documents/MrBrookfieldPortfolio/Projects/R Project/Bike_Share_Customer_Differences.csv")