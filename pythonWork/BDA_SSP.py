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
profilesDataFrame = [pandas.read_csv(file, header=None) for file in file_paths]


columnNames = ['Depth', 'SoundSpeed']

for df in profilesDataFrame:
    df.columns = columnNames
    

#########################################################################
for i, df in enumerate(profilesDataFrame):
    profilesDataFrame[i].columns = [col.strip().lower() for col in df.columns]

def get_profile(profilesDataFrame, index):
    """
    Returns the Depth and Soundspeed columns from a specific profile.

    Parameters:
        profilesDataFrame (list): List of DataFrames containing profile data.
        index (int): Index of the desired profile in the list (e.g., 0 for "one").

    Returns:
        DataFrame: A DataFrame with the Depth and Soundspeed columns from the selected profile.
    """
    # Ensure the index is within the range of profiles
    if index < 0 or index >= len(profilesDataFrame):
        raise IndexError("Index out of range for profiles list.")
    
    # Select the DataFrame at the given index
    selected_profile = profilesDataFrame[index]

    # Check for normalized column names
    if not {"depth", "soundspeed"}.issubset(selected_profile.columns):
        raise ValueError("Selected profile does not contain required columns: 'depth' and 'soundspeed'.")
    
    # Return the relevant columns as a new DataFrame
    return selected_profile[["depth", "soundspeed"]]


def gliderProfile(profilesDataFrame, index):
    """
    Returns the Depth and Soundspeed data for a specific profile.

    Parameters:
        profilesDataFrame (list): List of DataFrames containing profile data.
        index (int): Index of the desired profile in the list.

    Returns:
        list: A list of [Depth, Soundspeed] pairs from the selected profile.
    """
    # Get the selected profile
    selected_profile = get_profile(profilesDataFrame, index)

    # Convert the data into bellhop format: [Depth, Soundspeed]
    profile_list = selected_profile.values.tolist()

    return profile_list

# Example usage:
# `profilesDataFrame` is SSP profiles from glider
profile_one = gliderProfile(profilesDataFrame, index=7)  # Get the first profile
print(profile_one)




###########################################################

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


