"""
Helper module for getting features by data type.

The features are created/dropped in `engineer.ipynb` and must be manually entered here
"""

import pandas as pd

guid = ['PID']
target = ['SalePrice', 'LogSalePrice']

__collapse_ordinal = set()
__combine_ordinal = set()
__ordinal = {'ExterQual', 'ExterCond', 'OverallCond', 'OverallQual', 'BsmtQual', 'BsmtCond', 'BsmtExposure',
           'BsmtFinType1', 'BsmtFinType2', 'Functional', 'FireplaceQu', 'HeatingQC', 'KitchenQual', 'LandSlope',
           'LotShape', 'GarageCond', 'GarageQual', 'Street', 'PavedDrive', 'Alley', 'Utilities', 'PoolQC'}
ordinal = list(__ordinal.union(__collapse_ordinal).union(__combine_ordinal))

# TODO create more based on R^2. We want to create features only if we will use them
__collapse_categorical = {'Collapse_MSSubClass'}
__combine_categorical = set()
__categorical = {'MSSubClass', 'MSZoning',
               'LandContour', 'LotConfig', 'Neighborhood',
               'Condition1', 'Condition2', 'BldgType', 'HouseStyle',
               'RoofStyle', 'RoofMatl', 'Exterior1st', 'Exterior2nd', 'MasVnrType', 'Foundation', 'Heating',
               'CentralAir', 'Electrical', 'GarageType', 'GarageFinish', 'Fence', 'MiscFeature',
               'MoSold', 'YrSold',
               'SaleType', 'SaleCondition'}
categorical = list(__categorical.union(__collapse_categorical).union(__combine_categorical))

__new_numerical = {'NumFloors', 'Combine_BathroomsBsmt', 'Combine_BathroomsAbvGrd', 'AllBathrooms', 'Combine_Age'}
__numerical = {'GrLivArea', 'LotArea', 'LotFrontage', 'MasVnrArea',
             'BsmtFinSF1', 'BsmtFinSF2', 'BsmtUnfSF', 'TotalBsmtSF',
             '1stFlrSF', '2ndFlrSF', 'LowQualFinSF',
             'BsmtFullBath', 'BsmtHalfBath', 'FullBath', 'HalfBath', 'BedroomAbvGr', 'KitchenAbvGr',
             'TotRmsAbvGrd', 'Fireplaces', 'GarageYrBlt', 'GarageCars', 'GarageArea',
             'WoodDeckSF', 'OpenPorchSF', 'EnclosedPorch', '3SsnPorch', 'ScreenPorch', 'PoolArea',
             'YearBuilt', 'YearRemodAdd',
             'MiscVal'}
numerical = list(__numerical.union(__new_numerical))

# TODO create more based on R^2. We want to create features only if we will use them
booleans = ['IsPUD', 'IsRenovated', 'IsNearNegativeCondition', 'IsNearPositiveCondition']

features = ordinal + categorical + numerical + booleans


def check_features(df: pd.DataFrame) -> None:
    """
    prints check that the df columns are those that are in the feature
    :param df:
    :return: None
    """
    print(f"{len(df.columns)} #columns == {len(guid + target + features)} #features+PID+targets")


def check_features2(df: pd.DataFrame) -> pd.Series:
    """
    :param df:
    :return: a series to manually check that the features are the same as in the df
    """
    return pd.concat([pd.Series(sorted(df.columns), name="df.columns"),
                      pd.Series(sorted(features + guid + target), name="features")],
                     axis=1)

def get_all_features():
    return features


def get_numerical_features():
    return numerical

def get_categorical_features():
    return categorical


def get_ordinal_features():
    return ordinal


def get_boolean_features():
    return booleans
