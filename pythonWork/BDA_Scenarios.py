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

#Bellhop's location.
os.chdir(r"C:\Users\fmm17241\OneDrive - University of Georgia\data\toolbox\AT\executables")
#os.chdir(r"C:\Users\fmac4\OneDrive - University of Georgia\data\toolbox\AT\executables")
#Import
import arlpy.uwapm as pm
import arlpy.plot as plt
import matplotlib.pyplot as plt2
import numpy as np
import pandas as pd
############################
#RANGE CREATION
rxFull_Range = np.linspace(0, 1000, 1001)
rxFull_Depth = np.linspace(0, 20, 301)


## SURFACE LEVEL CREATION
# Calls script that generates surfaces for us.
# Flat surface, perfect reflectance expected.
flatSurface = BDA_surfaceLevels.flat_surface()
midSurface = BDA_surfaceLevels.mid_surface()
wavySurface = BDA_surfaceLevels.wavy_surface()

## BATHYMETRY CREATION
flatBottom = BDA_bathymetry.flat_bottom()
downhillBottom = BDA_bathymetry.downhill_bottom()
uphillBottom = BDA_bathymetry.uphill_bottom()

## SSP CREATION
janSSP = BDA_SSP.january(depth=20)
aprSSP = BDA_SSP.april(depth=20)
julSSP = BDA_SSP.july(depth=20)
###############################








# MIXED COLD FLAT
env = pm.create_env2d(
    frequency=69000,
    rx_range= np.linspace(0, 1000, 1001),
    rx_depth= np.linspace(0, 20, 301),
    depth=flatBottom,
    soundspeed=janSSP,
    bottom_soundspeed=1450,
    bottom_density=1200,
    bottom_absorption=0.0,
    tx_depth=9.5,
    surface = flatSurface,
    surface_interp = 'curvilinear',
    nbeams=100
)
pm.print_env(env)






tloss = pm.compute_transmission_loss(env, mode='incoherent')

axxx = pm.plot_transmission_loss(tloss, env=env, clim=[-50,-10], width=900,title='Incoherent Loss: 69 kHz, Flat Surface', clabel='Noise Loss (dBs)')


########################################
