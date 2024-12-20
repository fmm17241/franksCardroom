# -*- coding: utf-8 -*-
"""
Created on Thu Dec 19 19:52:10 2024

@author: fmm17241
"""

def january(depth=20):
    return [
        [0, 1540],  # 1540 m/s at the surface
        [depth-(depth*0.9), 1540],  # 1530 m/s at 10 m depth
        [depth-(depth*0.5), 1540],  # 1532 m/s at 20 m depth
        [depth-(depth*0.2), 1540],  # 1533 m/s at 25 m depth
        [depth, 1540],  # 1533 m/s at 25 m depth
    ]

def april(depth=20):
    return [[0, 1540],  # 1540 m/s at the surface
        [depth-(depth/0.9), 1538.5],  # 1530 m/s at 10 m depth
        [depth-(depth/0.5), 1538.5],  # 1532 m/s at 20 m depth
        [depth-(depth/0.2), 1537],  # 1533 m/s at 25 m depth
        [depth, 1537],  # 1533 m/s at 25 m depth
    ]

def july(depth=20):
    return [
        [0, 1540],  # 1540 m/s at the surface
        [depth-(depth/0.9), 1538],  # 1530 m/s at 10 m depth
        [depth-(depth/0.5), 1537],  # 1532 m/s at 20 m depth
        [depth-(depth/0.2), 1537],  # 1533 m/s at 25 m depth
        [depth, 1537],  # 1533 m/s at 25 m depth
    ]


