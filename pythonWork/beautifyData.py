# -*- coding: utf-8 -*-
"""
Created on Thu Jun 13 11:16:00 2024

@author: fmm17241
"""

pip install gsw


import numpy as np
import gsw
from datetime import datetime, timedelta

def beautifyData(data):
    temperature = data[:, 3]  # degC
    cond = data[:, 1]  # S/m
    rawpressure = data[:, 2]  # bar
    pressure = rawpressure * 10  # converts pressure to dbar

    # Mean latitude for near Gray's Reef
    latmean = 31.3960
    depth = gsw.z_from_p(pressure, latmean) * -1  # depth, m (negative z from p, so multiply by -1)

    rt = data[:, 0]  # seconds after some time

    salt = gsw.SP_from_C(10 * cond / 42.914, temperature, pressure)
    density = gsw.rho(salt, temperature, pressure)

    # Convert rt into datetime style
    base_time = datetime(1970, 1, 1)
    dn = np.array([base_time + timedelta(seconds=float(rt_i)) for rt_i in rt])

    # McKenzie's equation for sound speed (m/s)
    speed = gsw.sound_speed(salt, temperature, pressure)

    return dn, temperature, salt, density, depth, speed


# data should be a numpy array with columns representing time, conductivity, pressure, temperature, and other measurements as necessary.
data = np.array([
    [0, 4.5, 1.5, 15.0],  # example row: [rt, cond, rawpressure, temperature]
    [3600, 4.6, 1.6, 15.5],  # example row after one hour
    # add more rows as needed
])

dn, temperature, salt, density, depth, speed = beautifyData(data)

print("Datetime:", dn)
print("Temperature:", temperature)
print("Salinity:", salt)
print("Density:", density)
print("Depth:", depth)
print("Sound Speed:", speed)

