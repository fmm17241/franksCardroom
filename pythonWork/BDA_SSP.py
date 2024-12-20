# -*- coding: utf-8 -*-
"""
Created on Thu Dec 19 19:52:10 2024

@author: fmm17241
"""

def homogeneous(depth=20):
    return [
        [ 0, 1540],  # 1540 m/s at the surface
        [depth-(depth/0.9), 1540],  # 1530 m/s at 10 m depth
        [depth-(depth/0.5), 1540],  # 1532 m/s at 20 m depth
        [depth-(depth/0.2), 1540],  # 1533 m/s at 25 m depth
    ]

FRANK makes several scenarios here. Create "spring", "november", etc.



#Changes soundspeed profile
ssp = [
    [ 0, 1540],  # 1540 m/s at the surface
    [10, 1530],  # 1530 m/s at 10 m depth
    [15, 1532],  # 1532 m/s at 20 m depth
    [20, 1533],  # 1533 m/s at 25 m depth
]