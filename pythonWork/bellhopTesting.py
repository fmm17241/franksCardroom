# -*- coding: utf-8 -*-
"""
Created on Thu Jun 20 11:11:29 2024

@author: fmm17241
"""
#Walking through 2021 intro to bellhop. lol

import arlpy.uwapm as pm
import arlpy.plot as plt
import numpy as np

env = pm.create_env2d()
ssp = [
[ 0, 1540], # 1540 m/s at the surface
[10, 1530], # 1530 m/s at 10 m depth
[20, 1532], # 1532 m/s at 20 m depth
[25, 1533], # 1533 m/s at 25 m depth
[30, 1535] # 1535 m/s at the seabed
            ]

env = pm.create_env2d(soundspeed=ssp)
pm.plot_ssp(env, width=500)

# Plotting an Environment using ARLPY
pm.plot_env(env, width=900)



# Eigenrays using ARLPY
import arlpy.uwapm as pm
import arlpy.plot as plt
import numpy as np
env = pm.create_env2d()
rays = pm.compute_eigenrays(env)
pm.plot_rays(rays, env=env, width=900)

# compute the arrival structure at the receiver
arrivals = pm.compute_arrivals(env)
pm.plot_arrivals(arrivals, width=900)


arrivals[arrivals.arrival_number < 10][['time_of_arrival', 'angle_of_arrival','surface_bounces', 'bottom_bounces']]



# convert to a impulse response time series
ir = pm.arrivals_to_impulse_response(arrivals, fs=96000)
plt.plot(np.abs(ir), fs=96000, width=900)

# add/change bathy to env
bathy = [
[0, 30], # 30 m water depth at the transmitter
[300, 20], # 20 m water depth 300 m away
[1000, 25] # 25 m water depth at 1 km
]
# add/change SSP to env
ssp = [
[ 0, 1540], # 1540 m/s at the surface
[10, 1530], # 1530 m/s at 10 m depth
[20, 1532], # 1532 m/s at 20 m depth
[25, 1533], # 1533 m/s at 25 m depth
[30, 1535] # 1535 m/s at the seabed
]
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
Z = griddata(data[['x','y']].values, -data['depth'].values, (X, Y),method='linear')

# make the grid square
Z[np.isnan(Z)] = 0
fig = plt.figure(figsize=(14, 8))
ax = fig.add_subplot(111)
plt.imshow(Z)
plt.show()

env['rx_range'] = np.linspace(0, 1000, 1001)
env['rx_depth'] = np.linspace(0, 30, 301)






















































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




import pandas as pd

sea_state = 3
# Ambient noise table
# TODO: Convert to lookup table based on sea_state and scenario.tx_frequency
an = pd.DataFrame({
1: [34], # profile at SS1
2: [39], # profile at SS2
3: [47], # profile at SS3
4: [50], # profile at SS4
5: [52], # profile at SS5
6: [54]}, # profile at SS6
index=[20000]) # frequency of profiles in Hz



























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


#FRANK figuring out what "bathy.txt" looks like, hmhhmhmmhfgfnhndnh
#Path: C:\Users\fmm17241\OneDrive - University of Georgia\data\bellhopTesting
#Created a bathy.txt but I want to find an example of one so I can easily model in it.



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