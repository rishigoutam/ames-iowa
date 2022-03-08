library(tidyverse)
library(car)
library(caret)
library(corrplot)

ames <- read.csv("./data/engineered.csv", stringsAsFactors = TRUE)

sort(colnames(ames))

set.seed(9001)
random_sample <- createDataPartition(y = ames$LogSalePrice,
                                     p = 0.7,
                                     list = FALSE)

train <- ames[random_sample, ]
test <- ames[-random_sample, ]

# # Size
# 'GrLivArea', 'TotalFinBsmtSF', 'TotalOutdoorSF', 'LotArea', 'BedroomAbvGr',
# # Type
# 'MSSubClass', 'MSZoning',
# # Niceness
# 'OverallQual', 'OverallCond', 'Neighborhood', 'KitchenQual',
# # Sale
# 'SaleCondition', 'YrSold',
# # Features
# 'CentralAir', 'Fireplaces', 'HasPool',
# # Others
# 'IsNearNegativeCondition', 'LandContour'

# Use one AIC/BIC function to compare against Akram's model
AICBIC=function(fit, type){
  if (length(deviance(fit))==1) {
    tLL = -deviance(fit)
    edf = fit$df
    n = nobs(fit)
  } else if (length(deviance(fit$finalModel))>1) {
    tLL = -min(deviance(fit$finalModel))
    edf = fit$finalModel$df[which.min(deviance(fit$finalModel))]
    n = fit$finalModel$nobs
  }
  AIC_ = -tLL + 2*edf
  BIC_ = log(n)*edf - tLL
  if (identical(type,"aic")|identical(type,"AIC")) {
    return(AIC_)
  } else if (identical(type,"bic")|identical(type,"BIC")) {
    return(BIC_)
  } else {
    return("Error! Unknown type")
  }
}


model <- lm(LogSalePrice ~
              # Size
              GrLivArea + TotalFinBsmtSF + TotalOutdoorSF + LotArea + BedroomAbvGr +
              # Type
              MSSubClass + MSZoning +
              # Niceness
              OverallQual + OverallCond + Neighborhood + KitchenQual +
              # Sale
              SaleCondition + YrSold +
              # Features
              CentralAir + Fireplaces + HasPool +
              # Others
              IsNearNegativeCondition + LandContour,
            data = train)

AICBIC(model, "bic")

# all features
# model <- lm(LogSalePrice ~ . - SalePrice - PID,
#             data = train)

# Verify model
summary(model) # R2 of 0.8723 in train
vif(model)
# If we have multicolinearity, vif will tell us (aliased coefficients exist in the model)

# FIX: this is failing due to test having a new MSSubClass factor level unseen in the train set
predictions <- predict(model, test)

R2(predictions, test$LogSalePrice) # 0.8587439 in test
RMSE(predictions, test$LogSalePrice)
MAE(predictions, test$LogSalePrice)

ames[2577, 'LogSalePrice'] # actual 12.27839
ames[2577, 'SalePrice'] # actual 215000
