# -*- coding: utf-8 -*-
"""
Created on Thu Jun 13 11:16:00 2024

@author: fmm17241
"""

import numpy as np
import gsw
from datetime import datetime, timedelta
from soundSpeed import sound_speed_mackenzie
from fileManagement import extract_column

######################################################################################################

def read_gliderasc(file_path):
    dstruct = {}

    try:
        with open(file_path, 'r') as file:
            for _ in range(3):
                line = file.readline()
            
            # Number of variables
            nvar = int(line[16:].strip())
            for _ in range(5):
                line = file.readline()
            
            dstruct['fname'] = line[16:].strip()
            line = file.readline()
            dstruct['mname'] = line[14:].strip()
            for _ in range(6):
                line = file.readline()
            
            line2 = file.readline()
            ndigits_line = file.readline().strip()
            
            # Parse ndigits as a list of integers
            ndigits = [int(x) for x in ndigits_line.split()]

            blpos = [0] + [pos for pos, char in enumerate(line) if char == ' '] + [len(line) - 1]
            blpos2 = [0] + [pos for pos, char in enumerate(line2) if char == ' '] + [len(line2) - 1]

            dstruct['vars'] = [line[blpos[i]+1:blpos[i+1]].strip() for i in range(len(blpos)-2)]
            dstruct['varlabs'] = [line2[blpos2[i]+1:blpos2[i+1]].strip() for i in range(len(blpos2)-2)]

            data = []
            while True:
                line = file.readline()
                if not line:
                    break
                data.append([float(num) for num in line.split()])

            dstruct['data'] = data
    except PermissionError:
        print(f"Permission denied: '{file_path}'")
    except FileNotFoundError:
        print(f"File not found: '{file_path}'")
    except Exception as e:
        print(f"An error occurred: {e}")

    return dstruct

#################################################################################################

def beautifyData(data):
    dn = extract_column(data,'imestamp')
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
    dt = np.array([base_time + timedelta(seconds=float(rt_i)) for rt_i in dn])

    # McKenzie's equation for sound speed (m/s)
    speed = [sound_speed_mackenzie(temperature, salt, depth) for temperature, salt, depth in zip(temperature, salt, depth)]


    return dt, dn, temperature, salt, density, depth, pressure, speed

####################################################################################################

def yoDefiner(dn, depth, temperature, salt, speed):
    difference= np.diff(depth);
    indexTop = np.argmax(difference);
    indexBot = np.argmax(depth);
    ##
    yotemps = temperature[indexTop:indexBot+1];
    yotimes = dn[indexTop:indexBot+1];
    yodepths = depth[indexTop:indexBot+1];
    yosalt = salt[indexTop:indexBot+1];
    yospeed  = speed[indexTop:indexBot+1];
    yoSSP    = [yotimes,yodepths,yospeed];   

    return yoSSP, yotemps, yotimes, yodepths, yosalt, yospeed

####################################################################################################

#Time Conversions
from datetime import datetime, timedelta


def datenum_to_datetime(datenum):
    # MATLAB's datenum starts from the year 0, whereas Python's datetime starts from the year 1
    # Therefore, we need to offset the date by 1 year less 1 day
    matlab_datenum_offset = datetime(1, 1, 1) - timedelta(days=366)
    python_datetime = matlab_datenum_offset + timedelta(days=datenum)
    return python_datetime

