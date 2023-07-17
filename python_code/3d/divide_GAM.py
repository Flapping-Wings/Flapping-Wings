import numpy as np
import globals as g

def divide_GAM(GAM, nxb):
    """
    Sort GAM into shed and bound groups

    Parameters
    ----------
    GAM: ndarray[w, nxt]
        TODO
    nxb: Number of border elements

    Returns
    -------
    GAMAb: ndarray[w, nxb]
        Border elements (to be shed)
    """
    # TODO: Feels like it should be possible to optimize
    # this entire function away with just NumPy
    GAMAb = np.zeros((g.nwing, nxb))

    for i in range(g.nwing):
        GAMAb[i, 0:nxb] = GAM[i, 0:nxb]

    return GAMAb
