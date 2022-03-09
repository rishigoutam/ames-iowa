library(tidyverse)
library(ggcorrplot)
library(gtools)
library(lubridate)
library(fpp3)
library(feasts)
library(patchwork)
library(slider)
library(seasonal)
library(forecast)
library(astsa)
library(tsdl)



#Predictions by house quintile

'______GREAT_________Same Process, just for Wealth_Bracket instead'
"Look at the variance in the top quartile data"

data <- read_csv("../data/engineered.csv")
data <- data[-1]

data$date <- yearmonth(data$DateSold)
datapure<- data
data <- data %>% mutate(quartile = ntile(SalePrice,5))
data <- data %>% select(date, quartile , SalePrice)
data$quartile <- as.factor(data$quartile)
#this should be obvious
order3 <- data %>% group_by(quartile) %>% summarise_at(vars(SalePrice), list(AvPrice = mean)) %>%
  arrange(desc(AvPrice))


#Average over feature
cldata <- data %>% group_by(quartile, date) %>% 
  summarise_at(vars(SalePrice), list(AvPrice = mean, MedPrice = median, StDev= sd))
purdata<- datapure %>% group_by(date)  %>% 
  summarise_at(vars(SalePrice), list(AvPrice = mean, MedPrice = median, StDev= sd))
purav <- purdata %>% select(-c(MedPrice,StDev))
pur.ts <- purav
avdata <- cldata %>% select(-c(MedPrice,StDev))
av.ts <- avdata
avdata<- avdata %>% as_tsibble(key=quartile, index = date) #Avdata is tidy, tsibble





#______________________________________________Basic Plotting

avdata %>% autoplot()
purav %>% as_tsibble(index= date) %>% autoplot() #plotting total together 
plot.ts(av.ts) #This doesnt work multivariate as expected
purav %>% ungroup() %>% select(AvPrice) %>% ts() %>% plot.ts()
acf(av.ts) 

#_________________________________________________________MA(q) Analysis
#ACF Check using the method taught in class--checks out, No significant Lags for any... 
p.ts <- pur.ts
o.ts <- one.ts
t.ts <- two.ts
th.ts <- three.ts
fo.ts <- four.ts
fi.ts <- five.ts
pur.ts <- pur.ts %>% ungroup() %>% select(AvPrice) 
one.ts <- av.ts %>% filter(quartile == "1") %>% ungroup() %>% select(AvPrice)
two.ts <- av.ts %>% filter(quartile == "2") %>% ungroup() %>% select(AvPrice)
three.ts <- av.ts %>% filter(quartile == "3") %>% ungroup() %>% select( AvPrice)
four.ts <- av.ts %>% filter(quartile == "4") %>% ungroup() %>% select(AvPrice)
five.ts <- av.ts %>% filter(quartile == "5") %>% ungroup() %>% select(AvPrice)

pur.ts %>% ts() %>% plot.ts() #Plotting totals again
pur.ts %>% ts() %>% acf() 
pur.ts %>% ts() %>% acf2()
one.ts %>% ts() %>% plot.ts()
one.ts %>% acf() 
two.ts %>% ts() %>% plot.ts()
two.ts %>% acf() 
three.ts %>% ts() %>% plot.ts()
three.ts %>% acf() 
four.ts %>% ts() %>% plot.ts()
four.ts %>% acf()  #So this has a significant lag--so its an MA(1)?
five.ts %>% ts() %>% plot.ts()
five.ts %>% acf() 

  #Does this mean that these are MA(1) for four.ts alone, the rest are MA(0) models? 
#***Autocorrelation using fpp3
one <-tsibble::fill_gaps(avdata) %>% filter(quartile == "1")
ACF(tsibble::fill_gaps(avdata), var = AvPrice, lag_max = 48) %>% autoplot() + labs(title= "4year lag")
ACF(tsibble::fill_gaps(avdata), var = AvPrice, lag_max = 12) %>% autoplot() + labs(title = "1 year lag")
#Question for Sam: Are these the same plots as the Ones in class? 


#________________________________________AR(p) Analysis 
#****using fpp3
PACF(tsibble::fill_gaps(avdata), var = AvPrice, lag_max = 48) %>% autoplot() + labs(title= "4year lag")
PACF(tsibble::fill_gaps(avdata), var = AvPrice, lag_max = 12) %>% autoplot() + labs(title = "1 year lag")
PACF(tsibble::fill_gaps(avdata), var = AvPrice, lag_max = 4) %>% autoplot() + labs(title = "1/4 yr lag")

