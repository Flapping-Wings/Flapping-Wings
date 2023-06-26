import numpy as np

def wing_total(Xb, nXb, Nb, Xc, nXc, Nc):
    """
    Combine wing border and center elements
    
    Parameters
    ----------
    Xb: ndarray[j, n, i]
        Coordinates of border elements
    nXb: int
        Number of border elements
    Nb: ndarray[j, i]
        Unit normals to the border elements
    Xc: ndarray[j, n, i]
        Coordinates of center elements
    nXc: int
        Number of center elements
    Nc: ndarray[j, i]
        Unit normals to the center elements

    Returns
    -------
    Xc: ndarray[j, n, i]
        Reduced Xc (centroid removed, n = 1:4)
    Xb: ndarray[j, n, i]
        Reduced Xb (centroid removed, n = 1:4)
    Xt: ndarray[j, n, i]
        Coordinates of total elements on the wing
    nXt: int
        Number of total elements on the wing
    XC: ndarray[j, i]
        Coordinates of the total collocation points on the wing
    NC: ndarray[j, i]
        Unit normal at the total collocation points on the wing
    """
    # Initialization
    nXt = nXb + nXc
    XC = np.zeros((3, nXt))
    NC = np.zeros((3, nXt))
    Xt = np.zeros((3, 4, nXt))

    # Node points (excluding the collocation points)
    Xt[:, :, 0:nXb]   = Xb[:, 0:4, :]
    Xt[:, :, nXb:nXt] = Xc[:, 0:4, :]

    # Collocation points
    XC[:, 0:nXb]   = Xb[:, 4, :]
    XC[:, nXb:nXt] = Xc[:, 4, :]

    # Unit normal
    NC[:, 0:nXb]   = Nb
    NC[:, nXb:nXt] = Nc

    # Redefine Xb and Xc
    tmp = Xb[:, 0:4, :]
    Xb = np.zeros((3, 4, nXb))
    Xb = tmp
    tmp = Xc[:, 0:4, :]
    Xc = np.zeros((3, 4, nXc))
    Xc = tmp

    return Xc, Xb, Xt, nXt, XC, NC
