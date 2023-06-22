import numpy as np
from globals import g

def mVORTEX(x, y, z, X1, Y1, Z1, X2, Y2, Z2, GAMA):
    """
    Calculates the induced velocity [u, v, w] at a point [x, y, z]
    due to multiple line segements with the same side belonging to
    multiple vortex elements with strength GAMA per unit length
    pointing in the direction [X2, Y2, Z2] - [X1, Y1, Z1]

    Parameters
    ----------
    x, y, z: floats
        Observation point coordinates
    X1, Y1, Z1: ndarray     # TODO: Ask questions about this
        Vectors of size m, where m is the number of vortex elements.
        Endpoints 1 of the lines for all vortex element with the common side.
    X2, Y2, Z2: ndarray
        Vectors of size m, where m is the number of vortex elements.
        Endpoints 2 of the lines for all vortex element with the common side.
    GAMA: ndarray
        # TODO

    Returns
    -------
    u, v, w: floats
        Velocity components at the observation point [x, y, z] due to 
        all lines with common sides, belonging to all vortex elements
    """
    pass
