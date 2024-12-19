# -*- coding: utf-8 -*-
"""
Created on Thu Dec 19 18:27:08 2024

@author: fmm17241
"""

# surface_levels.py

import numpy as np

def flat_surface(range_max=1000, depth=2.0, num_points=1001):
    """Creates a flat surface."""
    return np.array([[r, depth] for r in np.linspace(0, range_max, num_points)])

def wavy_surface(range_max=1000, wave_amplitude=2.0, wave_frequency=0.02, num_points=1001):
    """Creates a wavy surface."""
    return np.array([[r, wave_amplitude * np.sin(wave_frequency * np.pi * r) + 2.0] 
                     for r in np.linspace(0, range_max, num_points)])
