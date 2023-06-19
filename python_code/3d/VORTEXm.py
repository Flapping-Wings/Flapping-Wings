import numpy as np
from globals import g

def VORTEXm(X, Y, Z, x1, y1, z1, x2, y2, z2, GAMA):
    """
    Calculate the induced velocity [U, V, W] at multiple points
    [X, Y, Z] due to one line segment with strength GAMA per unit
    length pointing in the direction [x2, y2, z2] - [x1, y1, z1]

    Parameters
    ----------
    X, Y, Z: ndarrays
        Coordinates of observation points
    x1, y1, z1: floats
        Endpoint 1 of the line
    x2, y2, z2: floats
        Endpoint 2 of the line
    GAMA: float
        TODO
    
    Returns
    -------
    U, V, W: 
        Velocity components at the observation points [X, Y, Z]
        due to one line
    """

