"""
Spyder Editor

This is a temporary script file.
"""
" This is arlpy.readthedocs.io testing for Bellhop"

#pip install arlpy
import arlpy
import os
import shutil

import arlpy.uwapm as pm
import arlpy.plot as plt
import numpy as np
import pandas as pd


###################################################################
#Find where bellhop is, then set path
os.chdir(r"C:\Users\fmm17241\OneDrive - University of Georgia\data\toolbox\AT\executables")
#os.chdir(r"C:\Users\fmac4\OneDrive - University of Georgia\data\toolbox\AT\executables")


## Creates an environment to use Bellhop and BDA in.
#Sets bottom boundary layer of the environment
bathy = [
    [0, 15],    # 20 m water depth at the transmitter
    [200, 17],    # 20 m water depth at the transmitter    
    [300, 17],  # 15 m water depth 300 m away
    [350, 18],  # 15 m water depth 300 m away
    [450, 20],  # 20 m water depth at 600 m
    [1000, 20]
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
    rx_range= 1000,
    rx_depth= 18.5,
    depth=bathy,
    soundspeed=ssp,
    bottom_soundspeed=1450,
    bottom_density=1200,
    bottom_absorption=0.0,
    tx_depth=12.5,
    nbeams=1000
)
pm.print_env(env)
pm.plot_env(env)



rays = pm.compute_eigenrays(env)
pm.plot_rays(rays, env=env,width=900,title='Ray Tracing: Flat Surface')



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

##########
sumBDA = np.sum(beamDistances, axis=0)
dataFraming = pd.DataFrame({'Distance': distances_to_check, 'Rays': sumBDA})
plt.plot(dataFraming['Distance'], dataFraming['Rays'], 'o-', xlabel='Distances', ylabel='Beams Traveled', title='Beam Density Analysis: FLat Environment')


#################################################
###################
#Changes the surface, wave motion
#This is different type of wave
#surface = np.array([[r, 0.5+0.5*np.sin(2*np.pi*0.005*r)] for r in np.linspace(0,450,451)])
surface = np.array([[r, 2.0+2.0*np.sin(10*np.pi*0.002*r)] for r in np.linspace(0,1000,1001)])

#Creates new environment, accounting for change in SSP and bathy, then prints & plots. This is for transmission loss.
env = pm.create_env2d(
    frequency=69000,
    rx_range= 1000,
    rx_depth= 18.5,
    depth=bathy,
    soundspeed=ssp,
    bottom_soundspeed=1450,
    bottom_density=1200,
    bottom_absorption=0.0,
    tx_depth=13.5,
    surface = surface,
    surface_interp = 'curvilinear',
    nbeams = 1000
)
pm.print_env(env)
pm.plot_env(env)



rays = pm.compute_rays(env)
pm.plot_rays(rays, env=env,width=900,title='Ray Tracing: Higher Wavy Surface')

rayMax = []
beamDistances = []
distances_to_check = list(range(0,1001,25))


for ray_array in rays.ray:
    max_value = max(ray_array[:,0])
    binary_values = []
    for distance in distances_to_check:
        if max_value > distance: 
            binary_values.append(1)
        else:
            binary_values.append(0)
            
            
    rayMax.append(max_value)
    beamDistances.append(binary_values)
    

rays['rayDistance'] = rayMax


#Computes the arrival time of rays from T to R
arrivals = pm.compute_arrivals(env)
pm.plot_arrivals(arrivals, width=500,title='Arrival Timing: Higher Wavy Surface')

##########
sumBDA = np.sum(beamDistances, axis=0)
dataFraming = pd.DataFrame({'Distance': distances_to_check, 'Rays': sumBDA})
plt.plot(dataFraming['Distance'], dataFraming['Rays'], 'o-', xlabel='Distances', ylabel='Beams Traveled', title='Beam Density Analysis: Very Wavy Environment')


########################################
#tloss = pm.compute_transmission_loss(env, mode='incoherent')
#axxx = pm.plot_transmission_loss(tloss, 
#                                 env=env, 
#                                 clim=[-50,-10], width=900,
#                                 title= f"Incoherent Loss: 69 kHz,{topDescrip}, {botDescrip}, {sspDescrip} Environment", 
#                                 clabel='Noise Loss (dBs)')
