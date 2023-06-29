import numpy as np

def cross_vel_B_by_T(Xb, nXb, Xt, GAMA, nXt):
    """
    Calculate velocity at border element nodes of wing i due to total vortices
    on the wing j. The velocity is evaluated at the nodes; no offset 

    Parameters
    ----------
    Xb: ndarray[j, n, iXb]
        Coordinate j of observation node n of the wake element (destination)
    nXb: int
        Number of border vortices (destination)
    Xt[j, n, iXt]
        Coordinate j of source node n for the total element iXt on the wing
    GAMA: ndarray[iXt]
        Entire bound vortex (source)
    nXt: int
        Number of total elements on the wing (source)

    Returns
    -------
    VBT: ndarray[j, n, iXb]
        TODO
    """
    pass
