library(tidyverse)
library(ggcorrplot)
library(gtools)


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









  #Heating
hvac %>% ggplot() + geom_boxplot(aes(x=Heating, y=SalePrice, color=Heating))+ 
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=Heating, y=SalePrice, color=Heating, alpha=.3))
#grouping by heating doesnt give much since GasA is overwhelmingly popular
#conclusion is to ignore this feature


  #HeatingQuality
hvac %>% ggplot() + geom_boxplot(aes(x=HeatingQC, y=SalePrice, color=HeatingQC)) + 
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=HeatingQC, y=SalePrice, color=HeatingQC, alpha=.3))
#heating Quality follows a pattern we expect--need to do p-test

#two sample p-test on gd,ta and ta,fa
set.seed(123)
#save data into the two columns for gd/ta
gd_heat <- hvac %>% filter(HeatingQC=='Gd') %>%
  pull(SalePrice)
ta_heat <- hvac %>% filter(HeatingQC=='TA') %>%
  pull(SalePrice)
fa_heat <- hvac %>% filter(HeatingQC=='Fa') %>%
  pull(SalePrice)
t.test(gd_heat,ta_heat)
t.test(ta_heat,fa_heat)
#Seems that they are significantly different. 



  #CentralAir
hvac %>% ggplot() + geom_boxplot(aes(x=CentralAir, y=SalePrice, color=CentralAir)) +
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=CentralAir, y=SalePrice, color=CentralAir, alpha=.3))
#homes with central heating are more expensive on average--need to do p-test



  #Electrical
hvac %>% ggplot() + geom_boxplot(aes(x=Electrical, y=SalePrice, color=Electrical)) +
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=Electrical, y=SalePrice, color=Electrical, alpha=.3))
prop.table(table(hvac$Electrical))
#Not clear what to read from this



  #Fireplaces
prop.table(table(hvac$Fireplaces,hvac$FireplaceQu))
prop.table(table(hvac$Fireplaces))
hvac %>% ggplot() + geom_boxplot(aes(x=Fireplaces, y=SalePrice, color=Fireplaces)) +
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=Fireplaces, y=SalePrice, color=Fireplaces, alpha=.3))

#As we expect, price goes up with #of fireplaces but 2 and 1 has to be p-tested
#to see if there's a substantial difference, and then similarly, 3 and 2 have to
#be compared to see if there's a significant difference. 
#save data into the columns
fire_2 <- hvac %>% filter(Fireplaces=='2') %>%
  pull(SalePrice)
fire_1 <- hvac %>% filter(Fireplaces=='1')%>%
  pull(SalePrice)
fire_3 <- hvac %>% filter(Fireplaces=='3')%>%
  pull(SalePrice)
t.test(fire_1,fire_2)
t.test(fire_2,fire_3)
#Seems that they are significantly different. 





  #FireQu
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






  #GarageArea
gardriv %>% ggplot() + geom_point(aes(x=GarageArea, y=SalePrice , color=GarageCars))
gardriv %>% ggplot() + geom_point(aes(x=GarageArea, y=SalePrice , color=GarageType))
##pretty good plot



  #GarageType
gardriv %>% ggplot() + geom_boxplot(aes(x=GarageType, y=SalePrice, color=GarageType)) +
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=GarageType, y=SalePrice, color=GarageType, alpha=.3))
prop.table(table(gardriv$GarageType))
#most have att, or detatched. Attatched garage is more expensive. 




  #GarageFinish
gardriv %>% ggplot() + geom_boxplot(aes(x=GarageFinish, y=SalePrice, color=GarageFinish)) +
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=GarageFinish, y=SalePrice, color=GarageFinish, alpha=.3))
prop.table(table(gardriv$GarageFinish))
#pretty good actually, fixing up garage looks like it improves price
#feasible to flip based on garage? 
#do a p-test to compare Fin and RFin
#save data into the columns
rfn <- gardriv %>% filter(GarageFinish=='RFn') %>%
  pull(SalePrice)
fin <- gardriv %>% filter(GarageFinish=='Fin') %>%
  pull(SalePrice)
t.test(fin,rfn)




  #GarageCars
