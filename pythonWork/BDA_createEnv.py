# -*- coding: utf-8 -*-
"""
Created on Fri Dec 20 14:51:49 2024

@author: fmm17241
"""

import arlpy.uwapm as pm
import numpy as np
import BDA_surfaceLevels
import BDA_bathymetry
import BDA_SSP


def create_environment(
    surface_type,
    bottom_type,
    ssp_type,
    frequency=69000,
#    rx_range=None,
#    rx_depth=None,
    range    = 1000,
    receiverType = "botPoint",
    tx_depth=12.5,
    bottom_soundspeed=1450,
    bottom_density=1200,
    bottom_absorption=0.0
):
    """
    Create an underwater environment with the given parameters.
    
    Args:
        surface_type: Surface configuration (e.g., flatSurface, midSurface).
            F : Flat
            M : Mid
            W : wavy
        bottom_type: Bottom configuration (e.g., flatBottom, downhillBottom).
            F : Flat
            D : Downhill
            U : Uphill
            C : Complex
        ssp_type: Sound speed profile (e.g., janSSP, aprSSP).
            Jan : January 2020 example, homogeneous
            Apr : April  2020 example profile, strong shelf
            Jul : July  2020 example profile, diurnal strat.
        frequency: Transmission frequency in Hz.
        receiverType: Receiver ranges and depths (array), sets rx_range and rx_depth.
            Full : Full column for plotting Transmission Loss
            botPoint : Specific source of sound, 1 m off bottom
            topPoint : Specific source of sound, 1 m off surface
        rx_depth: Receiver depths (array).
            
        tx_depth: Transmitter depth.
        bottom_soundspeed: Sound speed of the bottom.
        bottom_density: Density of the bottom.
        bottom_absorption: Absorption of the bottom.

    Returns:
        Configured environment object.
    """
    if surface_type == "F":
        surface_type = BDA_surfaceLevels.flat_surface()
    if surface_type == "M":  
        surface_type = BDA_surfaceLevels.mid_surface()
    if surface_type == "W":    
        surface_type = BDA_surfaceLevels.wavy_surface()
###########
    if bottom_type == "F":
        bottom_type = BDA_bathymetry.flat_bottom()
    if bottom_type == "D":
        bottom_type = BDA_bathymetry.downhill_bottom()
    if bottom_type == "U":
        bottom_type = BDA_bathymetry.uphill_bottom()
    if bottom_type == "C":
        bottom_type = BDA_bathymetry.complex_bottom()
###########


    if receiverType == "Full":
        rx_range = np.linspace(0, 1000, 1001)
        rx_depth = np.linspace(0, 20, 21)
    if receiverType == "botPoint":
       rx_range = 1000
       rx_depth = 19
    if receiverType == "topPoint":
       rx_range = 1000                          # Receiver top of water column
       rx_depth = 1
###########       
    # Create the environment
    env = pm.create_env2d(
        frequency=frequency,
        rx_range=rx_range,
        rx_depth=rx_depth,
        depth=bottom_type,
        soundspeed=ssp_type,
        bottom_soundspeed=bottom_soundspeed,
        bottom_density=bottom_density,
        bottom_absorption=bottom_absorption,
        tx_depth=tx_depth,
        surface=surface_type,
        surface_interp='curvilinear',
        nbeams=100
    )
    return env
