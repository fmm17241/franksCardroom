# -*- coding: utf-8 -*-
"""
Created on Wed Dec 18 11:48:22 2024

@author: fmm17241
"""

# I need to do this so I can leave.


import arlpy
import os
import shutil
import inspect
#Find where bellhop is, then set path
os.chdir(r"C:\Users\fmm17241\OneDrive - University of Georgia\data\toolbox\AT\executables")
#os.chdir(r"C:\Users\fmac4\OneDrive - University of Georgia\data\toolbox\AT\executables")
#Import
import arlpy.uwapm as pm
import arlpy.plot as plt
import matplotlib.pyplot as plt2
import numpy as np
import pandas as pd


#Modeling calm day

#Sets bottom boundary layer of the environment
bathy = [
    [0, 15],    # 20 m water depth at the transmitter
    [200, 17],    # 20 m water depth at the transmitter    
    [300, 17],  # 15 m water depth 300 m away
    [350, 18],  # 15 m water depth 300 m away
    [600, 20],  # 20 m water depth at 600 m
    [800, 20]
]

#Changes soundspeed profile
ssp = [
    [ 0, 1540],  # 1540 m/s at the surface
    [10, 1530],  # 1530 m/s at 10 m depth
    [15, 1532],  # 1532 m/s at 20 m depth
    [20, 1533],  # 1533 m/s at 25 m depth
]


#Creates new environment, accounting for change in SSP and bathy, then prints & plots. This is for transmission loss.
env = pm.create_env2d(
    frequency=69000,
    rx_range= np.linspace(0, 450, 1001),
    rx_depth= np.linspace(0, 20, 301),
    depth=bathy,
    soundspeed=ssp,
    bottom_soundspeed=1450,
    bottom_density=1200,
    bottom_absorption=0.0,
    tx_depth=13.5,
   # surface = surface,
    surface_interp = 'curvilinear'
)
pm.print_env(env)














surface = np.array([[r, 2.0+2.0*np.sin(10*np.pi*0.002*r)] for r in np.linspace(0,600,601)])