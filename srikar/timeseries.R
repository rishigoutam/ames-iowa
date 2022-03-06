library(tidyverse)
library(ggcorrplot)
library(gtools)
library(lubridate)
library(fpp3)
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
#noshow <- avdata %>% ggplot()+geom_line(aes(x=date,y=AvPrice,color=Neighborhood))



#Convolution over all times (By Month)

conv <- data %>% group_by(month(date), Neighborhood) %>% summarise_at(vars(SalePrice), list(AvPrice = median) )%>%
  arrange(desc(AvPrice)) #####Should I use Median or Average here? 
conv %>% ggplot() +geom_line(aes(x=`month(date)`, y=AvPrice, color=Neighborhood))
#



chekcodata %>% ggplot()+ geom_line(aes(x=date,y=AvPrice))


#Split by neighborhood and autoplot, Ranked by Average House Price 

order$Neighborhood


#Top 7
upp<- avdata %>% filter(Neighborhood %in% c("NoRidge", "NridgHt", "StoneBr" ,"GrnHill" ,"Veenker" ,"Timber" , "Somerst")) %>% 
  ggplot()+geom_line(aes(x=date,y=AvPrice,color=Neighborhood)) + 
  labs(title = "Upper 7 Neighborhoods Average House Prices", y= "Average Price $")
conv %>% filter(Neighborhood %in% c("NoRidge", "NridgHt", "StoneBr" ,"GrnHill" ,"Veenker" ,"Timber" , "Somerst")) %>%
  ggplot() +geom_line(aes(x=`month(date)`, y=AvPrice, color=Neighborhood))+ 
  labs(title = "Upper 7 Neighborhoods Convolved House Prices", y= "Average Price $")



#TopMid 7
umid<- avdata %>% filter(Neighborhood %in% c("ClearCr", "Crawfor", "CollgCr", "Blmngtn", "Greens",  "NWAmes" , "Gilbert")) %>%
  ggplot()+geom_line(aes(x=date,y=AvPrice,color=Neighborhood)) + 
  labs(title = "Upper-Middle 7 Neighborhoods Average House Prices", y= "Average Price $")
conv %>% filter(Neighborhood %in% c("ClearCr", "Crawfor", "CollgCr", "Blmngtn", "Greens",  "NWAmes" , "Gilbert") )%>%
  ggplot() +geom_line(aes(x=`month(date)`, y=AvPrice, color=Neighborhood))+
  labs(title = "Upper-Middle 7 Neighborhoods Convolved House Prices", y= "Average Price $")


#BottomMid 7
lmid<- avdata %>% filter(Neighborhood %in% c("SawyerW", "Mitchel", "NAmes",   "Blueste", "NPkVill" ,"Sawyer" , "Landmrk" )) %>% 
  ggplot()+geom_line(aes(x=date,y=AvPrice,color=Neighborhood)) + 
  labs(title = "Lower-Middle 7 Neighborhoods Average House Prices", y= "Average Price $")
conv %>% filter(Neighborhood %in% c("SawyerW", "Mitchel", "NAmes",   "Blueste", "NPkVill" ,"Sawyer" , "Landmrk" ))%>%
  ggplot() +geom_line(aes(x=`month(date)`, y=AvPrice, color=Neighborhood))+
  labs(title = "Lower-Middle 7 Neighborhoods Convolved House Prices", y= "Average Price $")


#Bottom 7 
low <- avdata %>% filter(Neighborhood %in% c("SWISU","Edwards" ,"OldTown", "BrkSide", "IDOTRR",  "BrDale",  "MeadowV")) %>% 
  ggplot()+geom_line(aes(x=date,y=AvPrice,color=Neighborhood)) + 
  labs(title = "Lower 7 Neighborhoods Average House Prices", y= "Average Price $")
conv %>% filter(Neighborhood %in% c("SWISU","Edwards" ,"OldTown", "BrkSide", "IDOTRR",  "BrDale",  "MeadowV"))%>%
  ggplot() +geom_line(aes(x=`month(date)`, y=AvPrice, color=Neighborhood))+
  labs(title = "Lower 7 Neighborhoods Convolved House Prices", y= "Average Price $")



(upp | umid) / (lmid | low)

##Need to do Neighborhoods Quarterly rather than monthly. 



##Need to Group By Price Bracket of House






'_______GOOD________Same Process, just for MS_SubClass instead'

data <- read_csv("../data/engineered.csv")
data <- data[-1]
#Make Tidy average data frames 
#First get neighborhood and price columns, along with sale date
data$YrSold <- gsub("Yr_","", data$YrSold) #Clean date
data <- data %>% select(YrSold, MoSold, Collapse_MSSubClass , SalePrice)

