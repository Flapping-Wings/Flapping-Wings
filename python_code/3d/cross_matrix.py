import numpy as np

def cross_matrix(XC, NC, nxT, Xt, nxS):
    """
    Set up a sub-matrix for induced velocity on the target wing 
    due to bound vortices on the source wing

    Parameters
    ----------
    XC: ndarray[j, i]
        Coordinates of the total collocation points on the target wing
    NC: ndarray[j, i]
        Unit normal at the total collocation points on the target wing
    nxT: int
        Number of total elements on the target wing
    Xt: ndarray[j, n, i]
        Coordinates of the total elements on the source wing
    nxS: int
        Number of total elements on the source wing

    Returns
    -------
    VN: ndarray[nxT, nxS]
        Sub-matrix for the nonpenetration condition 
    """
    pass
