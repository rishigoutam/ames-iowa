library(tidyverse)
library(car)
library(caret)

ames <- read.csv("./data/engineered.csv", stringsAsFactors = TRUE)

colnames(ames)

set.seed(9001)
random_sample <- createDataPartition(ames$LogSalePrice, p = 0.7, list = FALSE)

train <- ames[random_sample, ]
test <- ames[-random_sample, ]

model <- lm(LogSalePrice ~
           GrLivArea + LotFrontage +
           MSSubClass + BldgType +
           OverallQual + Neighborhood +
           SaleCondition,
           data = train)

# Verify model
summary(model) # R2 of 0.8723 in train
vif(model)

predictions <- predict(model, test)

R2(predictions, test$LogSalePrice) # 0.8587439 in test
RMSE(predictions, test$LogSalePrice)
MAE(predictions, test$LogSalePrice)

ames[2577, 'LogSalePrice'] # predicted 12.36687, actual 12.27839
ames[2577, 'SalePrice'] # predicted 234888.73, actual 215000
