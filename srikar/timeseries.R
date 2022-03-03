library(tidyverse)
library(ggcorrplot)
library(gtools)
library(lubridate)
library(tsibble)
library(fable)
library(feasts)


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


#Order Neighborhoods by average price
order <- data %>% group_by(Neighborhood) %>% summarise_at(vars(SalePrice), list(AvPrice = mean)) %>%
  arrange(desc(AvPrice))
view(order)


#We Get Average prices by group, and by date. 
cldata <- data %>% group_by(Neighborhood, date) %>% 
  summarise_at(vars(SalePrice), list(AvPrice = mean, MedPrice = median, StDev= sd))
#No StDev when only one house in paramater coordinate

avdata <- cldata %>% select(-c(MedPrice,StDev)) 
meddata <- cldata %>% select(-c(AvPrice))
avdata<- avdata %>% as_tsibble(key=Neighborhood, index = date) #Avdata is tidy, tsibble
meddata <- meddata %>% as_tsibble(key=Neighborhood, index=date) #meddata is untidy tsibble
avdata %>% ggplot()+geom_line(aes(x=date,y=AvPrice,color=Neighborhood))

#Split by neighborhood and autoplot
#SWISU
swisu <- avdata %>% filter(Neighborhood=="SWISU") %>% select(-c(Neighborhood))
autoplot(swisu, AvPrice) + 
  labs(title = "SWISU Average House Prices",
       y= "Average Price $")




#Edwards
edwards <- avdata %>% filter(Neighborhood=="Edwards") %>% select(-c(Neighborhood))
autoplot(edwards, AvPrice) + 
  labs(title = "Edwards Average House Prices",
       y= "Average Price $")



#IDOT
swisu <- avdata %>% filter(Neighborhood=="SWISU") %>% select(-c(Neighborhood))
autoplot(swisu, AvPrice) + 
  labs(title = "SWISU Average House Prices",
       y= "Average Price $")





swisu <- avdata %>% filter(Neighborhood=="SWISU") %>% select(-c(Neighborhood))
autoplot(swisu, AvPrice) + 
  labs(title = "SWISU Average House Prices",
       y= "Average Price $")





swisu <- avdata %>% filter(Neighborhood=="SWISU") %>% select(-c(Neighborhood))
autoplot(swisu, AvPrice) + 
  labs(title = "SWISU Average House Prices",
       y= "Average Price $")





swisu <- avdata %>% filter(Neighborhood=="SWISU") %>% select(-c(Neighborhood))
autoplot(swisu, AvPrice) + 
  labs(title = "SWISU Average House Prices",
       y= "Average Price $")





swisu <- avdata %>% filter(Neighborhood=="SWISU") %>% select(-c(Neighborhood))
autoplot(swisu, AvPrice) + 
  labs(title = "SWISU Average House Prices",
       y= "Average Price $")





swisu <- avdata %>% filter(Neighborhood=="SWISU") %>% select(-c(Neighborhood))
autoplot(swisu, AvPrice) + 
  labs(title = "SWISU Average House Prices",
       y= "Average Price $")





swisu <- avdata %>% filter(Neighborhood=="SWISU") %>% select(-c(Neighborhood))
autoplot(swisu, AvPrice) + 
  labs(title = "SWISU Average House Prices",
       y= "Average Price $")





swisu <- avdata %>% filter(Neighborhood=="SWISU") %>% select(-c(Neighborhood))
autoplot(swisu, AvPrice) + 
  labs(title = "SWISU Average House Prices",
       y= "Average Price $")





swisu <- avdata %>% filter(Neighborhood=="SWISU") %>% select(-c(Neighborhood))
autoplot(swisu, AvPrice) + 
  labs(title = "SWISU Average House Prices",
       y= "Average Price $")





swisu <- avdata %>% filter(Neighborhood=="SWISU") %>% select(-c(Neighborhood))
autoplot(swisu, AvPrice) + 
  labs(title = "SWISU Average House Prices",
       y= "Average Price $")




swisu <- avdata %>% filter(Neighborhood=="SWISU") %>% select(-c(Neighborhood))
autoplot(swisu, AvPrice) + 
  labs(title = "SWISU Average House Prices",
       y= "Average Price $")




swisu <- avdata %>% filter(Neighborhood=="SWISU") %>% select(-c(Neighborhood))
autoplot(swisu, AvPrice) + 
  labs(title = "SWISU Average House Prices",
       y= "Average Price $")




swisu <- avdata %>% filter(Neighborhood=="SWISU") %>% select(-c(Neighborhood))
autoplot(swisu, AvPrice) + 
  labs(title = "SWISU Average House Prices",
       y= "Average Price $")




swisu <- avdata %>% filter(Neighborhood=="SWISU") %>% select(-c(Neighborhood))
autoplot(swisu, AvPrice) + 
  labs(title = "SWISU Average House Prices",
       y= "Average Price $")

