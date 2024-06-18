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
    rawTime = extract_column(data,'imestamp')
    temperature = extract_column(data, 'degc')
    cond = extract_column(data, 's/m')
    rawpressure = extract_column(data, 'bar')
    pressure = [x * 10 for x in rawpressure]  # converts pressure to dbar

    # Mean latitude for near Gray's Reef
    latmean = 31.3960
    depth = gsw.z_from_p(pressure, latmean) * -1  # depth, m (negative z from p, so multiply by -1)

    #Frank's wrestling with units for conductivity
    salt = gsw.SP_from_C([(x*10) for x in cond],temperature,pressure)
    #Calculating seawater density
    density = gsw.rho(salt, temperature, pressure)


    # Convert rawTime into datetime style. Checked, same as MatLab.
    base_time = datetime(1970, 1, 1)
    dt = np.array([base_time + timedelta(seconds=float(rt_i)) for rt_i in rawTime])

    # McKenzie's equation for sound speed (m/s)
    speed = [sound_speed_mackenzie(temperature, salt, depth) for temperature, salt, depth in zip(temperature, salt, depth)]


    return dt, temperature, salt, density, depth, pressure, speed