data$date <-paste(data$MoSold,sep="-", data$YrSold)
data$date <-lubridate::my(data$date)
data <- data %>% select(-c(YrSold,MoSold))

order2 <- data %>% group_by(Collapse_MSSubClass) %>% summarise_at(vars(SalePrice), list(AvPrice = mean)) %>%
  arrange(desc(AvPrice))
view(order2)

#Average over feature
cldata <- data %>% group_by(Collapse_MSSubClass, date) %>% 
  summarise_at(vars(SalePrice), list(AvPrice = mean, MedPrice = median, StDev= sd))


avdata <- cldata %>% select(-c(MedPrice,StDev))
avdata<- avdata %>% as_tsibble(key=Collapse_MSSubClass, index = date) #Avdata is tidy, tsibble


avdata %>% ggplot()+geom_line(aes(x=date,y=AvPrice,color=Collapse_MSSubClass))
conv <- data %>% group_by(month(date), Collapse_MSSubClass) %>% summarise_at(vars(SalePrice), list(AvPrice = median) )%>%
  arrange(desc(AvPrice)) #####Should I use Median or Average here? 
conv %>% ggplot() +geom_line(aes(x=`month(date)`, y=AvPrice, color=Collapse_MSSubClass))




'_______OKAY________Same Process, just for MS_Zoning instead'
'RM/RL has interesting constancy, FV has trend but High Variance'

data <- read_csv("../data/engineered.csv")
data <- data[-1]
#Make Tidy average data frames 
#First get neighborhood and price columns, along with sale date
data$YrSold <- gsub("Yr_","", data$YrSold) #Clean date
data <- data %>% select(YrSold, MoSold, MSZoning , SalePrice)
data$MSZoning <- as.factor(data$MSZoning)
data$date <-paste(data$MoSold,sep="-", data$YrSold)
data$date <-lubridate::my(data$date)
data <- data %>% select(-c(YrSold,MoSold))

order2 <- data %>% group_by(MSZoning) %>% summarise_at(vars(SalePrice), list(AvPrice = mean)) %>%
  arrange(desc(AvPrice))
view(order2)

#Average over feature
cldata <- data %>% group_by(MSZoning, date) %>% 
  summarise_at(vars(SalePrice), list(AvPrice = mean, MedPrice = median, StDev= sd))


avdata <- cldata %>% select(-c(MedPrice,StDev))
avdata<- avdata %>% as_tsibble(key=MS_Zoning, index = date) #Avdata is tidy, tsibble


avdata %>% ggplot()+geom_line(aes(x=date,y=AvPrice,color=MSZoning))
conv <- data %>% group_by(month(date), MSZoning) %>% summarise_at(vars(SalePrice), list(AvPrice = median) )%>%
  arrange(desc(AvPrice)) #####Should I use Median or Average here? 
conv %>% ggplot() +geom_line(aes(x=`month(date)`, y=AvPrice, color=MSZoning))



'______GREAT_________Same Process, just for Wealth_Bracket instead'
"Look at the variance in the top quartile data"

data <- read_csv("../data/engineered.csv")
data <- data[-1]

data <- data %>% mutate(quartile = ntile(SalePrice,4))
data <- data %>% select(DateSold, quartile , SalePrice)
data$quartile <- as.factor(data$quartile)
#this should be obvious
order3 <- data %>% group_by(quartile) %>% summarise_at(vars(SalePrice), list(AvPrice = mean)) %>%
  arrange(desc(AvPrice))
view(order3)

#Average over feature
cldata <- data %>% group_by(quartile, DateSold) %>% 
  summarise_at(vars(SalePrice), list(AvPrice = mean, MedPrice = median, StDev= sd))
avdata <- cldata %>% select(-c(MedPrice,StDev))

avdata<- avdata %>% as_tsibble(key=quartile, index = DateSold) #Avdata is tidy, tsibble
avdata %>% ggplot()+geom_line(aes(x=DateSold,y=AvPrice,color=quartile))
conv <- data %>% group_by(month(DateSold), quartile) %>% summarise_at(vars(SalePrice), list(AvPrice = median) )%>%
  arrange(desc(AvPrice)) #####Should I use Median or Average here? 
conv %>% ggplot() +geom_line(aes(x=`month(DateSold)`, y=AvPrice, color=quartile))





'_______OKAY________Same Process, just for LotShape instead'
'lotshape 2 and 3 have the most stable patterns'

