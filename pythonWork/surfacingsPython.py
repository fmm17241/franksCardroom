# -*- coding: utf-8 -*-
"""
Created on Thu Jun 13 10:02:57 2024

@author: fmm17241
"""
import arlpy
import os
import shutil
#Frank needs to figure out how to read in the data files like in Matlab

os.chdir(r"C:\Users\fmm17241\OneDrive - University of Georgia\data\Glider\Data\nbdasc\Test")

files = wilddir(datadir, 'nbdasc');



nfile = size(files,1);
sstruct = read_gliderasc([datadir,files(nfile,:)]);

         
