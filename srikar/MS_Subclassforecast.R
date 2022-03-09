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
purav %>% ungroup() %>% select(AvPrice) %>% ts() %>% plot.ts(main="All Data")
purav %>% ungroup() %>% select(AvPrice) %>% ts() %>% acf2(main="All Data ACF/PACF")
#No need to log-transform, doesn't seem like variance is increasing over time

#We Need to Do some dIfferencing 
purav %>%  ungroup() %>% select(AvPrice) %>% ts() %>% diff(1) %>% acf2(main="1diff ACF/PACF")
purav %>%  ungroup() %>% select(AvPrice) %>% ts() %>% diff(1) %>% plot.ts(main="1diff All Data") 
#double differencing introduces too much negative residue in PACF
purav %>%  ungroup() %>% select(AvPrice) %>% ts() %>% diff(1) %>%  diff(1) %>% acf2(main="2Diff ACF/PACF--note increased residue")



#for Trad 
purav %>% ungroup() %>% filter(Collapse_MSSubClass == "Traditional") %>% select(AvPrice) %>% ts() %>% plot.ts(main="Trad")
purav %>% ungroup() %>% filter(Collapse_MSSubClass == "Traditional") %>% select(AvPrice) %>% ts() %>% acf2(main="Trad ACF/PACF")
purav %>% ungroup() %>% filter(Collapse_MSSubClass == "Traditional") %>% select(AvPrice) %>% ts() %>% diff(1) %>% plot.ts(main="DTrad")
purav %>%  ungroup() %>% filter(Collapse_MSSubClass == "Traditional") %>% select(AvPrice) %>% ts() %>% diff(1) %>% acf2(main="DTrad ACF/PACF")
purav %>%  ungroup() %>% filter(Collapse_MSSubClass == "Traditional") %>%
  select(AvPrice) %>%
  ts() %>%
  diff(1) %>% diff(1) %>% #More neg residue added, double diff is overkill
  acf2(main="DDtrad ACF")

#for Duplex
purav %>% ungroup() %>% filter(Collapse_MSSubClass == "Duplex") %>% select(AvPrice) %>% ts() %>% plot.ts(main="Duplex")
purav %>% ungroup() %>% filter(Collapse_MSSubClass == "Duplex") %>% select(AvPrice) %>% ts() %>% acf2(main="Duplex ACF/PACF")
purav %>% ungroup() %>% filter(Collapse_MSSubClass == "Duplex") %>% select(AvPrice) %>% ts() %>% diff(1) %>% plot.ts(main="DDuplex")
purav %>%  ungroup() %>% filter(Collapse_MSSubClass == "Duplex") %>% select(AvPrice) %>% ts() %>% diff(1) %>% acf2(main="DDuplex ACF/PACF")
#One Differencing seems good here too


#For Split
purav %>% ungroup() %>% filter(Collapse_MSSubClass == "Split") %>% select(AvPrice) %>% ts() %>% plot.ts(main="Split")
purav %>% ungroup() %>% filter(Collapse_MSSubClass == "Split") %>% select(AvPrice) %>% ts() %>% acf2(main="Split ACF/PACF")
purav %>% ungroup() %>% filter(Collapse_MSSubClass == "Split") %>% select(AvPrice) %>% ts() %>% diff(1) %>% plot.ts(main="DSplit")
purav %>%  ungroup() %>% filter(Collapse_MSSubClass == "Split") %>% select(AvPrice) %>% ts() %>% diff(1) %>% acf2(main="DSplit ACF/PACF")
#looks like 1 or 0 differencing steps would be fine here, we can just go with 1 and see what the ARIMA loop tells us. 



#Ljung-Box Tests-- we want p< .05
pa.d <- purav %>%  ungroup() %>% select(AvPrice) %>% ts() %>% diff(1) 
pa.d %>% Box.test(type="Ljung-Box", lag = log(nrow(pa.d))) #p = 5.7 e-13
trad.d <- purav %>%  ungroup() %>% filter(Collapse_MSSubClass == "Traditional") %>% select(AvPrice) %>% ts() %>% diff(1)
trad.d %>% Box.test(type="Ljung-Box", lag = log(nrow(trad.d))) #p = .01
dupl.d <- purav %>% ungroup() %>% filter(Collapse_MSSubClass=="Duplex") %>% select(AvPrice) %>% ts() %>% diff(1)
dupl.d %>% Box.test(type="Ljung-Box", lag = log(nrow(dupl.d))) #p = .0004
splt.d <- purav %>% ungroup() %>% filter(Collapse_MSSubClass=="Split") %>% select(AvPrice) %>% ts() %>% diff(1)
splt.d %>% Box.test(type="Ljung-Box", lag = log(nrow(splt.d))) #p = .006

