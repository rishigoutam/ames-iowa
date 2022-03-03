library(tidyverse)
library(ggcorrplot)
library(gtools)
library(lubridate)
library(tsibble)
library(fable)
library(feasts)
library(patchwork)


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

odata <- data %>% group_by(date) %>% summarise_at(vars(SalePrice), list(AvPrice = mean))


avdata <- cldata %>% select(-c(MedPrice,StDev)) 
meddata <- cldata %>% select(-c(AvPrice))
avdata<- avdata %>% as_tsibble(key=Neighborhood, index = date) #Avdata is tidy, tsibble
meddata <- meddata %>% as_tsibble(key=Neighborhood, index=date) #meddata is untidy tsibble

#Naive plot
avdata %>% ggplot()+geom_line(aes(x=date,y=AvPrice,color=Neighborhood))

odata %>% ggplot()+ geom_line(aes(x=date,y=AvPrice))


#Split by neighborhood and autoplot, Ranked by Average House Price 

order$Neighborhood


#Top 7
upp<- avdata %>% filter(Neighborhood %in% c("NoRidge", "NridgHt", "StoneBr" ,"GrnHill" ,"Veenker" ,"Timber" , "Somerst")) %>% 
  ggplot()+geom_line(aes(x=date,y=AvPrice,color=Neighborhood)) + 
  labs(title = "Upper 7 Neighborhoods Average House Prices", y= "Average Price $")

#TopMid 7
umid<- avdata %>% filter(Neighborhood %in% c("ClearCr", "Crawfor", "CollgCr", "Blmngtn", "Greens",  "NWAmes" , "Gilbert")) %>%
  ggplot()+geom_line(aes(x=date,y=AvPrice,color=Neighborhood)) + 
  labs(title = "Upper-Middle 7 Neighborhoods Average House Prices", y= "Average Price $")

#BottomMid 7
lmid<- avdata %>% filter(Neighborhood %in% c("SawyerW", "Mitchel", "NAmes",   "Blueste", "NPkVill" ,"Sawyer" , "Landmrk" )) %>% 
  ggplot()+geom_line(aes(x=date,y=AvPrice,color=Neighborhood)) + 
  labs(title = "Lower-Middle 7 Neighborhoods Average House Prices", y= "Average Price $")

#Bottom 7 
low <- avdata %>% filter(Neighborhood %in% c("SWISU","Edwards" ,"OldTown", "BrkSide", "IDOTRR",  "BrDale",  "MeadowV")) %>% 
  ggplot()+geom_line(aes(x=date,y=AvPrice,color=Neighborhood)) + 
  labs(title = "Lower 7 Neighborhoods Average House Prices", y= "Average Price $")


(upp | umid) / (lmid | low)