data <- read_csv("../data/engineered.csv")
data <- data[-1]
#Make Tidy average data frames 
#First get neighborhood and price columns, along with sale date
data <- data %>% select(DateSold, LotShape , SalePrice)
data$LotShape <- as.factor(data$LotShape)


order4 <- data %>% group_by(LotShape) %>% summarise_at(vars(SalePrice), list(AvPrice = mean)) %>%
  arrange(desc(AvPrice))
view(order4)

cldata <- data %>% group_by(LotShape, DateSold) %>% 
  summarise_at(vars(SalePrice), list(AvPrice = mean, MedPrice = median, StDev= sd))
avdata <- cldata %>% select(-c(MedPrice,StDev))

avdata<- avdata %>% as_tsibble(key=LotShape, index = DateSold) #Avdata is tidy, tsibble
avdata %>% ggplot()+geom_line(aes(x=DateSold,y=AvPrice,color=LotShape))
conv <- data %>% group_by(month(DateSold), LotShape) %>% summarise_at(vars(SalePrice), list(AvPrice = median) )%>%
  arrange(desc(AvPrice)) #####Should I use Median or Average here? 
conv %>% ggplot() +geom_line(aes(x=`month(DateSold)`, y=AvPrice, color=LotShape))




'______OKAY_________Same Process, just for BldgType instead'
'1fam duplex are most stable'
data <- read_csv("../data/engineered.csv")
data <- data[-1]
#Make Tidy average data frames 
#First get neighborhood and price columns, along with sale date
data <- data %>% select(DateSold, BldgType , SalePrice)
data$BldgType <- as.factor(data$BldgType)
order5 <- data %>% group_by(BldgType) %>% summarise_at(vars(SalePrice), list(AvPrice = mean)) %>%
  arrange(desc(AvPrice))
view(order5)
cldata <- data %>% group_by(BldgType, DateSold) %>% 
  summarise_at(vars(SalePrice), list(AvPrice = mean, MedPrice = median, StDev= sd))
avdata <- cldata %>% select(-c(MedPrice,StDev))
avdata<- avdata %>% as_tsibble(key=BldgType, index = DateSold) #Avdata is tidy, tsibble
avdata %>% ggplot()+geom_line(aes(x=DateSold,y=AvPrice,color=BldgType))
conv <- data %>% group_by(month(DateSold), BldgType) %>% summarise_at(vars(SalePrice), list(AvPrice = median) )%>%
  arrange(desc(AvPrice)) #####Should I use Median or Average here? 
conv %>% ggplot() +geom_line(aes(x=`month(DateSold)`, y=AvPrice, color=BldgType))




'_______OKAY________Same Process, just for OverallQual instead'
"Higher the Qual, Higher the Variance generally, "
data <- read_csv("../data/engineered.csv")
data <- data[-1]
#Make Tidy average data frames 
#First get neighborhood and price columns, along with sale date
data <- data %>% select(DateSold, OverallQual , SalePrice)
data$OverallQual <- as.factor(data$OverallQual)
order6 <- data %>% group_by(OverallQual) %>% summarise_at(vars(SalePrice), list(AvPrice = mean)) %>%
  arrange(desc(AvPrice))
view(order6)
cldata <- data %>% group_by(OverallQual, DateSold) %>% 
  summarise_at(vars(SalePrice), list(AvPrice = mean, MedPrice = median, StDev= sd))
avdata <- cldata %>% select(-c(MedPrice,StDev))
avdata<- avdata %>% as_tsibble(key=OverallQual, index = DateSold) #Avdata is tidy, tsibble
avdata %>% ggplot()+geom_line(aes(x=DateSold,y=AvPrice,color=OverallQual))
conv <- data %>% group_by(month(DateSold), OverallQual) %>% summarise_at(vars(SalePrice), list(AvPrice = median) )%>%
  arrange(desc(AvPrice)) #####Should I use Median or Average here? 
conv %>% ggplot() +geom_line(aes(x=`month(DateSold)`, y=AvPrice, color=OverallQual))





'______Not Bad_________Same Process, just for OverallCond instead'
'Less of a split between ranks as there was with quality'
'very odd behavior with high condition houses over time, price seems to drop'
data <- read_csv("../data/engineered.csv")
data <- data[-1]
#Make Tidy average data frames 
#First get neighborhood and price columns, along with sale date
data <- data %>% select(DateSold, OverallCond , SalePrice)
data$OverallCond <- as.factor(data$OverallCond)
order7 <- data %>% group_by(OverallCond) %>% summarise_at(vars(SalePrice), list(AvPrice = mean)) %>%
  arrange(desc(AvPrice))