gardriv %>% ggplot() + geom_boxplot(aes(x=GarageCars, y=SalePrice, color=GarageCars)) +
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=GarageCars, y=SalePrice, color=GarageCars, alpha=.3))
prop.table(table(gardriv$GarageCars))
#What we expect--more expensive with number of cars




  #GarageQual
gardriv %>% ggplot() + geom_boxplot(aes(x=GarageQual, y=SalePrice, color=GarageQual)) +
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=GarageQual, y=SalePrice, color=GarageQual, alpha=.3))
prop.table(table(gardriv$GarageQual))
#What we expect




  #GarageCond
gardriv %>% ggplot() + geom_boxplot(aes(x=GarageCond, y=SalePrice, color=GarageCond)) +
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=GarageCond, y=SalePrice, color=GarageCond, alpha=.3))
table(gardriv$GarageCond)
#This variable can be ignored, the condition is .96 at TA. 
#see geographic correlations
#see if other factors explain the existence of groups



  #Paved
gardriv %>% ggplot() + geom_boxplot(aes(x=PavedDrive, y=SalePrice, color=PavedDrive)) +
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=PavedDrive, y=SalePrice, color=PavedDrive, alpha=.3))
prop.table(table(gardriv$PavedDrive))
#what we expect. still, majority of houses (90%) are paved. 












#BBK
bbk <- ames %>% select(PID, SalePrice, MSSubClass,  FullBath, HalfBath, BedroomAbvGr,
                        KitchenAbvGr, KitchenQual)
bbk$FullBath <- as.factor(bbk$FullBath) #convert quality into factor
bbk$HalfBath <- as.factor(bbk$HalfBath) #convert quality into factor
bbk$BedroomAbvGr <-as.factor(bbk$BedroomAbvGr) 
bbk$KitchenAbvGr <- as.factor(bbk$KitchenAbvGr) 
bbk$MSSubClass <- as.factor(bbk$MSSubClass)
bbk$KitchenQual <- as.factor(bbk$KitchenQual) %>%
  fct_relevel(c("Ex","Gd","TA","Fa", "Po")) #convert quality into factor

  #Fullbath
bbk %>% ggplot() + geom_boxplot(aes(x=FullBath, y=SalePrice, color=FullBath)) +
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=FullBath, y=SalePrice, color=FullBath, alpha=.3))
prop.table(table(bbk$FullBath))

  #Halfbath
bbk %>% ggplot() + geom_boxplot(aes(x=HalfBath, y=SalePrice, color=HalfBath)) +
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=HalfBath, y=SalePrice, color=HalfBath, alpha=.3))
prop.table(table(bbk$HalfBath))


#IGnore this 
bbk %>% ggplot() + geom_boxplot(aes(x=HalfBath, y=SalePrice, color=HalfBath)) +
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=FullBath, y=SalePrice, color=FullBath, alpha=.3))
prop.table(table(bbk$HalfBath))
#


  #Bedroom
bbk %>% ggplot() + geom_boxplot(aes(x=BedroomAbvGr, y=SalePrice)) +
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=BedroomAbvGr, y=SalePrice, color=MSSubClass, alpha=.3))
prop.table(table(bbk$BedroomAbvGr)) #revisit after cleaning subclasses

  #Kitchen
bbk %>% ggplot() + geom_boxplot(aes(x=KitchenAbvGr, y=SalePrice, color=KitchenAbvGr)) +
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=KitchenAbvGr, y=SalePrice, color=KitchenAbvGr, alpha=.3))
prop.table(table(bbk$KitchenAbvGr))


  #KQual
bbk %>% ggplot() + geom_boxplot(aes(x=KitchenQual, y=SalePrice, color=KitchenQual)) +
  geom_jitter(shape=1,size=.3, position=position_jitter(0.2),aes(x=KitchenQual, y=SalePrice, color=KitchenQual, alpha=.3))
prop.table(table(bbk$KitchenQual))












#YPDP
ypdp <- ames %>% select(PID, SalePrice, WoodDeckSF, OpenPorchSF, EnclosedPorch,
                        `3SsnPorch`, ScreenPorch, PoolArea, PoolQC)
ypdp$PoolQC <- as.factor(ypdp$PoolQC) %>%
  fct_relevel(c("Ex","Gd","TA","Fa", "Po")) #convert quality into factor

