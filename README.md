# Ames Iowa House Predictions
The Ames Housing Regression project focuses on accurately predicting house prices in Ames, IA using a dataset of 2580 houses. For a full description of the data flow, see bottom of this page. 
We focused on creating multiple predictive models that adhered to assumptions of the model (statistically correct, good use of hyper-parameters, etc).
Our project aims to create business value for real estate agents at our (fictitious) company, Regression Realty by:
* Accurately predicting property sale values
  * Listing agents can thus not overprice a home, leading to long time-on-market for a property or underprice, thus leaving money on the table for their client
  * Selling agents can steer clients towards underpriced homes and give bidding advice
* Providing insights that an agent can use to make renovation recommendations to their client (1-unit effects)
* Market analysis via time series modeling

### Outcome
We created prediction models that would allow listing and selling agents get accurate predictions for a property's sale price in Ames, Iowa. These models could be incorporated into an app where an agent could enter home details and find its value.
Mispriced homes are often not sold in a timely manner (or leave money on the table for the owner if priced too low), so there is value in having a good price in a property listing.

### Models 
* Regression
  * Univariate regression (EDA on importance of features, not for prediction of SalePrice)
  * Multiple Linear Regression
  * Elastic-Net
* Tree-based Models
  * Decision Tree
  * Random Forest
  * Boosting
* SVR
* Neural Network 
  * Backpropagation
* S/ARIMA (EDA on seasonality and investigation of 2008 market crash, predicting average SalePrice)

### Model Validation and Feature Selection
For linear regression, we made sure to only add features if they were
* significant (p-values)
* not multicolinear (did not inflate VIF of another feature)
* improved the model's accuracy (R<sup>2</sup>) and decreased complexity (AIC/BIC)

We checked residuals' Q-Q plots, distribution (they were normally distributed and centered around 0) as well as the coefficients' confidence intervals

### Features
We added new features from additional data sources:
* School district for properties
* Treasury yields by month (as these have impact on home loan prices)
And also derived some new features from the existing dataset (IsPUD, IsNearNegativeCondition, etc)

## Team
* Akram Sadek
* James Goudreault
* Rishi Goutam
* Srikar Pamidi

## Code
* The code exists in both jupyter and R notebooks split across teammate's folders
  * `akram` contains linear regression, elastic-net, interest rate, and backpropagation files
  * `james` contains tree-based and SVR files
  * `rishi` contains data cleaning, feature engineering, school district generation, and linear regression files
  * `srikar` contains time series files
  * All of the above contain EDA as well
* Data (provided and generated) is in `data`
* Two helper packages were written to aid with the translating data dictionary terms and selecting features
  * `data_dict`
  * `features`

# Project Info
* [GitHub repo](github.com/rishigoutam/ames-iowa)
* [Presentation](https://docs.google.com/presentation/d/14Kt08GkOo-_00dKlXhadOi5QQhlWIdhumd3M6utnex0/)

# Data Pipeline

[//]: # (https://mermaid-js.github.io/mermaid/#/flowchart)

```mermaid
flowchart LR
    d_r[(Ames_Real_Estate\n_Data.csv)]-->geopy
    d_TNX[(TNX)]-->tnx
    d_shapefile[(ames_school_districts_sf)]-->districts
    
    subgraph geo [New Features <various R/python>]
        direction LR
        geopy[[get coordinates\n using geopy]]
        tnx[[get interest rate\n using quandle]]
        districts[[get school district\n using shapefile]]
    end
    
    geo-->d_e

    d_h[(Ames_Housing_Price\n_Data.csv)]-->clean
    
    subgraph clean [Data Cleaning <clean.ipynb>]
        direction TB
        dupe[[remove \nduplicates]]-->outlier
        outlier[[remove \noutliers]]-->fillna
        fillna[[fill \nempty values]]-->impute
        impute[[impute \nmissing values]]
    end
    
    clean-->d_c[(cleaned.csv)]
    
    subgraph encode [Feature Engineering <engineer.ipynb>]
        direction TB
        ordinate[[convert categorical \nfeatures to ordinal]]-->indicator
        indicator[[create indicator \nfeatures]]-->new
        new[[create derived \nfeatures]]
    end
    
    d_c-->encode-->d_e[(engineered.csv)]
    
    subgraph eda [EDA <eda.ipynb, eda.R>]
        direction TB
        histograms-.-
        boxplots
        scatterplots-.-
        regplots
    end
    
    subgraph lin_regression [Multiple Linear Regression <linreg.ipynb, linreg.R>]
        direction TB
        subgraph lin_features [Select Model Features]
            direction LR
            style lin_features stroke-dasharray: 5 5, fill: khaki
            cat_encoded--->dummify[[dummify]]
            numerical---|plus|cat_encoded[categorical]---|plus|boolean
        end
        
        lin_features--->
        linear_model[[create model]]--->
        validate--->|iterate|lin_features
        
        subgraph validate [Validate and Score]
            direction LR
            style validate stroke-dasharray: 5 5, fill:khaki
            stats_significance[feature significance: p-values]
            stats_cor[multicolinearity: vif]
            stats_score[score: R^2, RMSE, AIC/BIC]
        end
        
    end
    
    subgraph algo [Additional Models]
        direction LR
        decision_tree>Decision Tree]
        arima>SARIMA]
        svr>SVR]
        backprop>Neural Net]
        
        decision_tree.->random_forest>Random Forest]
        decision_tree.->boosted>Boosting]
    end
    
    d_c-->eda
    d_e-->lin_regression
    d_e-->decision_tree
    d_e-->arima
    d_e-->svr
    d_e-->backprop
```