pur.ts %>% acf(type='partial')
one.ts %>% acf(type="partial") 
two.ts %>% acf(type="partial") 
three.ts %>% acf(type="partial") 
four.ts %>% acf(type="partial")  
five.ts %>% acf(type="partial") 
#No significant Lags Here 


#__________________________________________________I, or Diff analysis 
purdiff<- diff(ts(p.ts),1)
purdiff %>% ts() %>% plot.ts()
purrdiff <- diff(purdiff,1)
purrdiff %>% ts() %>% plot.ts() 
diff(purrdiff,1) %>% as.data.frame() %>% ungroup() %>% select(AvPrice)  %>% ts()%>% acf2()

#Why does differencing INTRODUCE MA(q) and AR(p) features?????

odiff<- diff(ts(o.ts),1)
odiff %>% ts() %>% plot.ts()
oodiff <- diff(odiff,1)
oodiff %>% ts() %>% plot.ts()
diff(oodiff,1) %>% as.data.frame() %>% ungroup() %>% select(AvPrice)  %>% ts()%>% acf2()


t.ts %>% as.data.frame() %>% ungroup() %>% select(AvPrice) %>% ts() %>% acf2()
tdiff<- diff(ts(t.ts),1)
tdiff %>% ts() %>% plot.ts()
ttdiff <- diff(tdiff,1)
ttdiff %>% ts() %>% plot.ts()
diff(ttdiff,1) %>% as.data.frame() %>% ungroup() %>% select(AvPrice)  %>% ts()%>% acf2()

thdiff<- diff(ts(th.ts),1)
thdiff %>% ts() %>% plot.ts()
thhdiff <- diff(thdiff,1)
thhdiff %>% ts() %>% plot.ts()
diff(thdiff,1) %>% as.data.frame() %>% ungroup() %>% select(AvPrice)  %>% ts()%>% acf2()
#Looks better double differenced

fodiff<- diff(ts(fo.ts),1)
fodiff %>% ts() %>% plot.ts()
foodiff <- diff(fodiff,1)
foodiff %>% ts() %>% plot.ts()
diff(foodiff,1) %>% as.data.frame() %>% ungroup() %>% select(AvPrice)  %>% ts()%>% acf2()
#looks better double differenced

fidiff<- diff(ts(fi.ts),1)
fidiff %>% ts() %>% plot.ts()
fiidiff <- diff(fidiff,1)
fiidiff %>% ts() %>% plot.ts()
diff(fiidiff,1) %>% ts() %>% plot.ts() 
fiidiff %>% as.data.frame() %>% ungroup() %>% select(AvPrice)  %>% ts()%>% acf2()
#double differenced is better 
#Strangely, differencing takes us further away from the stationarity assumption, not closer to it. 


#________________________________________ARIMA 
#it looks like 0,0,0 ARIMA model will be best, as a white noise model. 
#However, for the sake of clarity, lets attempt a 2,2,2 model space--
#If our 0,0,0 guess is actually correct, and is the most highly effecient model,
#this result will be captured by the AIC complexity. 
#Furthermore, we will now perform the Ljung-Box Test in order to see if all our models
#truly are the white noise distribution which would be pretty crazy. 


#Differencing? 

#Ljung-Box Test---We want to reject NH (), looking for p< .05
Box.test(pur.ts,type="Ljung-Box", lag= log(nrow(pur.ts))) # p = .99
Box.test(o.ts,type="Ljung-Box", lag= log(nrow(o.ts))) # p =.14
Box.test(t.ts,type="Ljung-Box", lag= log(nrow(t.ts))) # p = .34
Box.test(th.ts,type="Ljung-Box", lag= log(nrow(th.ts))) # p = .94
Box.test(fo.ts,type="Ljung-Box", lag= log(nrow(fo.ts))) # p = .33
Box.test(fi.ts,type="Ljung-Box", lag= log(nrow(fi.ts))) # p = .31

#So just as we imagined---the average prices of homes follow the white noise distribution,
# and are perfectly stationary over time. 




































































  #***Doesn't look like there's much seasonality for any of these
one <-tsibble::fill_gaps(avdata) %>% filter(quartile == "1")
two <-tsibble::fill_gaps(avdata) %>% filter(quartile == "2") %>% drop_na()
three <-tsibble::fill_gaps(avdata) %>% filter(quartile == "3")
four <-tsibble::fill_gaps(avdata) %>% filter(quartile == "4")
five <-tsibble::fill_gaps(avdata) %>% filter(quartile == "5")

