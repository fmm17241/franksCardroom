# -*- coding: utf-8 -*-
"""
Created on Thu Dec 19 18:07:44 2024

@author: fmm17241
"""

#############################
#import arlpy
import os
import arlpy.uwapm as pm
import arlpy.plot as plt
#import matplotlib.pyplot as plt2
import numpy as np
import pandas as pd
#import shutil
#import inspect

os.chdir(r"C:\Users\fmm17241\Documents\GitHub\franksCardroom\pythonWork")
from BDA_createEnv import createEnv
#import BDA_surfaceLevels
#import BDA_bathymetry
#import BDA_SSP

#Bellhop's location.
os.chdir(r"C:\Users\fmm17241\OneDrive - University of Georgia\data\toolbox\AT\executables")
#os.chdir(r"C:\Users\fmac4\OneDrive - University of Georgia\data\toolbox\AT\executables")

###############################
# DEFINING THE ENVIRONMENT

env, topDescrip, botDescrip, sspDescrip = createEnv(
#env = createEnv(
    surface_type = "F",
    bottom_type = "U",
    ssp_type = "Jan",
    range    = 1000,
    depth    = 20,
    frequency=69000,
    nBeams = 1000,
    receiverType = "topPoint",
    transDepth= "M",
    bottom_soundspeed=1450,
    bottom_density=1200,
    bottom_absorption=0.0
)

###############################
# MODELING RAYS THROUGH THE ENVIRONMENT

# ALL RAYS
rays = pm.compute_rays(env)
#rays = pm.compute_eigenrays(env)
pm.plot_rays(rays, env=env,
             width=900,
             title= f"Ray Tracing: 69 kHz,{topDescrip}, {botDescrip}, {sspDescrip} Environment") 

###############################
# BDA, QUANTIFYING RAY DISTANCE TRAVELED

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


###############################
# PLOT BEAM DENSITY ANALYSIS RESULTS

sumBDA = np.sum(beamDistances, axis=0)
dataFraming = pd.DataFrame({'Distance': distances_to_check, 'Rays': sumBDA})
plt.plot(dataFraming['Distance'], dataFraming['Rays'], 'o-', xlabel='Distances', ylabel='Beams Traveled', title='Beam Density Analysis: FLat Environment')






test = rays_per_distance/1000

# Using range to generate numbers
x = np.arange(0, 1001, 25)
###########

#Computes the arrival time of rays from T to R
arrivals = pm.compute_arrivals(env)
pm.plot_arrivals(arrivals, width=500,title='Arrival Timing: Flat Surface')

#Table of arrival times
arrivals[['time_of_arrival', 'angle_of_arrival', 'surface_bounces', 'bottom_bounces']]

arrivalsFlat = arrivals
test = np.mean(arrivals['arrival_amplitude'])








