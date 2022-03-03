# Data Pipeline

[//]: # (https://mermaid-js.github.io/mermaid/#/flowchart)

```mermaid
flowchart TD
    d_r[(Ames_Real_Estate\n_Data.csv)]-->geo
    d_h[(Ames_Housing_Price\n_Data.csv)]-->geo
    
    subgraph geo [Get Latitude/Longitude <geo_locations.ipynb>]
        direction LR
        merge[[merge datasets]]-->geopy
        geopy[[get coordinates\n using geopy]]
    end
    
    geo-->d_g[(housing_geolocation.csv)]

    d_h-->clean
    
    subgraph clean [Data Cleaning <clean.ipynb>]
        direction LR
        dupe[[remove \nduplicates]]-->outlier
        outlier[[remove \noutliers]]-->fillna
        fillna[[fill \nempty values]]-->impute
        impute[[impute \nmissing values]]
    end
    
    clean-->d_c[(cleaned.csv)]
    
    subgraph encode [Feature Engineering <engineer.ipynb>]
        direction LR
        ordinate[[convert categorical \nfeatures to ordinal]]-->indicator
        indicator[[create indicator \nfeatures]]-->new
        style indicator fill:orange
        new[[create new \nfeatures]]
        style new fill:orange
    end
    
    d_c-->encode-->d_e[(engineered.csv)]
    
    subgraph eda [EDA <eda.ipynb, eda.R>]
        direction TB
        histograms
        boxplots
        scatterplots
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
            stats_score[score: R^2, RMSE]
        end
        
    end
    
    subgraph algo [fancy_algo.ipynb]
        direction LR
        TODO>TODO]
        style TODO fill:orange
    end
    
    d_c-->eda
    d_e-->lin_regression
    d_e-->algo
    
    lin_regression & algo-->kaggle[\submit on kaggle/]
```