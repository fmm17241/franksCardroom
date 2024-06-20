# -*- coding: utf-8 -*-
"""
Created on Thu Jun 20 11:11:29 2024

@author: fmm17241
"""
import os
import sys
sys.path.append(os.path.abspath(r"C:\Users\fmm17241\Documents\GitHub\franksCardroom\pythonWork"))


import arlpy
import shutil
import numpy as np
import gsw
from datetime import datetime, timedelta
import matplotlib.pyplot as plt
import fileManagement
import gliderDataProcessing
import arlpy.uwapm as pm
import stl

# add/change bathy to env
bathy = [
    [0, 30],    # 30 m water depth at the transmitter
    [300, 20],  # 20 m water depth 300 m away
    [1000, 25]  # 25 m water depth at 1 km
]

# add/change SSP to env
ssp = [
    [ 0, 1540],  # 1540 m/s at the surface
    [10, 1530],  # 1530 m/s at 10 m depth
    [20, 1532],  # 1532 m/s at 20 m depth
    [25, 1533],  # 1533 m/s at 25 m depth
    [30, 1535]   # 1535 m/s at the seabed
]



os.chdir(r"C:\Users\fmm17241\OneDrive - University of Georgia\data\toolbox\AT\executables")
# Appending ssp and bathy to existing env file
env = pm.create_env2d(
    depth=bathy,
    soundspeed=ssp,
    bottom_soundspeed=1450,
    bottom_density=1200,
    bottom_absorption=1.0,
    tx_depth=15
)
pm.print_env(env)

pm.plot_env(env, width=900)

rays = pm.compute_eigenrays(env)
pm.plot_rays(rays, env=env, width=900)

rays = pm.compute_rays(env)
pm.plot_rays(rays, env=env, width=900)

import numpy as np
from scipy.interpolate import griddata
import scipy.ndimage as ndimage
from scipy.ndimage import gaussian_filter
import scipy
# from scipy.misc import imsave
from matplotlib import cm
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

from stl import mesh, Mode
import matplotlib.tri as mtri
from mpl_toolkits.mplot3d.axes3d import get_test_data
from pandas import read_csv



data = read_csv('bathy.txt', sep='\s+', header=None, names=['x', 'y', 'depth'])

x = np.arange(data.x.min(), data.x.max()+1)
y = np.arange(data.y.min(), data.y.max()+1)

X, Y = np.meshgrid(x, y)

Z = griddata(data[['x','y']].values, -data['depth'].values, (X, Y), method='linear')

# make the grid square
Z[np.isnan(Z)] = 0

fig = plt.figure(figsize=(14, 8))
ax = fig.add_subplot(111)
plt.imshow(Z)
plt.show()