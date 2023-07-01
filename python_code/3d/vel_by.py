import numpy as np

def vel_by(istep, Xb, nXb, Xw2_f, GAMAw2_f, nXw_f, Xw2_r, GAMAw2_r, nXw_r):
    """
    Calculate velocity at target nodes due to source vortices

    This is a generalization of `tbvelBbyW`, `tbvelWbyT`, and
    `tbvelWbyW`

    Parameters
    ----------
    istep: int
        Current iteration step
    Xw: ndarray[j, n, iXw]
        Coordinate j of observation node n of the target element node
    nXw: int
        Number of target elements
    Xt2_f: ndarray[j, n, iXt, w]
        Coordinate j of source node n for source elements on front wings
    GAMA2_f: ndarray[w, iXt]
        Source elements on front wings
    nXt_f: int
        Number of source elements on front wings
    Xt2_r: ndarray[j, n, iXt, w]
        Coordinate j of source node n for source elements on rear wings
    GAMA2_r: ndarray[w, iXt]
        Source elements on rear wings
    nXt_r: int
        Number of total elements on rear wings 
    """
    pass
