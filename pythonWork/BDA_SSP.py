# -*- coding: utf-8 -*-
"""
Created on Thu Dec 19 19:52:10 2024

@author: fmm17241
"""
import pandas
import glob
import os
os.chdir(r"C:\Users\fmm17241\OneDrive - University of Georgia\data\Chapter5Scenarios\SSPs\aprilMay")



# Find all .csv files in working folder
file_paths = glob.glob("*.csv")

# Read in all .csv files as data frames
profiles = [pandas.read_csv(file, header=None) for file in file_paths]


columnNames = ['Depth', 'SoundSpeed']

for df in profiles:
    df.columns = columnNames
    
    
print(profiles[0].head())



# Frank is loading in SSPs from Matlab processing




def exampleJan(depth=20):
    return [
        [0, 1540],  # 1540 m/s at the surface
        [depth-(depth*0.9), 1540],  # 1530 m/s at 10 m depth
        [depth-(depth*0.5), 1540],  # 1532 m/s at 20 m depth
        [depth-(depth*0.2), 1540],  # 1533 m/s at 25 m depth
        [depth, 1540],  # 1533 m/s at 25 m depth
    ]

def exampleApr(depth=20):
    return [[0, 1540],  # 1540 m/s at the surface
        [depth-(depth/0.9), 1538.5],  # 1530 m/s at 10 m depth
        [depth-(depth/0.5), 1538.5],  # 1532 m/s at 20 m depth
        [depth-(depth/0.2), 1537],  # 1533 m/s at 25 m depth
        [depth, 1537],  # 1533 m/s at 25 m depth
    ]

def exampleJul(depth=20):
    return [
        [0, 1540],  # 1540 m/s at the surface
        [depth-(depth/0.9), 1538],  # 1530 m/s at 10 m depth
        [depth-(depth/0.5), 1537],  # 1532 m/s at 20 m depth
        [depth-(depth/0.2), 1537],  # 1533 m/s at 25 m depth
        [depth, 1537],  # 1533 m/s at 25 m depth
    ]


