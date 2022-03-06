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

model <- lm(LogSalePrice ~
              # Size
              GrLivArea + AllBathrooms + BedroomAbvGr +
              # Type
              MSSubClass + MSZoning +
              # Niceness
              OverallQual + OverallCond + Neighborhood + KitchenQual +
              # Sale
              SaleCondition + YrSold +
              # Features
              CentralAir + Fireplaces +
              # Others
              IsNearNegativeCondition + LandContour,
            data = train)

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
