# -*- coding: utf-8 -*-
"""
Created on Thu Dec 19 19:28:14 2024

@author: fmm17241
"""

def flat_bottom(depth=20):
    return [
        [0, depth],    # 20 m water depth at the transmitter
        [200, depth],    # 20 m water depth at the transmitter    
        [300, depth],  # 15 m water depth 300 m away
        [350, depth],  # 15 m water depth 300 m away
        [600, depth],  # 20 m water depth at 600 m
        [800, depth],
        [1000, depth]
    ]


def downhill_bottom(depth=20):
    return [
        [0, depth-(depth/2)],    # 20 m water depth at the transmitter
        [200, depth-(depth/3)],    # 20 m water depth at the transmitter    
        [300, depth-(depth/3.2)],  # 15 m water depth 300 m away
        [350, depth-(depth/3.4)],  # 15 m water depth 300 m away
        [600, depth-(depth/3.8)],  # 20 m water depth at 600 m
        [800, depth],
        [1000, depth]
    ]

def uphill_bottom(depth=20):
    return [
        [0, depth],    # 20 m water depth at the transmitter
        [200, depth-(depth/6)],    # 20 m water depth at the transmitter    
        [300, depth-(depth/4.5)],  # 15 m water depth 300 m away
        [350, depth-(depth/3)],  # 15 m water depth 300 m away
        [600, depth-(depth/2.2)],  # 20 m water depth at 600 m
        [800, depth-(depth/2.2)],
        [1000, depth-(depth/2.2)]
    ]