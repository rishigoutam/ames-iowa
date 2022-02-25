library(tidyverse)

#LOAD DATASETS
ames <- read_csv("../data/Ames_Housing_Price_Data.csv")
ames <- ames[-1] #useless column removed

#HVAC
hvac <- ames %>% select(PID, SalePrice, Heating, HeatingQC, CentralAir,
                            Electrical, Fireplaces, FireplaceQu)
hvac$HeatingQC <- as.factor(hvac$HeatingQC) %>% 
  fct_relevel(c("Ex","Gd","TA","Fa", "Po")) #convert quality into factor
hvac$FireplaceQu <- as.factor(hvac$FireplaceQu) %>% 
  fct_relevel(c("Ex","Gd","TA","Fa", "Po")) #convert quality into factor
hvac$Fireplaces <-as.factor(hvac$Fireplaces) %>% fct_relevel(c('4','3','2','1','0'))

prop.table(table(hvac$Heating, hvac$HeatingQC))
prop.table(table(hvac$Heating))

hvac %>% ggplot() + geom_boxplot(aes(x=Heating, y=SalePrice, color=Heating))+ 
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=Heating, y=SalePrice, color=Heating, alpha=.3))
#grouping by heating doesnt give much since GasA is overwhelmingly popular
#conclusion is to ignore this feature

hvac %>% ggplot() + geom_boxplot(aes(x=HeatingQC, y=SalePrice, color=HeatingQC)) + 
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=HeatingQC, y=SalePrice, color=HeatingQC, alpha=.3))
#heating Quality follows a pattern we expect--need to do p-test
#two sample p testt on gd,ta and ta,fa

hvac %>% ggplot() + geom_boxplot(aes(x=CentralAir, y=SalePrice, color=CentralAir)) +
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=CentralAir, y=SalePrice, color=CentralAir, alpha=.3))
#homes with central heating are more expensive on average--need to do p-test

hvac %>% ggplot() + geom_boxplot(aes(x=Electrical, y=SalePrice, color=Electrical)) +
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=Electrical, y=SalePrice, color=Electrical, alpha=.3))
prop.table(table(hvac$Electrical))
#Not clear what to read from this

prop.table(table(hvac$Fireplaces,hvac$FireplaceQu))
prop.table(table(hvac$Fireplaces))
c(1241,1132,195,11,1)
hvac %>% ggplot() + geom_boxplot(aes(x=Fireplaces, y=SalePrice, color=Fireplaces)) +
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=Fireplaces, y=SalePrice, color=Fireplaces, alpha=.3))

#As we expect, price goes up with #of fireplaces but 2 and 1 has to be p-tested
#to see if there's a substantial difference, and then similarly, 3 and 2 have to
#be compared to see if there's a significant difference. 

hvac %>% ggplot() + geom_boxplot(aes(x=FireplaceQu, y=SalePrice, color=FireplaceQu))+
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=FireplaceQu, y=SalePrice, color=FireplaceQu, alpha=.3))
prop.table(table(hvac$FireplaceQu))
#And this also follows the expected thing---
#Now we have to do Chi squared analysis, or see if there is correlation. 








#G&D
gardriv <- ames %>% select(PID, SalePrice, GarageArea, GarageType, GarageFinish,
                           GarageCars, GarageQual, GarageCond, PavedDrive)

gardriv$GarageQual <- as.factor(gardriv$GarageQual) %>% 
  fct_relevel(c("Ex","Gd","TA","Fa", "Po")) #convert quality into factor
gardriv$GarageCond <- as.factor(gardriv$GarageCond) %>% 
  fct_relevel(c("Ex","Gd","TA","Fa", "Po")) #convert quality into factor
gardriv$GarageCars <- as.factor(gardriv$GarageCars) %>%
  fct_relevel(c("0",'1','2','3','4','5'))
gardriv$GarageFinish <- as.factor(gardriv$GarageFinish)
gardriv$GarageType <- as.factor(gardriv$GarageType)


gardriv %>% ggplot() + geom_point(aes(x=GarageArea, y=SalePrice , color=GarageCars))
gardriv %>% ggplot() + geom_point(aes(x=GarageArea, y=SalePrice , color=GarageType))
##pretty good plot

gardriv %>% ggplot() + geom_boxplot(aes(x=GarageType, y=SalePrice, color=GarageType)) +
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=GarageType, y=SalePrice, color=GarageType, alpha=.3))
prop.table(table(gardriv$GarageType))
#most have att, or detatched. Attatched garage is more expensive. 


gardriv %>% ggplot() + geom_boxplot(aes(x=GarageFinish, y=SalePrice, color=GarageFinish)) +
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=GarageFinish, y=SalePrice, color=GarageFinish, alpha=.3))
prop.table(table(gardriv$GarageFinish))
#pretty good actually, fixing up garage looks like it improves price
#feasible to flip based on garage? 
#do a p-test to compare Fin and RFin

gardriv %>% ggplot() + geom_boxplot(aes(x=GarageCars, y=SalePrice, color=GarageCars)) +
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=GarageCars, y=SalePrice, color=GarageCars, alpha=.3))
prop.table(table(gardriv$GarageCars))
#What we expect--more expensive with number of cars



gardriv %>% ggplot() + geom_boxplot(aes(x=GarageQual, y=SalePrice, color=GarageQual)) +
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=GarageQual, y=SalePrice, color=GarageQual, alpha=.3))
prop.table(table(gardriv$GarageQual))
#What we expect


gardriv %>% ggplot() + geom_boxplot(aes(x=GarageCond, y=SalePrice, color=GarageCond)) +
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=GarageCond, y=SalePrice, color=GarageCond, alpha=.3))
table(gardriv$GarageCond)
#This variable can be ignored, the condition is .96 at TA. 
#see geographic correlations
#see if other factors explain the existence of groups


gardriv %>% ggplot() + geom_boxplot(aes(x=PavedDrive, y=SalePrice, color=PavedDrive)) +
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=PavedDrive, y=SalePrice, color=PavedDrive, alpha=.3))
prop.table(table(gardriv$PavedDrive))
#what we expect. still, majority of houses (90%) are paved. 












#BBK
hvac <- ames %>% select(PID, SalePrice, Heating, HeatingQC, CentralAir,
                        Electrical, Fireplaces, FireplaceQu)






#YPDP
hvac <- ames %>% select(PID, SalePrice, Heating, HeatingQC, CentralAir,
                        Electrical, Fireplaces, FireplaceQu)
