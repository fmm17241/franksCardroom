# -*- coding: utf-8 -*-
"""
Created on Thu Jun 13 10:02:57 2024

@author: fmm17241
"""
pip install gsw



import arlpy
import os
import shutil
import numpy as np
import gsw
from datetime import datetime, timedelta
#Frank needs to figure out how to read in the data files like in Matlab




#################################################################################
#Finds and creates a variable naming all the files with a specific extension.
def wilddir(datadir=None, string=None):
    """
    Creates a list of files ending with the given string in the specified directory.
    Pads the filenames with trailing blanks (spaces) to match the length of the longest filename.
    
    Parameters:
        datadir (str): The directory to search for files. If None, use the current working directory.
        string (str): The string that filenames should end with.
        
    Returns:
        files (list): List of filenames ending with the specified string, padded with trailing blanks.
        Dout (list): List of os.DirEntry objects for the matching files.
        nfile (int): Number of matching files.
    """
    # Set default values
    if datadir is None and string is not None:
        datadir = os.getcwd()
    elif datadir is not None and string is None:
        string = datadir
        datadir = os.getcwd()
    elif datadir is None and string is None:
        raise ValueError("At least one argument must be provided.")
    
    # Get the directory listing
    D = os.scandir(datadir)
    
    files = []
    Dout = []
    
    for entry in D:
        if entry.is_file() and entry.name.endswith(string):
            files.append(entry.name)
            Dout.append(entry)
    
    # Find the maximum length of filenames to pad with spaces
    max_length = max(len(f) for f in files) if files else 0
    files = [f.ljust(max_length) for f in files]
    
    # Number of files
    nfile = len(files)
    
    return files, Dout, nfile
#################################################################################
    
    
def get_last_file_path(datadir):
    files = [f for f in os.listdir(datadir) if os.path.isfile(os.path.join(datadir, f))]
    if not files:
        raise FileNotFoundError("No files found in the directory.")
    files.sort()  # Sort files if necessary, depends on how "last" is defined
    last_file = files[-1]  # Get the last file
    return os.path.join(datadir, last_file)

    
##############################################################################
# READ THE FILES!!!!!

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
###################################################################################
def extract_column(dstruct, label):
    if 'varlabs' not in dstruct or 'data' not in dstruct:
        raise ValueError("The dictionary does not contain 'varlabs' or 'data' keys.")
    
    if label not in dstruct['varlabs']:
        raise ValueError(f"Label '{label}' not found in 'varlabs'.")

    # Find the index of the label in 'varlabs'
    index = dstruct['varlabs'].index(label)
    
    # Extract the corresponding column from 'data'
    column = [row[index] for row in dstruct['data']]
    
    return column
###################################################################################


os.chdir(r"C:\Users\fmm17241\OneDrive - University of Georgia\data\Glider\Data\nbdasc\Test")

datadir = (r"C:\Users\fmm17241\OneDrive - University of Georgia\data\Glider\Data\nbdasc\Test")


## Finds the files in the data directory
files, Dout, nfile = wilddir(r"C:\Users\fmm17241\OneDrive - University of Georgia\data\Glider\Data\nbdasc\Test", '.nbdasc')
files, Dout, nfile = wilddir(datadir, '.nbdasc')


for file in files:
    print(file)

last_file_path = get_last_file_path(datadir)

# Data file:
dstruct = read_gliderasc(last_file_path)



################################################################################
#Time Conversions
def datenum_to_datetime(datenum):
    # MATLAB's datenum starts from the year 0, whereas Python's datetime starts from the year 1
    # Therefore, we need to offset the date by 1 year less 1 day
    matlab_datenum_offset = datetime(1, 1, 1) - timedelta(days=366)
    python_datetime = matlab_datenum_offset + timedelta(days=datenum)
    return python_datetime
    
################################################################################
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

################################################################################
# BEAUTIFICATION

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
################################################################################

dt, temperature, salt, density, depth, pressure, speed = beautifyData(dstruct)










sstruct = read_gliderasc([datadir,files(nfile,:)]);

         
