# Project Plan
The project is due March 9 and is to be presented on March 10, 2022

## EDA (2 days)
  * categorical vs numeric vs boolean
  * grouped featured (e.g., garage variables)
  * count/freq by categorical variable (histogram)
    - e.g., number of abnormal sales to all SaleCondition
  * scatterplots of numeric variables
  * counts of missing data
  * boxplots for outliers
  * p-values for significance
  
## Cleaning Housing Dataset (1 day)
  * Create *.Rds/Rda file
  * categorical -> dummify/one-hot encode
  * categorical -> ordinal ranking (e.g., quality)
  * NA/missing values
    * impute (mean, median, mode)
    * drop
    * Explicit NAs in cols: Alley, Cond2, Ext2, BsmtQuality, BsmtCond
      * E.g., blanks in Alley implies that there is "No Alley"
      * Therefore, convert Alley blanks into "NoAlley"
    * Type of missing NA -> investigate further if there is a pattern
  * Exclude certain types of data if warranted
    - Could exclude non-Normal SaleCondition for instance
  
## Additional Datasets
* Join two provided data sets 
  * by PID = MapRefNo
  * Get lat/lon -> store as data.frame
* Interest rate - evaluate effect on SalePrice

## Prediction Models
* Linear regression (multiple)
* Other models
  * backprop
  * others we learn
  
## Who are we? (TBD)
* Renovation company/House flippers
  - e.g., "How would paving a driveway/finishing a basement affect delta SalePrice"
  - e.g., "Is <x> renovation worth it?"
  - e.g., Misc stuff: Tennis court, elevators, etc
* Zillow/Real estate agent/home seller 
  - we want to set a target price for a home we are selling
  
## Kaggle entry
* Participate in the Kaggle competition
  * Can use competition score for relative goodness of our model
  
## Data Visualization
* map
  * can be useful to identify neighborhood vs prices trends
* app (R shiny/python)

## Presentation
* ppt/google slides