ypdp %>% ggplot() + geom_point(aes(x=WoodDeckSF, y=SalePrice))
ypdp %>% ggplot() + geom_point(aes(x=WoodDeckSF, y=log(SalePrice)))

ypdp %>% ggplot() + geom_point(aes(x=OpenPorchSF, y=SalePrice))
ypdp %>% ggplot() + geom_point(aes(x=OpenPorchSF, y=log(SalePrice)))

ypdp %>% ggplot() + geom_point(aes(x=OpenPorchSF, y=SalePrice,color = WoodDeckSF))
ypdp %>% ggplot() + geom_point(aes(x=OpenPorchSF, y=log(SalePrice),color = WoodDeckSF))
ypdp %>% ggplot() + geom_point(aes(x=WoodDeckSF, y=OpenPorchSF, color=SalePrice))
ypdp %>% ggplot() + geom_point(aes(x=EnclosedPorch, y=OpenPorchSF, color=SalePrice))
ypdp %>% ggplot() + geom_point(aes(x=WoodDeckSF, y=SalePrice)) + 
  geom_point(aes(x=OpenPorchSF, y=SalePrice, color = 'r')) +
  geom_point(aes(x=`3SsnPorch`, y=SalePrice, color = 'g')) +
  geom_point(aes(x=EnclosedPorch, y=SalePrice, color = 'b')) +
  geom_point(aes(x=ScreenPorch, y=SalePrice, color = 'y')) +
  geom_point(aes(x=PoolArea, y=SalePrice, color = 'o')) 

ypdp %>% ggplot() + geom_point(aes(x=WoodDeckSF, y=log(SalePrice) )) + 
  geom_point(aes(x=OpenPorchSF, y=log(SalePrice) , color = 'r')) +
  geom_point(aes(x=`3SsnPorch`, y=log(SalePrice) , color = 'g')) +
  geom_point(aes(x=EnclosedPorch, y=log(SalePrice) , color = 'b')) +
  geom_point(aes(x=ScreenPorch, y=log(SalePrice) , color = 'y')) +
  geom_point(aes(x=PoolArea, y=log(SalePrice) , color = 'o')) 
#linear regression for each, compare the slopes 



ypdp %>% ggplot() + geom_point(aes(x=`3SsnPorch`, y=SalePrice))
ypdp %>% ggplot() + geom_point(aes(x=ScreenPorch, y=SalePrice))
ypdp %>% ggplot() + geom_point(aes(x=PoolArea, y=SalePrice))

p.mat <-ypdp %>% select(SalePrice, WoodDeckSF, OpenPorchSF, EnclosedPorch,
                `3SsnPorch`, ScreenPorch, PoolArea) %>% cor() %>% cor_pmat()

#No GooD relationships 

#plots 1,2
ypdp %>% select(SalePrice, WoodDeckSF, OpenPorchSF, EnclosedPorch,
                `3SsnPorch`, ScreenPorch, PoolArea) %>% cor() %>%
  ggcorrplot( type = "lower", lab = TRUE) 
ypdp %>% select(SalePrice, WoodDeckSF, OpenPorchSF, EnclosedPorch,
                `3SsnPorch`, ScreenPorch, PoolArea) %>% cor() %>%
  ggcorrplot( type = "lower", lab = TRUE, insig = "blank", p.mat = p.mat) 



#plots3,4
p.mat2<- ames %>% select(SalePrice, WoodDeckSF, OpenPorchSF, EnclosedPorch,
                        `3SsnPorch`, ScreenPorch, PoolArea, GarageArea) %>% 
  cor(use="complete.obs") %>% 
  cor_pmat()
  
ames %>% select(SalePrice, WoodDeckSF, OpenPorchSF, EnclosedPorch,
                `3SsnPorch`, ScreenPorch, PoolArea, GarageArea) %>% cor(use="complete.obs") %>%
  ggcorrplot( type = "lower", lab = TRUE, insig = "blank", p.mat = p.mat2)

ames %>% select(SalePrice, WoodDeckSF, OpenPorchSF, EnclosedPorch,
                `3SsnPorch`, ScreenPorch, PoolArea, GarageArea) %>% cor(use="complete.obs") %>%
  ggcorrplot( type = "lower", lab = TRUE)

