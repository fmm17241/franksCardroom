# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
" This is arlpy.readthedocs.io testing for Bellhop"

pip install arlpy
import arlpy
import os
import shutil

#Find where bellhop is, then set path
os.chdir(r"C:\Users\fmm17241\OneDrive - University of Georgia\data\toolbox\AT\windows-bin-20201102")

#Import
import arlpy.uwapm as pm
import arlpy.plot as plt
import numpy as np

#Create 2D environment with default settings
env = pm.create_env2d()
pm.print_env(env)


#Plot the environment
pm.plot_env(env,width=900)


#Compute ray traces through the environment, ONLY those that go from T to R.
rays = pm.compute_eigenrays(env)
pm.plot_rays(rays,env=env,width=900)


#Computes the arrival time of rays from T to R
arrivals = pm.compute_arrivals(env)
pm.plot_arrivals(arrivals, width=900)

#Table of arrival times
arrivals[arrivals.arrival_number < 10][['time_of_arrival', 'angle_of_arrival', 'surface_bounces', 'bottom_bounces']]

###################################################################

#Sets bottom boundary layer of the environment
bathy = [
    [0, 20],    # 20 m water depth at the transmitter
    [300, 15],  # 15 m water depth 300 m away
    [400, 16],  # 15 m water depth 300 m away
    [600, 20]  # 20 m water depth at 600 m
]


#Changes soundspeed profile
ssp = [
    [ 0, 1540],  # 1540 m/s at the surface
    [10, 1530],  # 1530 m/s at 10 m depth
    [15, 1532],  # 1532 m/s at 20 m depth
    [20, 1533],  # 1533 m/s at 25 m depth
]

#Creates new environment, accounting for change in SSP and bathy, then prints & plots
env = pm.create_env2d(
    frequency=69000,
    rx_range= 600,
    rx_depth= 18,
    depth=bathy,
    soundspeed=ssp,
    bottom_soundspeed=1450,
    bottom_density=1200,
    bottom_absorption=1.0,
    tx_depth=18
)

pm.print_env(env)
pm.plot_env(env, width=900)

#Plots SSP
pm.plot_ssp(env)

#Computes and plots rays through env from T to R
rays = pm.compute_eigenrays(env)
pm.plot_rays(rays, env=env, width=900)

#Computes and plots ALL rays through env
rays = pm.compute_rays(env)
pm.plot_rays(rays, env=env, width=900)

###################################################################

#Changes environment: large number of receivers and range to track transmission loss
env['rx_range'] = np.linspace(0, 600, 1001)
env['rx_depth'] = np.linspace(0, 20, 301)

#Computes coherent transmission loss through the environment
tloss = pm.compute_transmission_loss(env,mode='coherent')
pm.plot_transmission_loss(tloss, env=env, clim=[-60,-30], width=900)

#CComputes incoherent transmission loss through the environment
tloss = pm.compute_transmission_loss(env, mode='incoherent')
pm.plot_transmission_loss(tloss, env=env, clim=[-60,-30], width=900)


beampattern = np.array([
    [-180,  10], [-170, -10], [-160,   0], [-150, -20], [-140, -10], [-130, -30],
    [-120, -20], [-110, -40], [-100, -30], [-90 , -50], [-80 , -30], [-70 , -40],
    [-60 , -20], [-50 , -30], [-40 , -10], [-30 , -20], [-20 ,   0], [-10 , -10],
    [  0 ,  10], [ 10 , -10], [ 20 ,   0], [ 30 , -20], [ 40 , -10], [ 50 , -30],
    [ 60 , -20], [ 70 , -40], [ 80 , -30], [ 90 , -50], [100 , -30], [110 , -40],
    [120 , -20], [130 , -30], [140 , -10], [150 , -20], [160 ,   0], [170 , -10],
    [180 ,  10]
])
env['tx_directionality'] = beampattern


tloss = pm.compute_transmission_loss(env)
pm.plot_transmission_loss(tloss, env=env, clim=[-60,-30], width=900)

surface = np.array([[r, 0.5+0.5*np.sin(2*np.pi*0.005*r)] for r in np.linspace(0,600,601)])
env['surface'] = surface

env['rx_range'] = 600
env['rx_depth'] = 18.5

rays = pm.compute_eigenrays(env)
pm.plot_rays(rays, env=env, width=900)




