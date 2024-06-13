# -*- coding: utf-8 -*-
"""
Created on Thu Jun 13 10:45:34 2024

@author: fmm17241
"""
import os

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



os.chdir(r"C:\Users\fmm17241\OneDrive - University of Georgia\data\Glider\Data\nbdasc\Test")

files, Dout, nfile = wilddir(r"C:\Users\fmm17241\OneDrive - University of Georgia\data\Glider\Data\nbdasc\Test", '.nbdasc')
for file in files:
    print(file)


