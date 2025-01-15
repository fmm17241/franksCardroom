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

#Bellhop's location.
os.chdir(r"C:\Users\fmm17241\OneDrive - University of Georgia\data\toolbox\AT\executables")
#os.chdir(r"C:\Users\fmac4\OneDrive - University of Georgia\data\toolbox\AT\executables")

###############################
# DEFINING THE ENVIRONMENT
# Copied from createEnv():
#Create an underwater environment with the given parameters.
#
#Args:
#    surface_type: Surface configuration (e.g., flatSurface, midSurface).
#        F : Flat
#        M : Mid
#        W : wavy
#    bottom_type: Bottom configuration (e.g., flatBottom, downhillBottom).
#        F : Flat
#        D : Downhill
#        U : Uphill
#        C : Complex
#    ssp_type: Sound speed profile (e.g., janSSP, aprSSP).
#        Listed SSPs 1-8, or:
#        exampleJan : January 2020 example, homogeneous
#        exampleApr : April  2020 example profile, strong shelf
#        exampleJul : July  2020 example profile, diurnal strat.
#    frequency: Transmission frequency in Hz.
#    receiverDepth: Receiver ranges and depths (array), sets rx_range and rx_depth.
#        TL : Full column for plotting Transmission Loss
#        B : Specific receiver, 1 m off bottom
#        T : Specific receiver, 1 m off surface
#    tx_depth: Transmitter depth.
#        T : 1.5 meter off top
#        M : Halfway between top and bottom
#        B : 1.5 m off bottom
#    bottom_soundspeed: Sound speed of the bottom.
#    bottom_density: Density of the bottom.
#    bottom_absorption: Absorption of the bottom.
#
#Returns:
#    Configured environment object.
#

env, topDescrip, botDescrip, sspDescrip = createEnv(
#env = createEnv(
    surface_type = "M",
    bottom_type = "F",
    ssp_type = "gliderProfile6",
    range    = 1000,
    frequency=69000,
    nBeams = 1000,
    receiverType = "TL",
    transDepth= "B",
    bottom_soundspeed=1450,
    bottom_density=1200,
    bottom_absorption=0.0
)


pm.print_env(env)
pm.plot_env(env)


###############################
# MODELING RAYS THROUGH THE ENVIRONMENT
#Bellhop's location.
os.chdir(r"C:\Users\fmm17241\OneDrive - University of Georgia\data\toolbox\AT\executables")
#os.chdir(r"C:\Users\fmac4\OneDrive - University of Georgia\data\toolbox\AT\executables")
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
plt.plot(dataFraming['Distance'], dataFraming['Rays'], 'o-', xlabel='Distances', ylabel='Beams Traveled', title='Beam Density Analysis: Flat Environment')






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








