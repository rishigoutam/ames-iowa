library(tidyverse)
library(ggcorrplot)
library(gtools)
library(lubridate)
library(fpp3)
library(feasts)
library(patchwork)
library(slider)
library(seasonal)

#Predictions by Subclass

'_______GOOD________Same Process, just for MS_SubClass instead'

data <- read_csv("../data/engineered.csv")
data <- data[-1]
#Make Tidy average data frames 
#First get neighborhood and price columns, along with sale date



#date manip 
data$date <- yearmonth(data$DateSold)
data <- data %>% select(district, date, Collapse_MSSubClass , SalePrice)

#Ordering
order2 <- data %>% group_by(Collapse_MSSubClass) %>% summarise_at(vars(SalePrice), list(AvPrice = mean)) %>%
  arrange(desc(AvPrice))

#Average over feature
cldata <- data %>% group_by(Collapse_MSSubClass, date) %>% 
  summarise_at(vars(SalePrice), list(AvPrice = mean, MedPrice = median, StDev= sd))
avdata <- cldata %>% select(-c(MedPrice,StDev))
purav <- avdata
avdata<- avdata %>% as_tsibble(key=Collapse_MSSubClass, index = date) #Avdata is tidy, tsibble
odata <- data %>% as_tsibble(key=Collapse_MSSubClass, index= date)


#Time-Series Analysis
#______________________________________Basic Plotting
avdata %>% autoplot()
purav %>% ungroup() %>% select(AvPrice) %>% ts() %>% plot.ts()
purav %>% ungroup() %>% select(AvPrice) %>% ts() %>% acf2()
#No need to log-transform, doesn't seem like variance is increasing over time

#We Need to Do some dIfferencing 
purav %>%  ungroup() %>% select(AvPrice) %>% ts() %>% diff(1) %>% acf2()
purav %>%  ungroup() %>% select(AvPrice) %>% ts() %>% diff(1) %>% plot.ts() 
#double differencing introduces too much negative residue in PACF
purav %>%  ungroup() %>% select(AvPrice) %>% ts() %>% diff(1) %>%  diff(1) %>% acf2()



#for Trad 
purav %>% ungroup() %>% filter(Collapse_MSSubClass == "Traditional") %>% select(AvPrice) %>% ts() %>% plot.ts()
purav %>% ungroup() %>% filter(Collapse_MSSubClass == "Traditional") %>% select(AvPrice) %>% ts() %>% acf2()
purav %>% ungroup() %>% filter(Collapse_MSSubClass == "Traditional") %>% select(AvPrice) %>% ts() %>% diff(1) %>% plot.ts()
purav %>%  ungroup() %>% filter(Collapse_MSSubClass == "Traditional") %>% select(AvPrice) %>% ts() %>% diff(1) %>% acf2()
purav %>%  ungroup() %>% filter(Collapse_MSSubClass == "Traditional") %>%
  select(AvPrice) %>%
  ts() %>%
  diff(1) %>% diff(1) %>% #More neg residue added, double diff is overkill
  acf2()






#Ljung-Box Tests
pa.d <- purav %>%  ungroup() %>% select(AvPrice) %>% ts() %>% diff(1) 
pa.d %>% Box.test(type="Ljung-Box", lag = log(nrow(pa.d)))
trad.d <- purav %>%  ungroup() %>% filter(Collapse_MSSubClass == "Traditional") %>% select(AvPrice) %>% ts() %>% diff(1)
trad.d %>% Box.test(type="Ljung-Box", lag = log(nrow(trad.d)))




















#Finding Best Models--- look at result of Model, to see STL decomposition
#STL MODELING (Simple Additive)
avdata %>% autoplot()
ACF(tsibble::fill_gaps(avdata), var = AvPrice, lag_max = 48) %>% autoplot() + labs(title= "4year lag")
ACF(tsibble::fill_gaps(avdata), var = AvPrice, lag_max = 12) %>% autoplot() + labs(title = "1 year lag")
#Traditional is most like white noise. 

d1 <- tsibble::fill_gaps(avdata) %>% filter(Collapse_MSSubClass =='Duplex') %>% 
  model(stl = STL(AvPrice))
d2<- tsibble::fill_gaps(avdata) %>% filter(Collapse_MSSubClass =='Split') %>% 
  model(stl = STL(AvPrice))
dcmp<-tsibble::fill_gaps(avdata) %>% filter(Collapse_MSSubClass =='Traditional') %>% 
  model(stl = STL(AvPrice))
components(d1) #Null Model
components(d2) #Null Model
components(dcmp) #Real Model 

components(dcmp)  %>% as_tsibble() %>%
  autoplot(AvPrice, color ="gray") +
  geom_line(aes(y=trend),color='red')

components(dcmp)  %>% as_tsibble() %>%
  autoplot(AvPrice, color ="gray") +
  geom_line(aes(y=season_adjust),color='red')




components(dcmp) %>% autoplot()



#5 Month Moving Average Plot, and 2nd Order Moving Average
tradhouse <- avdata %>%
  filter(Collapse_MSSubClass == "Traditional") %>%
  mutate(
    `5-MA` = slider::slide_dbl(AvPrice, mean,
                               .before = 2, .after = 2, .complete = TRUE), 
    
    `2x5-MA` = slider::slide_dbl(`5-MA`, mean,
                                 .before = 2, .after = 2, .complete = TRUE)
  )

tradhouse %>% as_tsibble() %>% 
  autoplot(AvPrice, color='gray') + 
  geom_line(aes(y = `5-MA`), color ='blue') +
  geom_line(aes(y = `2x5-MA`), colour = "red")


#SEATS model decomposition 
seats_dcmp <- tsibble::fill_gaps(avdata) %>% 
  model(seats = X_13ARIMA_SEATS(AvPrice ~ seats())) %>%
  components()
autoplot(seats_dcmp)

#Statistics and Feature Autocorrelations
tsibble::fill_gaps(avdata) %>% features(AvPrice, mean)
tsibble::fill_gaps(avdata) %>% features(AvPrice, quantile)
tsibble::fill_gaps(avdata) %>% features(AvPrice, feat_acf)
tsibble::fill_gaps(avdata) %>% features(AvPrice, feat_stl)
#Series is not periodic error for split 




##Modelling and Fitting--
#____________________________________Random Walk Model (drift)
fit <- tsibble::fill_gaps(avdata) %>%
  model(seats = RW(AvPrice ~ drift()))

fit %>% forecast(h= "5 months") %>%
  autoplot(tsibble::fill_gaps(avdata))


fit_t <- tsibble::fill_gaps(avdata) %>% 
  filter(Collapse_MSSubClass == "Traditional") %>%
  model(seats = RW(AvPrice ~ drift()))

fit %>% gg_tsresiduals() +labs(title = "Residual Analysis for Traditional")


fit <- tsibble::fill_gaps(avdata) %>% 
  filter(Collapse_MSSubClass == "Split") %>%
  model(seats = RW(AvPrice ~ drift()))

fit %>% gg_tsresiduals() +labs(title = "Residual Analysis for Split")



fit <- tsibble::fill_gaps(avdata) %>% 
  filter(Collapse_MSSubClass == "Duplex") %>%
  model(seats = RW(AvPrice ~ drift()))

fit %>% gg_tsresiduals() +labs(title = "Residual Analysis for Duplex")

fc <- fit_t %>% forecast(h = 35, bootstrap = TRUE)
autoplot(fc, tsibble::fill_gaps(avdata)) +labs(title="Drift Bootstrap Forecast")






















