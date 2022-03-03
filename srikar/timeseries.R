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



#Split by neighborhood and autoplot, Ranked by Average House Price 


#NoRidge
noridge <- avdata %>% filter(Neighborhood=="NoRidge") %>% select(-c(Neighborhood))
autoplot(noridge, AvPrice) + 
  labs(title = "NoRidge Average House Prices",
       y= "Average Price $")




#NridgHt
nridght <- avdata %>% filter(Neighborhood=="NridgHt") %>% select(-c(Neighborhood))
autoplot(nridght, AvPrice) + 
  labs(title = "NridgHt Average House Prices",
       y= "Average Price $")



#StoneBr
stonebr <- avdata %>% filter(Neighborhood=="StoneBr") %>% select(-c(Neighborhood))
autoplot(stonebr, AvPrice) + 
  labs(title = "StoneBr Average House Prices",
       y= "Average Price $")




#GrnHill
grnhill <- avdata %>% filter(Neighborhood=="GrnHill") %>% select(-c(Neighborhood))
autoplot(grnhill, AvPrice) + 
  labs(title = "GrnHill Average House Prices",
       y= "Average Price $")




#Veenker
veenker <- avdata %>% filter(Neighborhood=="Veenker") %>% select(-c(Neighborhood))
autoplot(veenker, AvPrice) + 
  labs(title = "Veenker Average House Prices",
       y= "Average Price $")



#Timber

timber <- avdata %>% filter(Neighborhood=="Timber") %>% select(-c(Neighborhood))
autoplot(timber, AvPrice) + 
  labs(title = "Timber Average House Prices",
       y= "Average Price $")




#Somerst
somerst <- avdata %>% filter(Neighborhood=="Somerst") %>% select(-c(Neighborhood))
autoplot(somerst, AvPrice) + 
  labs(title = "Somerst Average House Prices",
       y= "Average Price $")




#ClearCr
clearcr <- avdata %>% filter(Neighborhood=="ClearCr") %>% select(-c(Neighborhood))
autoplot(clearcr, AvPrice) + 
  labs(title = "ClearCr Average House Prices",
       y= "Average Price $")




#Crawfor
crawfor <- avdata %>% filter(Neighborhood=="Crawfor") %>% select(-c(Neighborhood))
autoplot(crawfor, AvPrice) + 
  labs(title = "Crawfor Average House Prices",
       y= "Average Price $")




#CollgCr
collgcr <- avdata %>% filter(Neighborhood=="CollgCr") %>% select(-c(Neighborhood))
autoplot(collgcr, AvPrice) + 
  labs(title = "CollgCr Average House Prices",
       y= "Average Price $")




#Blmngtn
blmngtn <- avdata %>% filter(Neighborhood=="Blmngtn") %>% select(-c(Neighborhood))
autoplot(blmngtn, AvPrice) + 
  labs(title = "Blmngtn Average House Prices",
       y= "Average Price $")




#Greens
greens <- avdata %>% filter(Neighborhood=="Greens") %>% select(-c(Neighborhood))
autoplot(greens, AvPrice) + 
  labs(title = "Greens Average House Prices",
       y= "Average Price $")



#NWAmes
nwames <- avdata %>% filter(Neighborhood=="NWAmes") %>% select(-c(Neighborhood))
autoplot(nwames, AvPrice) + 
  labs(title = "NWAmes Average House Prices",
       y= "Average Price $")



#Gilbert
gilbert <- avdata %>% filter(Neighborhood=="Gilbert") %>% select(-c(Neighborhood))
autoplot(gilbert, AvPrice) + 
  labs(title = "Gilbert Average House Prices",
       y= "Average Price $")





#SawyerW
sawyerw <- avdata %>% filter(Neighborhood=="SawyerW") %>% select(-c(Neighborhood))
autoplot(sawyerw, AvPrice) + 
  labs(title = "SawyerW Average House Prices",
       y= "Average Price $")





#Mitchel
mitchel <- avdata %>% filter(Neighborhood=="Mitchel") %>% select(-c(Neighborhood))
autoplot(mitchel, AvPrice) + 
  labs(title = "Mitchel Average House Prices",
       y= "Average Price $")






#NAmes
names <- avdata %>% filter(Neighborhood=="NAmes") %>% select(-c(Neighborhood))
autoplot(names, AvPrice) + 
  labs(title = "NAmes Average House Prices",
       y= "Average Price $")






#Blueste
blueste <- avdata %>% filter(Neighborhood=="Blueste") %>% select(-c(Neighborhood))
autoplot(blueste, AvPrice) + 
  labs(title = "Blueste Average House Prices",
       y= "Average Price $")






#NPkVill
npkvill <- avdata %>% filter(Neighborhood=="NPkVill") %>% select(-c(Neighborhood))
autoplot(npkvill, AvPrice) + 
  labs(title = "NPkVill Average House Prices",
       y= "Average Price $")






#Sawyer
sawyer <- avdata %>% filter(Neighborhood=="Sawyer") %>% select(-c(Neighborhood))
autoplot(sawyer, AvPrice) + 
  labs(title = "Sawyer Average House Prices",
       y= "Average Price $")






#Landmrk
landmrk <- avdata %>% filter(Neighborhood=="Landmrk") %>% select(-c(Neighborhood))
autoplot(landmrk, AvPrice) + 
  labs(title = "Landmrk Average House Prices",
       y= "Average Price $")






#SWISU
swisu <- avdata %>% filter(Neighborhood=="SWISU") %>% select(-c(Neighborhood))
autoplot(swisu, AvPrice) + 
  labs(title = "Mitchel Average House Prices",
       y= "Average Price $")






#Edwards
edwards <- avdata %>% filter(Neighborhood=="Edwards") %>% select(-c(Neighborhood))
autoplot(edwards, AvPrice) + 
  labs(title = "Edwards Average House Prices",
       y= "Average Price $")






#OldTown
oldtown <- avdata %>% filter(Neighborhood=="OldTown") %>% select(-c(Neighborhood))
autoplot(oldtown, AvPrice) + 
  labs(title = "OldTown Average House Prices",
       y= "Average Price $")






#BrkSide
brkside <- avdata %>% filter(Neighborhood=="BrkSide") %>% select(-c(Neighborhood))
autoplot(brkside, AvPrice) + 
  labs(title = "BrkSide Average House Prices",
       y= "Average Price $")






#IDOTRR
idotrr <- avdata %>% filter(Neighborhood=="IDOTRR") %>% select(-c(Neighborhood))
autoplot(idotrr, AvPrice) + 
  labs(title = "IDOTRR Average House Prices",
       y= "Average Price $")






#BrDale
brdale <- avdata %>% filter(Neighborhood=="BrDale") %>% select(-c(Neighborhood))
autoplot(brdale, AvPrice) + 
  labs(title = "BrDale Average House Prices",
       y= "Average Price $")






#MeadowV
meadowv <- avdata %>% filter(Neighborhood=="MeadowV") %>% select(-c(Neighborhood))
autoplot(meadowv, AvPrice) + 
  labs(title = "MeadowV Average House Prices",
       y= "Average Price $")

