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

table(hvac$Heating, hvac$HeatingQC)

hvac %>% ggplot() + geom_boxplot(aes(x=Heating, y=SalePrice))
#grouping by heating doesnt give much since GasA is overwhelmingly popular

hvac %>% ggplot() + geom_boxplot(aes(x=HeatingQC, y=SalePrice))
#heating Quality follows a pattern we expect--need to do p-test

hvac %>% ggplot() + geom_boxplot(aes(x=CentralAir, y=SalePrice))
#homes with central heating are more expensive on average--need to do p-test

hvac %>% ggplot() + geom_boxplot(aes(x=Electrical, y=SalePrice))
table(hvac$Electrical, hvac$Heating)
#Not clear what to read from this

table(hvac$Fireplaces,hvac$FireplaceQu)
table(hvac$Fireplaces)
c(1241,1132,195,11,1)
hvac %>% ggplot() + geom_boxplot(aes(x=Fireplaces, y=SalePrice))
#As we expect, price goes up with #of fireplaces but 2 and 1 has to be p-tested
#to see if there's a substantial difference, and then similarly, 3 and 2 have to
#be compared to see if there's a significant difference. 



hvac %>% ggplot() + geom_boxplot(aes(x=FireplaceQu, y=SalePrice))
#And this also follows the expected thing---

#Now we have to do Chi squared analysis, or see if there is corelation. 




#G&D

#BBK

#YPDP
