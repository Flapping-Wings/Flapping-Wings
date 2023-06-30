import numpy as np

def add_wake(nXb, GAMAb, Xs, GAMAw, Xw):
    """
    Add shed vortices to wake vortices

    Parameters
    ----------
    nXb: int
        Number of border elements
    GAMAb: ndarray[w, iXb]
        Shed vortices (border vortices)
    Xs: ndarray[j, n, iXb, w]
        Location of shed vortices (after convection)
    GAMAw: ndarray[w, iXw]
        Wake vortices
    Xw: ndarray[j, n, iXw, w]
        Location of wake vortices (after convection)

    Returns
    -------
    GANAw: ndarray[w, iXw]
        Wake vortices for next step
    nXw: int
        Updated number of wake vortices for next step
    Xw: ndarray[j, n, iXw, w]
        Location of wake voritces for next step
        (in wing-fixed system)
    """
    pass