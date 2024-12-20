# -*- coding: utf-8 -*-
"""
Created on Thu Dec 19 18:27:08 2024

@author: fmm17241
"""

# surface_levels.py

import numpy as np

def flat_surface(range_max=1000, depth=0.0, num_points=1001):
    """Creates a flat surface."""
    return np.array([[r, depth] for r in np.linspace(0, range_max, num_points)])


def mid_surface(range_max=1000, wave_amplitude=0.6, wave_frequency=0.02, num_points=1001):
    """Creates a mid-amplitude wavy surface."""
    return np.array([[r, 1.0 + wave_amplitude * np.sin(10 * np.pi * wave_frequency * r)] 
                     for r in np.linspace(0, range_max, num_points)])

def wavy_surface(range_max=1000, wave_amplitude=2.0, wave_frequency=0.02, num_points=1001):
    """Creates a wavy surface."""
    return np.array([[r, 2.0 + wave_amplitude * np.sin(10 * np.pi * wave_frequency * r)] 
                     for r in np.linspace(0, range_max, num_points)])
