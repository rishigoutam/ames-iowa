"""
Helper module for getting descriptions/labels of Ames Housing features
and mapping ordinal values

See: `../data/data_description.txt` for values
"""

import pandas as pd

# MSSubClass: Identifies the type of dwelling involved in the sale
MSSubClass = pd.Series({
    'Dwelling_20': '1-STORY 1946 & NEWER ALL STYLES',
    'Dwelling_30': '1-STORY 1945 & OLDER',
    'Dwelling_40': '1-STORY W/FINISHED ATTIC ALL AGES',
    'Dwelling_45': '1-1/2 STORY - UNFINISHED ALL AGES',
    'Dwelling_50': '1-1/2 STORY FINISHED ALL AGES',
    'Dwelling_60': '2-STORY 1946 & NEWER',
    'Dwelling_70': '2-STORY 1945 & OLDER',
    'Dwelling_75': '2-1/2 STORY ALL AGES',
    'Dwelling_80': 'SPLIT OR MULTI-LEVEL',
    'Dwelling_85': 'SPLIT FOYER',
    'Dwelling_90': 'DUPLEX - ALL STYLES AND AGES',
    'Dwelling_120': '1-STORY PUD (Planned Unit Development) - 1946 & NEWER',
    'Dwelling_150': '1-1/2 STORY PUD - ALL AGES',
    'Dwelling_160': '2-STORY PUD - 1946 & NEWER',
    'Dwelling_180': 'PUD - MULTILEVEL - INCL SPLIT LEV/FOYER',
    'Dwelling_190': '2 FAMILY CONVERSION - ALL STYLES AND AGES'
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
def __convert_po_to_ex(categorical_value):
    """
    Gets the ordinal value for the given categorical value
    :param categorical_value: one of 'Ex', 'Gd', 'TA', 'Fa', 'Po'
    :return: numeric value from 5 to 1
    """
    match categorical_value:
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


def convert_exterqual(categorical_value):
    return __convert_po_to_ex(categorical_value)


def convert_extercond(categorical_value):
    return __convert_po_to_ex(categorical_value)


def convert_bsmtqual(categorical_value):
    if categorical_value == 'NoBasement':
        return 0
    else:
        return __convert_po_to_ex(categorical_value)


def convert_bsmtcond(categorical_value):
    if categorical_value == "NoBasement":
        return 0
    else:
        return __convert_po_to_ex(categorical_value)


def convert_bsmtexposure(categorical_value):
    match categorical_value:
        case 'Gd':
            return 4
        case 'Av':
            return 3
        case 'Mn':
            return 2
        case 'No':
            return 1
        case 'NoBasement':
            return 0


def convert_bsmtfintype(categorical_value):
    match categorical_value:
        case 'GLQ':
            return 6
        case 'ALQ':
            return 5
        case 'BLQ':
            return 4
        case 'Unf':
            return 1
        case 'LwQ':
            return 2
        case 'Rec':
            return 3
        case 'NoBasement':
            return 0


def convert_functional(categorical_value):
    match categorical_value:
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


def convert_fireplacequ(categorical_value):
    if categorical_value == "NoFireplace":
        return 0
    else:
        return __convert_po_to_ex(categorical_value)


def convert_heatingqc(categorical_value):
    return __convert_po_to_ex(categorical_value)


def convert_kitchenqual(categorical_value):
    return __convert_po_to_ex(categorical_value)


def convert_landslope(categorical_value):
    match categorical_value:
        case 'Gtl':
            return 3
        case 'Mod':
            return 2
        case 'Sev':
            return 0


def convert_lotshape(categorical_value):
    match categorical_value:
        case 'Reg':
            return 4
        case 'IR1':
            return 3
        case 'IR2':
            return 2
        case 'IR3':
            return 1


def convert_garagecond(categorical_value):
    if categorical_value == "NoGarage":
        return 0
    else:
        return __convert_po_to_ex(categorical_value)


def convert_garagequal(categorical_value):
    if categorical_value == "NoGarage":
        return 0
    else:
        return __convert_po_to_ex(categorical_value)


def convert_street(categorical_value):
    match categorical_value:
        case 'Pave':
            return 2
        case 'Grvl':
            return 1


def convert_paveddrive(categorical_value):
    match categorical_value:
        case 'Y':
            return 3
        case 'P':
            return 2
        case 'N':
            return 1


def convert_alley(categorical_value):
    match categorical_value:
        case 'Pave':
            return 2
        case 'Grvl':
            return 1
        case 'NoAlley':
            return 0


def convert_utilities(categorical_value):
    match categorical_value:
        case 'AllPub':
            return 4
        case 'NoSewr':
            return 3
        case 'NoSeWa':
            return 2
        case 'ELO':
            return 1


def convert_poolqc(categorical_value):
    match categorical_value:
        case 'Ex':
            return 4
        case 'Gd':
            return 3
        case 'TA':
            return 2
        case 'Fa':
            return 1
        case 'NoPool':
            return 0  # PoolQC does not have a 'Po' category


def convert_mosold(numerical_value):
    match numerical_value:
        case 1:
            return "January"
        case 2:
            return "February"
        case 3:
            return "March"
        case 4:
            return "April"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "August"
        case 9:
            return "September"
        case 10:
            return "October"
        case 11:
            return "November"
        case 12:
            return "December"
        case _:
            raise KeyError(f"Invalid month: {numerical_value}")


def get_pud_indicator(mssubclass: str):
    """
    :param mssubclass: the dwelling type of the property
    :return: whether the property is in a PUD
    """
    return 'PUD' in MSSubClass[mssubclass]


def get_num_floors(mssubclass: str):
    """
    :param mssubclass: the dwelling type of the property from the 16 choices of MSSubClass
    :return: number of floors in the dwelling type. some assumptions made for split, multi-level, and duplexes
    """
    # NOTE: We could match on `mssubclass` directly, but it's easier to understand the below
    dwelling = MSSubClass[mssubclass]
    if dwelling in ['1-STORY 1946 & NEWER ALL STYLES', '1-STORY 1945 & OLDER', '1-STORY W/FINISHED ATTIC ALL AGES',
                    '1-STORY PUD (Planned Unit Development) - 1946 & NEWER']:
        return 1
    elif dwelling in ['1-1/2 STORY - UNFINISHED ALL AGES', '1-1/2 STORY FINISHED ALL AGES', 'SPLIT FOYER',
                      '1-1/2 STORY PUD - ALL AGES']:
        return 1.5
    elif dwelling in ['2-STORY 1946 & NEWER', '2-STORY 1945 & OLDER', 'SPLIT OR MULTI-LEVEL',
                      'DUPLEX - ALL STYLES AND AGES', '2-STORY PUD - 1946 & NEWER',
                      'PUD - MULTILEVEL - INCL SPLIT LEV/FOYER', '2 FAMILY CONVERSION - ALL STYLES AND AGES']:
        return 2
    elif dwelling in ['2-1/2 STORY ALL AGES']:
        return 2.5
    else:
        raise KeyError(f"Invalid dwelling type detected: {dwelling}")


def collapse_mssubclass(mssubclass: str):
    """
    :param mssubclass: the dwelling type of the property from the 16 choices of MSSubClass
    :return: the collapsed subclass type: Traditional, Split, Duplex
    """
    # NOTE: We could match on `mssubclass` directly, but it's easier to understand the below
    dwelling = MSSubClass[mssubclass]
    if dwelling in ['1-STORY 1946 & NEWER ALL STYLES', '1-STORY 1945 & OLDER',
                    '1-STORY PUD (Planned Unit Development) - 1946 & NEWER',
                    '1-1/2 STORY - UNFINISHED ALL AGES', '1-1/2 STORY FINISHED ALL AGES',
                    '1-1/2 STORY PUD - ALL AGES', '1-STORY W/FINISHED ATTIC ALL AGES',
                    '2-STORY 1946 & NEWER', '2-STORY 1945 & OLDER',
                    '2-STORY PUD - 1946 & NEWER', '2-1/2 STORY ALL AGES']:
        return 'Traditional'
    elif dwelling in ['SPLIT FOYER', 'SPLIT OR MULTI-LEVEL', 'PUD - MULTILEVEL - INCL SPLIT LEV/FOYER']:
        return 'Split'
    elif dwelling in ['DUPLEX - ALL STYLES AND AGES', '2 FAMILY CONVERSION - ALL STYLES AND AGES']:
        return 'Duplex'
    else:
        raise KeyError(f"Invalid dwelling type detected: {dwelling}")


def get_bad_condition_indicator(categorical_value):
    match categorical_value:
        case 'Artery' | 'RRNn' | 'RRAn' | 'RRNe' | 'RRAe':
            return True
        case _:
            return False

def get_good_condition_indicator(categorical_value):
    match categorical_value:
        case 'PosN' | 'PosA':
            return True
        case _:
            return False