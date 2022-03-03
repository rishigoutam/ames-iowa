library(tidyverse)
library(ggcorrplot)
library(gtools)
library(lubridate)

#Acquire data 
data <- read_csv("../data/engineered.csv")
data <- data[-1]


#Make Tidy average data frames 
#First get neighborhood and price columns, along with sale date
data$YrSold <- gsub("Yr_","", data$YrSold) #Clean date
data <- data %>% select(YrSold, MoSold, Neighborhood, SalePrice)

#Make a lubridate column 
data$date <-paste(data$MoSold,sep="-", data$YrSold)
data$date <-lubridate::my(data$date)
data <- data %>% select(-c(YrSold,MoSold))

data %>% select(Neighborhood) %>% unique() %>% view()
#We Get Average prices by group, and by date. 
data <- data %>% group_by(Neighborhood, date) %>% 
  summarise_at(vars(SalePrice), list(AvPrice = mean, MedPrice = median, StDev= sd))
#No StDev when only one house in paramatercoordinate

