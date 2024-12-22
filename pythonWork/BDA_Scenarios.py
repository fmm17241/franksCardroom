# -*- coding: utf-8 -*-
"""
Created on Thu Dec 19 18:07:44 2024

@author: fmm17241
"""

#############################
import arlpy
import os
import shutil
import inspect

os.chdir(r"C:\Users\fmm17241\Documents\GitHub\franksCardroom\pythonWork")


import BDA_surfaceLevels
import BDA_bathymetry
import BDA_SSP
from BDA_createEnv import createEnv

#Bellhop's location.
os.chdir(r"C:\Users\fmm17241\OneDrive - University of Georgia\data\toolbox\AT\executables")
#os.chdir(r"C:\Users\fmac4\OneDrive - University of Georgia\data\toolbox\AT\executables")
#Import
import arlpy.uwapm as pm
import arlpy.plot as plt
import matplotlib.pyplot as plt2
import numpy as np
import pandas as pd


#################################
#RANGE CREATION
range = 1000
depth = 20

rx_Range_TL = np.linspace(0, range, range+1)
rx_Depth_TL = np.linspace(0, depth, depth+1)


rx_Range_Rays = range
rx_Depth_Rays = depth
#################################

###############################
# DEFINING THE ENVIRONMENT

# Description for Plot title
topDescrip = "Flat Surface"
botDescrip  = "Downhill"
sspDescrip     = "Homogeneous"


env = createEnv(
    surface_type = "F",
    bottom_type = "F",
    ssp_type = "Jan",
    range    = 1000,
    depth    = 20,
    frequency=69000,
    nBeams = 1000,
    receiverType = "botPoint",
    transDepth= "B",
    bottom_soundspeed=1450,
    bottom_density=1200,
    bottom_absorption=0.0
)


env = createEnv()



tloss = pm.compute_transmission_loss(env, mode='incoherent')
axxx = pm.plot_transmission_loss(tloss, 
                                 env=env, 
                                 clim=[-50,-10], width=900,
                                 title= f"Incoherent Loss: 69 kHz,{topDescrip}, {botDescrip}, {sspDescrip} Environment", 
                                 clabel='Noise Loss (dBs)')


########################################
