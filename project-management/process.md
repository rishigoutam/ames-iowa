# Data Pipeline

[//]: # (https://mermaid-js.github.io/mermaid/#/flowchart)

```mermaid
flowchart LR
    d_r[(Ames_Real_Estate\n_Data.csv)]-->geo
    d_TNX[(TNX)]-->geo
    d_shapefile[(ames_school_districts_sf)]-->geo
    
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
        backprop>Back Propagation]
        svr>SVR]
        
        decision_tree.->random_forest>Random Forest]
        decision_tree.->boosted>Boosting]
    end
    
    d_c-->eda
    d_e-->lin_regression
    d_e-->decision_tree
    d_e-->arima
    d_e-->backprop
    d_e-->svr
```