#These are all significant autocorrelations--an ARIMA model would be useful here. 


#_________________________________________________________________________ARIMA
#
# total--Arima model, MA(q), d, AR(p)
#q = 1 from ACF, p=4 from PACF, and d=1 since we differenced once
set <-purav %>%  ungroup() %>% select(AvPrice) %>% ts() 
d=1
p_max=4
q_max=1
for(p in 1:p_max){
  for(q in 1:q_max){
    if(p+q+d<=(d+q_max+p_max)){
      model <- arima(set, order=c((p-1),d,(q-1))  ) 
      pval <-Box.test(model$residuals, lag=log(length(model$residuals)))
      sse = sum(model$residuals^2)
      cat(p-1,d,q-1,'AIC: ',model$aic, 'SSE: ', sse, 'p-val: ', pval$p.value,"\n")
      
    }
  }
}

#looks like 3,1,0 model has lowest AIC but p-value isn't good (we should be accepting Null)
arima = arima(set, order =c(3,1,0))
predict = forecast(arima,h=12, level=80)
autoplot(predict, main ="ARIMA(3,1,0) Prediction on Total Sales", ylab="Average Price ($)")


#Not a great model



#Traditional ARIMA model 
#q = 1, p= 2, d =1
#

set <-purav %>%  ungroup() %>% filter(Collapse_MSSubClass == "Traditional") %>%select(AvPrice) %>% ts() 
d=1
p_max=2
q_max=1
for(p in 1:p_max){
  for(q in 1:q_max){
    if(p+q+d<=(d+q_max+p_max)){
      model <- arima(set, order=c((p-1),d,(q-1))  ) 
      pval <-Box.test(model$residuals, lag=log(length(model$residuals)))
      sse = sum(model$residuals^2)
      cat(p-1,d,q-1,'AIC: ',model$aic, 'SSE: ', sse, 'p-val: ', pval$p.value,"\n")
      
    }
  }
}
#110 is a good model, with high p-value and low aic
arima = arima(set, order =c(1,1,0))
predict = forecast(arima,h=12, level=80)
autoplot(predict, main ="ARIMA(1,1,0) Prediction on Traditional Sales", ylab="Average Price ($)")

#Duplex ARIMA model
#q = 1, p=1, d=1
#
set <-purav %>%  ungroup() %>% filter(Collapse_MSSubClass == "Duplex") %>%select(AvPrice) %>% ts() 
d=2
p_max=2
q_max=2
for(p in 1:p_max){
  for(q in 1:q_max){
    if(p+q+d<=(d+q_max+p_max)){
      model <- arima(set, order=c((p-1),d,(q-1))  ) 
      pval <-Box.test(model$residuals, lag=log(length(model$residuals)))
      sse = sum(model$residuals^2)
      cat(p-1,d,q-1,'AIC: ',model$aic, 'SSE: ', sse, 'p-val: ', pval$p.value,"\n")
      
    }
  }
}
#looks like 121 is best
arima = arima(set, order =c(1,2,1))
predict = forecast(arima,h=12, level=80)
autoplot(predict, main ="ARIMA(1,2,1) Prediction on Duplex Sales", ylab="Average Price ($)")


#Split ARIMA model 
#q=1, p=1, d=1 
set <-purav %>%  ungroup() %>% filter(Collapse_MSSubClass == "Split") %>%select(AvPrice) %>% ts() 
d=2
p_max=2
q_max=2
for(p in 1:p_max){
  for(q in 1:q_max){
    if(p+q+d<=(d+q_max+p_max)){
      model <- arima(set, order=c((p-1),d,(q-1))  ) 
      pval <-Box.test(model$residuals, lag=log(length(model$residuals)))
      sse = sum(model$residuals^2)
      cat(p-1,d,q-1,'AIC: ',model$aic, 'SSE: ', sse, 'p-val: ', pval$p.value,"\n")
      
    }
  }
}


arima = arima(set, order =c(1,2,1))
predict = forecast(arima,h=12, level=80)
autoplot(predict, main ="ARIMA(3,1,0) Prediction on Split Sales", ylab="Average Price ($)")











#__________________________________________________________________________________







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






