mdl <- tsibble::fill_gaps(avdata) %>% model(stl = STL(AvPrice))
mdl_1 <- one %>% model(stl = STL(AvPrice))
mdl_2 <- tsibble::fill_gaps(two) %>% model(stl = STL(AvPrice)) #tried to fill gaps but it doesnt work, model still null
mdl_3 <- tsibble::fill_gaps(three) %>% model(stl = STL(AvPrice))
mdl_4 <- four %>% model(stl = STL(AvPrice))
mdl_5 <- five %>% model(stl = STL(AvPrice))
components(mdl_1) #model
components(mdl_2) #Null  (data is white noise approx around average?)
components(mdl_3) #Null  (data is white noise approx around average?)
components(mdl_4) #model
components(mdl_5)  %>% autoplot() #model



two %>% autoplot()
three %>% autoplot()

components(mdl_1)  %>% as_tsibble() %>%
  autoplot(AvPrice, color ="gray") +
  geom_line(aes(y=trend),color='red') +
  labs( title ="One")

components(mdl_4)  %>% as_tsibble() %>%
  autoplot(AvPrice, color ="gray") +
  geom_line(aes(y=trend),color='red') +
  labs( title ="Fourth")

components(mdl_5)  %>% as_tsibble() %>%
  autoplot(AvPrice, color ="gray") +
  geom_line(aes(y=trend),color='red') +
  labs( title ="Fifth")




#MA(p)
one_mu <- one %>%
  mutate(
    `5-MA` = slider::slide_dbl(AvPrice, mean,
                               .before = 2, .after = 2, .complete = TRUE), 
    
    `2x5-MA` = slider::slide_dbl(`5-MA`, mean,
                                 .before = 2, .after = 2, .complete = TRUE)
  )


four_mu  <- four %>%
  mutate(
    `5-MA` = slider::slide_dbl(AvPrice, mean,
                               .before = 2, .after = 2, .complete = TRUE), 
    
    `2x5-MA` = slider::slide_dbl(`5-MA`, mean,
                                 .before = 2, .after = 2, .complete = TRUE)
  )


five_mu <- five %>%
  mutate(
    `5-MA` = slider::slide_dbl(AvPrice, mean,
                               .before = 2, .after = 2, .complete = TRUE), 
    
    `2x5-MA` = slider::slide_dbl(`5-MA`, mean,
                                 .before = 2, .after = 2, .complete = TRUE)
  )


one_mu %>% as_tsibble() %>% 
  autoplot(AvPrice, color='gray') + 
  geom_line(aes(y = `5-MA`), color ='blue') +
  geom_line(aes(y = `2x5-MA`), colour = "red") +
  labs( title ="First")

four_mu %>% as_tsibble() %>% 
  autoplot(AvPrice, color='gray') + 
  geom_line(aes(y = `5-MA`), color ='blue') +
  geom_line(aes(y = `2x5-MA`), colour = "red") +
  labs( title ="Fourth")

five_mu %>% as_tsibble() %>% 
  autoplot(AvPrice, color='gray') + 
  geom_line(aes(y = `5-MA`), color ='blue') +
  geom_line(aes(y = `2x5-MA`), colour = "red") +
  labs( title ="Fifth")




#***SEATS didnt work out of the box, so Im not doing it here
#seats_dcmp <- tsibble::fill_gaps(avdata) %>% 
# model(seats = X_13ARIMA_SEATS(AvPrice ~ seats())) %>%
# components()
#autoplot(seats_dcmp)



#***Statistics and Feature Autocorrelations
tsibble::fill_gaps(avdata) %>% features(AvPrice, mean)
tsibble::fill_gaps(avdata) %>% features(AvPrice, quantile)
tsibble::fill_gaps(avdata) %>% features(AvPrice, feat_acf)
tsibble::fill_gaps(avdata) %>% features(AvPrice, feat_stl)


#____________________________________***Random Walk Model (drift)
fit <- tsibble::fill_gaps(avdata) %>%
  model(seats = RW(AvPrice ~ drift()))
fit %>% forecast(h= "5 months") %>%
  autoplot(tsibble::fill_gaps(avdata))
fit %>% filter(quartile == "1") %>% gg_tsresiduals() +labs(title = "Residual Analysis") +labs(title="1 Quintile")
fit %>% filter(quartile == "1") %>% gg_tsresiduals() +labs(title = "Residual Analysis") +labs(title="2 Quintile")
fit %>% filter(quartile == "1") %>% gg_tsresiduals() +labs(title = "Residual Analysis") +labs(title="3 Quintile")
fit %>% filter(quartile == "1") %>% gg_tsresiduals() +labs(title = "Residual Analysis") +labs(title="4 Quintile")
fit %>% filter(quartile == "1") %>% gg_tsresiduals() +labs(title = "Residual Analysis") +labs(title="5 Quintile")


fc <- fit_t %>% forecast(h = 35, bootstrap = TRUE)




