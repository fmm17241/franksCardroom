# -*- coding: utf-8 -*-
"""
Created on Fri Dec 20 14:51:49 2024

@author: fmm17241

Okay. Frank's trying to streamline the creation of environments for modeling.

Instead of retyping every time, I'm adding uses to this code.

Now I can call this code later to create bellhop environments.

"""

import arlpy.uwapm as pm
import numpy as np
import BDA_surfaceLevels
import BDA_bathymetry
import BDA_SSP
import glob
import pandas as pd
#
#import BDA_surfaceLevels
#import BDA_bathymetry
#import BDA_SSP

# LOADS IN GLIDER DATA TO CREATE PROFILES

# Find all .csv files in working folder
file_paths = glob.glob("*.csv")

# Read in all .csv files as data frames
profilesDataFrame = [pd.read_csv(file, header=None) for file in file_paths]
columnNames = ['Depth', 'SoundSpeed']
for df in profilesDataFrame:
    df.columns = columnNames
#########################################################################
for i, df in enumerate(profilesDataFrame):
    profilesDataFrame[i].columns = [col.strip().lower() for col in df.columns]
#####


def createEnv(
    surface_type = "F",
    bottom_type = "F",
    ssp_type = "exampleJan",
    range    = 1000,
    depth    = 20,
    frequency=69000,
    nBeams = 1000,
    receiverType = "B",
    transDepth=12.5,
    bottom_soundspeed=1450,
    bottom_density=1200,
    bottom_absorption=0.0
):
    """
    Create an underwater environment with the given parameters.
    
    Args:
        surface_type: Surface configuration (e.g., flatSurface, midSurface).
            F : Flat
            M : Mid
            W : wavy
        bottom_type: Bottom configuration (e.g., flatBottom, downhillBottom).
            F : Flat
            D : Downhill
            U : Uphill
            C : Complex
        ssp_type: Sound speed profile (e.g., janSSP, aprSSP).
            exampleJan : January 2020 example, homogeneous
            exampleApr : April  2020 example profile, strong shelf
            exampleJul : July  2020 example profile, diurnal strat.
        frequency: Transmission frequency in Hz.
        receiverType: Receiver ranges and depths (array), sets rx_range and rx_depth.
            F : Full column for plotting Transmission Loss
            B : Specific source of sound, 1 m off bottom
            T : Specific source of sound, 1 m off surface
        tx_depth: Transmitter depth.
            T : 1.5 meter off top
            M : Halfway between top and bottom
            B : 1.5 m off bottom
        bottom_soundspeed: Sound speed of the bottom.
        bottom_density: Density of the bottom.
        bottom_absorption: Absorption of the bottom.

    Returns:
        Configured environment object.
    """
# Validate surface_type
    valid_surface_types = ["F", "M", "W"]
    if surface_type not in valid_surface_types:
        raise ValueError(f"Invalid surface_type '{surface_type}'. Must be 'F' for flat, 'M' for Mid, or 'W' for Wavy.")

    
########### 
    if surface_type == "F":
        surface = BDA_surfaceLevels.flat_surface()
        topDescrip = "Flat Surface"
        
    elif surface_type == "M":  
        surface = BDA_surfaceLevels.mid_surface()
        topDescrip = "Disturbed Surface"
        
    elif surface_type == "W":    
        surface = BDA_surfaceLevels.wavy_surface()
        topDescrip = "Wavy Surface"
    else:
       raise ValueError(f"Invalid surface_type '{surface_type}'. Must be 'F' for flat, 'M' for Mid, or 'W' for Wavy.")

###########
    if bottom_type == "F":
        bottom = BDA_bathymetry.flat_bottom()
        botDescrip  = "Flat Bottom"
        
    elif bottom_type == "D":
        bottom = BDA_bathymetry.downhill_bottom()
        botDescrip  = "Downhill"
        
    elif bottom_type == "U":
        bottom = BDA_bathymetry.uphill_bottom()
        botDescrip  = "Uphill"
        
    elif bottom_type == "C":
        bottom = BDA_bathymetry.complex_bottom()
        botDescrip  = "Structured"
        
    else:
        raise ValueError(f"Invalid bottom_type '{bottom_type}'. Must be 'F' for flat, 'D' for downhill, 'U' for uphill, or 'C' for complex.")
  
###########
    if receiverType == "F":
        rx_range = np.linspace(0, range, range+1)
        rx_depth = np.linspace(0, depth, depth+1)
    elif receiverType == "B":
       rx_range = range
       rx_depth = depth-1        # Receiver bottom of water column
    elif receiverType == "T":
       rx_range = range              
       rx_depth = 2
    else:
       raise ValueError(f"Invalid receiver_type '{receiverType}'. Must be 'F' for full/transmission loss, 'B' for bottom, or 'T' for top.")
       
########### 
    if ssp_type == "exampleJan":
        soundspeed = BDA_SSP.january(depth=depth)
        sspDescrip     = "Homogeneous"
        
    elif ssp_type == "exampleApr":
        soundspeed = BDA_SSP.april(depth=depth)
        sspDescrip     = "Freshwater Lens"
        
    elif ssp_type == "exampleJul":
        soundspeed = BDA_SSP.july(depth=depth)
        sspDescrip     = "Stratified"
        
    elif ssp_type == "gliderProfile1":
        soundspeed = BDA_SSP.gliderProfile(profilesDataFrame, index=0)
        sspDescrip     = "Example1"
    
    else:
        raise ValueError(f"Invalid ssp_type '{ssp_type}'. Must be 'exampleJan', 'exampleApr', or 'exampleJul'.")

########### 
    if transDepth == "T": 
        tx_depth = 1.5
    elif transDepth == "M":
        tx_depth = depth-depth/2
    elif transDepth == "B":
        tx_depth = depth-1.5
    else:
        raise ValueError(f"Invalid transDepth '{transDepth}'. Must be 'T' for top, 'M' for mid, or 'B' for bottom.")
  
        
###########    
    # Create the environment
    env = pm.create_env2d(
        frequency=frequency,
        rx_range=rx_range,
        rx_depth=rx_depth,
        depth=bottom,
        soundspeed=soundspeed,
        bottom_soundspeed=bottom_soundspeed,
        bottom_density=bottom_density,
        bottom_absorption=bottom_absorption,
        tx_depth=tx_depth,
        surface=surface,
        surface_interp='curvilinear',
        nbeams=nBeams
    )

    return env, topDescrip, botDescrip, sspDescrip