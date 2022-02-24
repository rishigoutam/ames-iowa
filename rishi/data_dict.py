"""
Helper module for getting descriptions/labels of Ames Housing features

See: `data/data_description.txt`
"""

import pandas as pd

# MSSubClass: Identifies the type of dwelling involved in the sale
MSSubClass = pd.Series({
    20: '1-STORY 1946 & NEWER ALL STYLES',
    30: '1-STORY 1945 & OLDER',
    40: '1-STORY W/FINISHED ATTIC ALL AGES',
    45: '1-1/2 STORY - UNFINISHED ALL AGES',
    50: '1-1/2 STORY FINISHED ALL AGES',
    60: '2-STORY 1946 & NEWER',
    70: '2-STORY 1945 & OLDER',
    75: '2-1/2 STORY ALL AGES',
    80: 'SPLIT OR MULTI-LEVEL',
    85: 'SPLIT FOYER',
    90: 'DUPLEX - ALL STYLES AND AGES',
    120: '1-STORY PUD (Planned Unit Development) - 1946 & NEWER',
    150: '1-1/2 STORY PUD - ALL AGES',
    160: '2-STORY PUD - 1946 & NEWER',
    180: 'PUD - MULTILEVEL - INCL SPLIT LEV/FOYER',
    190: '2 FAMILY CONVERSION - ALL STYLES AND AGES'
}, name="MSSubClass")

# SaleType: Type of sale
SaleType = pd.Series({
    'WD ': 'Warranty Deed - Conventional',  # NOTE space in `WD `
    'CWD': 'Warranty Deed - Cash',
    'VWD': 'Warranty Deed - VA Loan',
    'New': 'Home just constructed and sold',
    'COD': 'Court Officer Deed/Estate',
    'Con': 'Contract 15% Down payment regular terms',
    'ConLw': 'Contract Low Down payment and low interest',
    'ConLI': 'Contract Low Interest',
    'ConLD': 'Contract Low Down',
    'Oth': 'Other'
}, name="SaleType")


# WARNING: match requires python 3.10
def convert_exterqual(ordinal_value):
    """
    Gets the numeric value for the ExterQual ordinal value
    :param ordinal_value: one of 'Ex', 'Gd', 'TA', 'Fa', 'Po'
    :return: numeric value from 5 to 1
    """
    match ordinal_value:
        case 'Ex':
            return 5
        case 'Gd':
            return 4
        case 'TA':
            return 3
        case 'Fa':
            return 2
        case 'Po':
            return 1
        case _:
            raise KeyError(f'Invalid ExterQual key {ordinal_value}')

# WARNING: match requires python 3.10
def convert_extercond(ordinal_value):
    """
    Gets the numeric value for the ExterCond ordinal value
    :param ordinal_value: one of 'Ex', 'Gd', 'TA', 'Fa', 'Po'
    :return: numeric value from 5 to 1
    """
    match ordinal_value:
        case 'Ex':
            return 5
        case 'Gd':
            return 4
        case 'TA':
            return 3
        case 'Fa':
            return 2
        case 'Po':
            return 1
        case _:
            raise KeyError(f'Invalid ExterCond key {ordinal_value}')

# WARNING: match requires python 3.10
def convert_functional(ordinal_value):
    """
    Gets the numeric value for the Functional ordinal value
    :param ordinal_value: one of 'Typ', 'Min1', 'Min2', 'Mod', 'Maj1', 'Maj2', 'Sev', 'Sal'
    :return: numeric value from 8 to 1
    """
    match ordinal_value:
        case 'Typ':
            return 8
        case 'Min1':
            return 7
        case 'Min2':
            return 6
        case 'Mod':
            return 5
        case 'Maj1':
            return 4
        case 'Maj2':
            return 3
        case 'Sev':
            return 2
        case 'Sal':
            return 1
        case _:
            raise KeyError(f'Invalid Functional key {ordinal_value}')
