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


os.chdir(r"C:\Users\fmm17241\OneDrive - University of Georgia\data\Glider\Data\nbdasc\Test")

datadir = (r"C:\Users\fmm17241\OneDrive - University of Georgia\data\Glider\Data\nbdasc\Test")


## Finds the files in the data directory
files, Dout, nfile = wilddir(r"C:\Users\fmm17241\OneDrive - University of Georgia\data\Glider\Data\nbdasc\Test", '.nbdasc')
files, Dout, nfile = wilddir(datadir, '.nbdasc')


for file in files:
    print(file)

last_file_path = get_last_file_path(datadir)

# Example usage:
dstruct = read_gliderasc(last_file_path)

print("File Name:", dstruct['fname'])
print("Mission Name:", dstruct['mname'])
print("Variables:", dstruct['vars'])
print("Variable Labels:", dstruct['varlabs'])
print("Data:", dstruct['data'])
    
    
    
    
    
    
    
    
    
    
################################################################################
# BEAUTIFICATION

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

# Example usage with dummy data
# data should be a numpy array with columns representing time, conductivity, pressure, temperature, and other measurements as necessary.
data = np.array([
    [0, 4.5, 1.5, 15.0],  # example row: [rt, cond, rawpressure, temperature]
    [3600, 4.6, 1.6, 15.5],  # example row after one hour
    # add more rows as needed
])

dn, temperature, salt, density, depth, speed = beautifyData()

print("Datetime:", dn)
print("Temperature:", temperature)
print("Salinity:", salt)
print("Density:", density)
print("Depth:", depth)
print("Sound Speed:", speed)










sstruct = read_gliderasc([datadir,files(nfile,:)]);

         
