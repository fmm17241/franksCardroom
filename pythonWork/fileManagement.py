# -*- coding: utf-8 -*-
"""
Created on Thu Jun 20 10:23:52 2024

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


##########################################################################################################

def get_last_file_path(datadir):
    files = [f for f in os.listdir(datadir) if os.path.isfile(os.path.join(datadir, f))]
    if not files:
        raise FileNotFoundError("No files found in the directory.")
    files.sort()  # Sort files if necessary, depends on how "last" is defined
    last_file = files[-1]  # Get the last file
    return os.path.join(datadir, last_file)

##########################################################################################################

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