view(order7)
cldata <- data %>% group_by(OverallCond, DateSold) %>% 
  summarise_at(vars(SalePrice), list(AvPrice = mean, MedPrice = median, StDev= sd))
avdata <- cldata %>% select(-c(MedPrice,StDev))
avdata<- avdata %>% as_tsibble(key=OverallCond, index = DateSold) #Avdata is tidy, tsibble
avdata %>% ggplot()+geom_line(aes(x=DateSold,y=AvPrice,color=OverallCond))
conv <- data %>% group_by(month(DateSold), OverallCond) %>% summarise_at(vars(SalePrice), list(AvPrice = median) )%>%
  arrange(desc(AvPrice)) #####Should I use Median or Average here? 
conv %>% ggplot() +geom_line(aes(x=`month(DateSold)`, y=AvPrice, color=OverallCond))







'_____GOOD__________Same Process, just for Foundation  instead'
"Pconc, cblock, brktil most stable with some exceptions"
data <- read_csv("../data/engineered.csv")
data <- data[-1]
#Make Tidy average data frames 
#First get neighborhood and price columns, along with sale date
data <- data %>% select(DateSold, Foundation , SalePrice)
data$Foundation <- as.factor(data$Foundation)
order8 <- data %>% group_by(Foundation) %>% summarise_at(vars(SalePrice), list(AvPrice = mean)) %>%
  arrange(desc(AvPrice))
view(order8)
cldata <- data %>% group_by(Foundation, DateSold) %>% 
  summarise_at(vars(SalePrice), list(AvPrice = mean, MedPrice = median, StDev= sd))
avdata <- cldata %>% select(-c(MedPrice,StDev))
avdata<- avdata %>% as_tsibble(key=Foundation, index = DateSold) #Avdata is tidy, tsibble
avdata %>% ggplot()+geom_line(aes(x=DateSold,y=AvPrice,color=Foundation))
conv <- data %>% group_by(month(DateSold), Foundation) %>% summarise_at(vars(SalePrice), list(AvPrice = median) )%>%
  arrange(desc(AvPrice)) #####Should I use Median or Average here? 
conv %>% ggplot() +geom_line(aes(x=`month(DateSold)`, y=AvPrice, color=Foundation))









'_______Not Great________Same Process, just for GarageType  instead'
"high variance for built in garages, attatched is nice to predict though"
data <- read_csv("../data/engineered.csv")
data <- data[-1]
#Make Tidy average data frames 
#First get neighborhood and price columns, along with sale date
data <- data %>% select(DateSold, GarageType , SalePrice)
data$GarageType <- as.factor(data$GarageType)
order8 <- data %>% group_by(GarageType) %>% summarise_at(vars(SalePrice), list(AvPrice = mean)) %>%
  arrange(desc(AvPrice))
view(order8)
cldata <- data %>% group_by(GarageType, DateSold) %>% 
  summarise_at(vars(SalePrice), list(AvPrice = mean, MedPrice = median, StDev= sd))
avdata <- cldata %>% select(-c(MedPrice,StDev))
avdata<- avdata %>% as_tsibble(key=GarageType, index = DateSold) #Avdata is tidy, tsibble
avdata %>% ggplot()+geom_line(aes(x=DateSold,y=AvPrice,color=GarageType))
conv <- data %>% group_by(month(DateSold), GarageType) %>% summarise_at(vars(SalePrice), list(AvPrice = median) )%>%
  arrange(desc(AvPrice)) #####Should I use Median or Average here? 
conv %>% ggplot() +geom_line(aes(x=`month(DateSold)`, y=AvPrice, color=GarageType))







'_______Not Good________Same Process, just for Fence  instead'
"Wayyy too much variance"
data <- read_csv("../data/engineered.csv")
data <- data[-1]
#Make Tidy average data frames 
#First get neighborhood and price columns, along with sale date
data <- data %>% select(DateSold, Fence , SalePrice)
data$Fence <- as.factor(data$Fence)
order9 <- data %>% group_by(Fence) %>% summarise_at(vars(SalePrice), list(AvPrice = mean)) %>%
  arrange(desc(AvPrice))
view(order9)
cldata <- data %>% group_by(Fence, DateSold) %>% 
  summarise_at(vars(SalePrice), list(AvPrice = mean, MedPrice = median, StDev= sd))
avdata <- cldata %>% select(-c(MedPrice,StDev))
avdata<- avdata %>% as_tsibble(key=Fence, index = DateSold) #Avdata is tidy, tsibble
avdata %>% ggplot()+geom_line(aes(x=DateSold,y=AvPrice,color=Fence))
conv <- data %>% group_by(month(DateSold), Fence) %>% summarise_at(vars(SalePrice), list(AvPrice = median) )%>%
  arrange(desc(AvPrice)) #####Should I use Median or Average here? 
