# -*- coding: utf-8 -*-
"""
Created on Thu Jun 13 10:02:57 2024

@author: fmm17241
"""


#Move filepath to where I keep scripts
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

#################################################################################
#Frank's file for organizing and picking files. 
from fileManagement import wilddir, extract_column, get_last_file_path
#################################################################################
#Frank's converting Matlab scripts to Python, this is a way to keep my data processing files in one place.
from gliderDataProcessing import beautifyData, read_gliderasc, yoDefiner, datenum_to_datetime 
###################################################################################
#just including my soundspeed calculations
from soundSpeed import sound_speed_mackenzie
###################################################################################


#Change directory to where I want to read files from, and also define a variable with the same place. These two can be separate.
os.chdir(r"C:\Users\fmm17241\OneDrive - University of Georgia\data\Glider\Data\nbdasc\Test")

datadir = (r"C:\Users\fmm17241\OneDrive - University of Georgia\data\Glider\Data\nbdasc\Test")


## Finds all the files matching the prefix in the data directory
#This can be changed to tbd or sbd as well, but nbd is one single profile so good for us.
files, Dout, nfile = wilddir(datadir, '.nbdasc')

#list files
for file in files:
    print(file)

#Find the path to the last file in the folder; this would in theory be the last one created so most recent.
last_file_path = get_last_file_path(datadir)

# Reads in glider data, then beautifies it: datetimes, converts to usable salinity/depth units, then separates the data by "yo"s, glider profiles.
dstruct = read_gliderasc(last_file_path)
dt, dn, temperature, salt, density, depth, pressure, speed = beautifyData(dstruct)
yoSSP, yotemps, yotimes, yodepths, yosalt, yospeed = yoDefiner(dn, depth, temperature, salt, speed);


################################################################################
#Frank needs to now take the yoSSP and turn it into the ssp variable shown in "acousticModel.py" sandbox script.
#Format needs to be depth paired with the speed of sound for that depth. 
#             ssp =  [
#                    [0, Y]
#                    [X, Y]        
#                    [X, Y]         
#                    [X, Y]  
#                    [bot, Y]  

exampleSSP = [
    [ 0, 1540],  # 1540 m/s at the surface
    [10, 1530],  # 1530 m/s at 10 m depth
    [15, 1532],  # 1532 m/s at 20 m depth
    [20, 1533],  # 1533 m/s at 25 m depth
]


ssp_tuples = (zip(yodepths, yospeed))

ssp = [list(pair) for pair in ssp_tuples]
ssp[0][0] = 0

print(ssp)




depths_list = [pair[0] for pair in ssp]
soundspeeds_list = [pair[1] for pair in ssp]



# Plotting the data
plt.figure(figsize=(10, 6))
plt.plot(soundspeeds_list, depths_list, marker='o', linestyle='-')
plt.gca().invert_yaxis()  # Invert y-axis to have depth increase downward
plt.xlabel('Sound Speed (m/s)')
plt.ylabel('Depth (m)')
plt.title('Depth vs Sound Speed')
plt.grid(True)
plt.show()


################################################################################
# Okay, SSP is in. Now I have to convert the rest of the dials from Matlab to Python. DOABLE.
os.chdir(r"C:\Users\fmm17241\OneDrive - University of Georgia\data\toolbox\AT\executables")
# We can automate this if needed, but for now just build toybox.
bathy = [
    [0, 25],    # 20 m water depth at the transmitter
    [200, 25],    # 20 m water depth at the transmitter    
    [300, 25],  # 15 m water depth 300 m away
    [350, 25],  # 15 m water depth 300 m away
    [450, 25]  # 20 m water depth at 600 m
]


env = pm.create_env2d(
    frequency=600,
    rx_range= 450,
    rx_depth= 23.0,
    depth=bathy,
    soundspeed=ssp,
    bottom_soundspeed=1450,
    bottom_density=1200,
    bottom_absorption=0.0,
    tx_depth=13.5,
)
pm.print_env(env)
pm.plot_env(env)

rays = pm.compute_eigenrays(env)

pm.plot_rays(rays, env=env,width=900,title='Eigenray Analysis: Flat Surface')

#Computes the arrival time of rays from T to R
arrivals = pm.compute_arrivals(env)
pm.plot_arrivals(arrivals, width=500,title='Arrival Timing: Flat Surface')
















