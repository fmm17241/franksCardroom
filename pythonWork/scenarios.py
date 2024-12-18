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
    [0, 20],    # 20 m water depth at the transmitter
    [200, 20],    # 20 m water depth at the transmitter    
    [300, 20],  # 15 m water depth 300 m away
    [350, 20],  # 15 m water depth 300 m away
    [600, 20],  # 20 m water depth at 600 m
    [800, 20],
    [1000, 20],
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
    rx_range= np.linspace(0, 1000, 1001),
    rx_depth= np.linspace(0, 20, 301),
    depth=bathy,
    soundspeed=ssp,
    bottom_soundspeed=1450,
    bottom_density=1200,
    bottom_absorption=0.0,
    tx_depth=18.5,
   # surface = surface,
    surface_interp = 'curvilinear',
    nbeams=1000
)
pm.print_env(env)

tloss = pm.compute_transmission_loss(env, mode='incoherent')

axxx = pm.plot_transmission_loss(tloss, env=env, clim=[-50,-10], width=900,title='Incoherent Loss: 69 kHz, Flat Surface', clabel='Noise Loss (dBs)')


rays = pm.compute_rays(env)
pm.plot_rays(rays, env=env,width=900)

#######
# Okay I've got to loop and try Beam Density Analysis in Python.
rayMax = []
beamDistances = []
distances_to_check = list(range(0, 1001, 25))

for ray_array in rays.ray:
    # Ensure ray_array is a NumPy array
    ray_array = np.array(ray_array)
    
    # Get the maximum value from the first column (distance)
    max_value = max(ray_array[:, 0])
    rayMax.append(max_value)
    
    # Create the binary list
    binary_values = []
    for distance in distances_to_check:
        if max_value > distance:
            binary_values.append(1)
        else:
            binary_values.append(0)
    
    beamDistances.append(binary_values)

print("Maximum distances for each ray:", rayMax)
print("Binary distance checks:", beamDistances[:5])  # First 5 for brevity


# Convert beamDistances to a NumPy array for easier summation
beamDistances_array = np.array(beamDistances)

# Sum along the rows (axis=0) to get the count for each distance
rays_per_distance = np.sum(beamDistances_array, axis=0)

# Print the results
for distance, count in zip(distances_to_check, rays_per_distance):
    print(f"Distance: {distance} m, Rays: {count}")
    
    
rays['rayDistance'] = rayMax


x = np.arange(0, 1001, 25)


##########
sumBDA = np.sum(beamDistances, axis=0)
dataFraming = pd.DataFrame({'Distance': distances_to_check, 'Rays': sumBDA, 'Efficiency': sumBDA/1000})
plt.plot(dataFraming['Distance'], dataFraming['Efficiency'], 'o-', xlabel='Distances', ylabel='% of Beams Traveled', title='Beam Density Analysis: Flat Environment')

########################################


surface = np.array([[r, 2.0+2.0*np.sin(10*np.pi*0.002*r)] for r in np.linspace(0,1000,1001)])

#Creates new environment, accounting for change in SSP and bathy, then prints & plots. This is for transmission loss.
env = pm.create_env2d(
    frequency=69000,
    rx_range= np.linspace(0, 1000, 1001),
    rx_depth= np.linspace(0, 20, 301),
    depth=bathy,
    soundspeed=ssp,
    bottom_soundspeed=1450,
    bottom_density=1200,
    bottom_absorption=0.0,
    tx_depth=18.5,
    surface = surface,
    surface_interp = 'curvilinear',
    nbeams=1000
)
pm.print_env(env)







surface = np.array([[r, 2.0+2.0*np.sin(10*np.pi*0.002*r)] for r in np.linspace(0,600,601)])