conv %>% ggplot() +geom_line(aes(x=`month(DateSold)`, y=AvPrice, color=Fence))








'______okay_________Same Process, just for MiscFeature  instead'
'No Misc and Shed seem like most common but high variance'
data <- read_csv("../data/engineered.csv")
data <- data[-1]
#Make Tidy average data frames 
#First get neighborhood and price columns, along with sale date
data <- data %>% select(DateSold, MiscFeature , SalePrice)
data$MiscFeature <- as.factor(data$MiscFeature)
order10 <- data %>% group_by(MiscFeature) %>% summarise_at(vars(SalePrice), list(AvPrice = mean)) %>%
  arrange(desc(AvPrice))
view(order10)
cldata <- data %>% group_by(MiscFeature, DateSold) %>% 
  summarise_at(vars(SalePrice), list(AvPrice = mean, MedPrice = median, StDev= sd))
avdata <- cldata %>% select(-c(MedPrice,StDev))
avdata<- avdata %>% as_tsibble(key=MiscFeature, index = DateSold) #Avdata is tidy, tsibble
avdata %>% ggplot()+geom_line(aes(x=DateSold,y=AvPrice,color=MiscFeature))
conv <- data %>% group_by(month(DateSold), MiscFeature) %>% summarise_at(vars(SalePrice), list(AvPrice = median) )%>%
  arrange(desc(AvPrice)) #####Should I use Median or Average here? 
conv %>% ggplot() +geom_line(aes(x=`month(DateSold)`, y=AvPrice, color=MiscFeature))










'_______compiled is good, shows seasons________Same Process, just for IsRenovated  instead'
"Otherwise not very good--high variance"
data <- read_csv("../data/engineered.csv")
data <- data[-1]
#Make Tidy average data frames 
#First get neighborhood and price columns, along with sale date
data <- data %>% select(DateSold, IsRenovated , SalePrice)
data$IsRenovated <- as.factor(data$IsRenovated)
order11 <- data %>% group_by(IsRenovated) %>% summarise_at(vars(SalePrice), list(AvPrice = mean)) %>%
  arrange(desc(AvPrice))
view(order11)
cldata <- data %>% group_by(IsRenovated, DateSold) %>% 
  summarise_at(vars(SalePrice), list(AvPrice = mean, MedPrice = median, StDev= sd))
avdata <- cldata %>% select(-c(MedPrice,StDev))
avdata<- avdata %>% as_tsibble(key=IsRenovated, index = DateSold) #Avdata is tidy, tsibble
avdata %>% ggplot()+geom_line(aes(x=DateSold,y=AvPrice,color=IsRenovated))
conv <- data %>% group_by(month(DateSold), IsRenovated) %>% summarise_at(vars(SalePrice), list(AvPrice = median) )%>%
  arrange(desc(AvPrice)) #####Should I use Median or Average here? 
conv %>% ggplot() +geom_line(aes(x=`month(DateSold)`, y=AvPrice, color=IsRenovated))










'_______compiled is GOOD, shows seasons________Same Process, just for district  instead'
"Otherwise not very good--high variance" 
"Something insteresting at month10--OCT, and 9-10 Sept--Price is very high then very low" 


data <- read_csv("../data/engineered.csv")
data <- data[-1]
#Make Tidy average data frames 
#First get neighborhood and price columns, along with sale date
data <- data %>% select(DateSold, district , SalePrice)
data$district <- as.factor(data$district)
order11 <- data %>% group_by(district) %>% summarise_at(vars(SalePrice), list(AvPrice = mean)) %>%
  arrange(desc(AvPrice))
view(order11)
cldata <- data %>% group_by(district, DateSold) %>% 
  summarise_at(vars(SalePrice), list(AvPrice = mean, MedPrice = median, StDev= sd))
avdata <- cldata %>% select(-c(MedPrice,StDev))
avdata<- avdata %>% as_tsibble(key=district, index = DateSold) #Avdata is tidy, tsibble
avdata %>% ggplot()+geom_line(aes(x=DateSold,y=AvPrice,color=district))
conv <- data %>% group_by(month(DateSold), district) %>% summarise_at(vars(SalePrice), list(AvPrice = median) )%>%
  arrange(desc(AvPrice)) #####Should I use Median or Average here? 
conv %>% ggplot() +geom_line(aes(x=`month(DateSold)`, y=AvPrice, color=district))

