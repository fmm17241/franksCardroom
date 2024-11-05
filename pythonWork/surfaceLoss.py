# -*- coding: utf-8 -*-
"""
Created on Tue Nov  5 13:11:55 2024

@author: fmm17241
"""

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


env = pm.create_env2d()
pm.print_env(env)

print(inspect.signature(pm.create_env2d))


#Sets bottom boundary layer of the environment
bathy = [
    [0, 15],    # 20 m water depth at the transmitter
    [200, 17],    # 20 m water depth at the transmitter    
    [300, 17],  # 15 m water depth 300 m away
    [350, 18],  # 15 m water depth 300 m away
    [600, 20]  # 20 m water depth at 600 m
]

#Changes soundspeed profile
ssp = [
    [ 0, 1540],  # 1540 m/s at the surface
    [10, 1530],  # 1530 m/s at 10 m depth
    [15, 1532],  # 1532 m/s at 20 m depth
    [20, 1533],  # 1533 m/s at 25 m depth
]

surface = np.array([[r, 2.0+2.0*np.sin(10*np.pi*0.002*r)] for r in np.linspace(0,600,601)])
os.chdir(r"C:\Users\fmm17241\OneDrive - University of Georgia\data\toolbox\AT\executables")


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
    surface = surface,
    surface_interp = 'curvilinear'
)
pm.print_env(env)

#CComputes incoherent transmission loss through the environment
tloss = pm.compute_transmission_loss(env, mode='incoherent')

axxx = pm.plot_transmission_loss(tloss, env=env, clim=[-60,-30], width=900,title='Incoherent Loss: 69 kHz, Wavy Surface', clabel='Noise Loss (dBs)')

plt2.axhline(y=2.5, color='r', linestyle='--')


rays = pm.compute_rays(env)
pm.plot_rays(rays, env=env,width=900)

