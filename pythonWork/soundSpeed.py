# -*- coding: utf-8 -*-
"""
Created on Thu Jun 20 10:07:57 2024

@author: fmm17241
"""

# Soundspeed Equation
def sound_speed_mackenzie(T, S, D):
    """
    Calculate the speed of sound in seawater using Mackenzie's 9-term equation.

    Parameters:
    T (float): Temperature in degrees Celsius
    S (float): Salinity in practical salinity units (psu)
    D (float): Depth in meters

    Returns:
    float: Speed of sound in meters per second (m/s)
    """
    # Mackenzie's 9-term equation
    c = (1448.96 + 4.591 * T - 5.304e-2 * T**2 + 2.374e-4 * T**3 + 
         1.340 * (S - 35) + 1.630e-2 * D + 1.675e-7 * D**2 - 
         1.025e-2 * T * (S - 35) - 7.139e-13 * T * D**3)
    
    return c

# Example usage
#temperature = [10.0, 11.0, 12.0]  # in degrees Celsius
#salinity = [35.0, 35.1, 35.2]     # in psu
#depth = [1000.0, 1100.0, 1200.0]  # in meters

#sound_speed_values = [sound_speed_mackenzie(T, S, D) for T, S, D in zip(temperature, salinity, depth)]

#speed_of_sound = sound_speed_mackenzie(temperature, salinity, depth)
#print(f"The speed of sound is {speed_of_sound:.2f} m/s")
