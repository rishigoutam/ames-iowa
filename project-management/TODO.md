Project Plan
* EDA (2 days)
  * categorical vs numeric vs boolean
  * grouped featured (e.g., garage variables)
  * count/freq by categorical variable (histogram)
    - e.g., number of abnormal sales to all SaleCondition
  * scatterplots of numeric variables
  * counts of missing data
  * boxplots for outliers
  * p-values for significance
  
* Cleaning -> *.Rds/Rda file (1 day)
  * categorical -> dummify/one-hot encode
  * categorical -> ordinal ranking (e.g., quality)
  * NA/missing values
    * impute (mean, median, mode)
    * drop
    * Explicit NAs in cols: Alley, Cond2, Ext2, BsmtQuality, BsmtCond
      * E.g., <blank>s in Alley implies that there is "No Alley"
      * convert Alley <blanks> into "NoAlley"
    * Type of missing NA
  * Join two data sets (PID/MapRefNo)
    * Get lat/lon -> store data.frame
  * Exclude certain types of data
  

Prediction Models
* Linear regression (multiple)
* Other models
  * backprop
  * others we learn
* Predict SalePrice
  * subset our data
  
Who are we?
* Renovation company 
  - e.g., "How would paving a driveway/finishing a basement affect delta SalePrice"
  - e.g., "Is <x> renovation worth it?"
  - e.g., Misc stuff: Tennis court, elevators, etc
* Zillow/Real estate agent/home seller - we want to set a target price for a home we are selling
* House flippers
  
Additional Datasets
* interest rate over time
  
Visualize
* map
* app
