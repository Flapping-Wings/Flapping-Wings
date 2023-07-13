import numpy as np
import matplotlib.pyplot as plt
from globals import g

def plot_WB(m, istep, nXb, nXw, Xb, Xw):
    """
    Plot  wake elements along with the original border elements
    
    Parameters
    ----------
    m: int
        0 (front wing), 1(rear) wing
    istep: int
        Iteration step
    nXb: int
        Number of border vortices
    nXw: int
        Number of wake vortices 
    Xb: ndarray[j, inode, iXb, w]
        Coordinate j of node point for the border iXb
    Xw: ndarray[j, inode, iXw, w]
        Coordinate j of node point for wake element iXb
    """
    pass
