# Ames Iowa House Predictions
The Ames Housing Regression focuses on accurately predicting house prices in Ames, IA using a dataset of 2580 houses.
The code is in both jupyter and R notebooks split across teammate's folders. For a full description of the data flow, see bottom of this page.
We focused on creating multiple predictive models that adhered to assumptions of the model (statistically correct, good use of hyperparamters, etc). 

### Models
These models include:
* Regression
  * Univariate regression (EDA on importance of features, not for prediction)
  * Multiple Linear Regression
  * Elastic-Net
* SVR
* Tree-based Models
  * Decision Tree
  * Random Forest
  * Boosting
* S/ARIMA (EDA on seasonality and investigation of 2008 market crash, not for prediction)

### Model Validation and Feature Selection
For linear regression, we made sure to only add features if they were
* significant
* not multicolinear (did not inflate VIF of another feature)
* improved the model's accuracy (R<sup>2</sup>) and decreased complexity (AIC/BIC)

We checked residuals' Q-Q plots, distribution (they were normally distributed and centered around 0) as well as the coefficients' confidence intervals

### Features
We added new features from additional data sources:
* School district for properties
* Treasury yields by month (as these have impact on home loan prices)
And also derived some features from the existing dataset (IsPUD, IsNearNegativeCondition, etc)

## Team
* Rishi Goutam
* Akram Sadek
* James Goudreault
* Srikar Pamidi

# Project Info
* [GitHub repo](github.com/rishigoutam/ames-iowa)
* [Presentation](https://docs.google.com/presentation/d/14Kt08GkOo-_00dKlXhadOi5QQhlWIdhumd3M6utnex0/edit?usp=sharing)

# Data Pipeline
NOTE: The below requires `mermaid` to render the markdown flowchart. If not available, you can see the rendered chart in our [git repository](github.com/rishigoutam/ames-iowa)

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
        arima>ARIMA]
        svr>SVR]
        
        decision_tree.->random_forest>Random Forest]
        decision_tree.->boosted>Boosting]
    end
    
    d_c-->eda
    d_e-->lin_regression
    d_e-->decision_tree
    d_e-->arima
    d_e-->svr
```