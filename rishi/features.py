"""
Helper module for getting features by data type
"""

import pandas as pd

guid = ['PID']
target = ['SalePrice']

ordinal = ['ExterQual', 'ExterCond', 'OverallCond', 'OverallQual',
           'BsmtQual', 'BsmtCond', 'BsmtExposure', 'BsmtFinType1', 'BsmtFinType2',
           'Functional', 'FireplaceQu', 'HeatingQC', 'KitchenQual', 'LandSlope', 'LotShape',
           'GarageCond', 'GarageQual', 'Street', 'PavedDrive', 'Alley', 'Utilities', 'PoolQC']

# TODO create more based on R^2. We want to create features only if we will use them
collapse_categorical = ['Collapse_MSSubClass']
categorical = ['MSSubClass', 'MSZoning',
               'LandContour', 'LotConfig', 'Neighborhood',
               'Condition1', 'Condition2', 'BldgType', 'HouseStyle',
               'RoofStyle', 'RoofMatl', 'Exterior1st', 'Exterior2nd', 'MasVnrType', 'Foundation', 'Heating',
               'CentralAir', 'Electrical', 'GarageType', 'GarageFinish', 'Fence', 'MiscFeature',
               'MoSold', 'YrSold',
               'SaleType', 'SaleCondition']
categorical = categorical + collapse_categorical

new_numerical = ['NumFloors', 'BsmtAllBaths', 'AbvGrdBaths']
numerical = ['GrLivArea', 'LotArea', 'LotFrontage', 'MasVnrArea',
             'BsmtFinSF1', 'BsmtFinSF2', 'BsmtUnfSF', 'TotalBsmtSF',
             '1stFlrSF', '2ndFlrSF', 'LowQualFinSF',
             'BsmtFullBath', 'BsmtHalfBath', 'FullBath', 'HalfBath', 'BedroomAbvGr', 'KitchenAbvGr',
             'TotRmsAbvGrd', 'Fireplaces', 'GarageYrBlt', 'GarageCars', 'GarageArea',
             'WoodDeckSF', 'OpenPorchSF', 'EnclosedPorch', '3SsnPorch', 'ScreenPorch', 'PoolArea',
             'YearBuilt', 'YearRemodAdd',
             'MiscVal']
numerical = numerical + new_numerical

# TODO create more based on R^2. We want to create features only if we will use them
booleans = ['IsPUD']

features = ordinal + categorical + numerical + booleans


def check_features(df: pd.DataFrame) -> None:
    """
    prints check that the df columns are those that are in the feature
    :param df:
    :return: None
    """
    print(f"{len(df.columns)} #columns == {len(guid + target + features)} #features+PID+SalePrice")


def get_features(df: pd.DataFrame) -> pd.Series:
    """
    :param df:
    :return: a series to manually check that the features are the same as in the df
    """
    return pd.concat([pd.Series(sorted(features + guid + target), name="features"),
                      pd.Series(sorted(df.columns), name="df.columns")],
                     axis=1)
