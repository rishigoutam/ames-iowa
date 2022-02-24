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

