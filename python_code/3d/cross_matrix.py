import numpy as np
from VORTEXm import VORTEXm

def cross_matrix(XC, NC, nxT, Xt, nxS, RCUT):
    """
    Set up a sub-matrix for induced velocity on the target wing 
    due to bound vortices on the source wing. 
    
    This function is very similar to `lr_set_matrix()`.

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
    # Set up a coefficient matrix for the nonpenetration condition 
    # on the airfoil surface.
    # Use collocation point vector XC[j, i] and the unit normal vector 
    # NC[j, i] for the all collocation points.
    VN = np.zeros((nxT, nxS))
    s = np.shape(XC)

    for i in range(nxS):
        U = np.zeros(s[1])
        V = np.zeros(s[1])
        W = np.zeros(s[1])

        for j in range(4):
            k = (j + 1) % 4
            dU, dV, dW = VORTEXm(XC[0, :], XC[1, :], XC[2, :],
                                 Xt[0, j, i], Xt[1, j, i], Xt[2, j, i],
                                 Xt[0, k, i], Xt[1, k, i], Xt[2, k, i],
                                 1.0, RCUT)
            U += dU
            V += dV
            W += dW

        # Normal velocity
        VN[:, i] = (U * NC[0, :] + V * NC[1, :] + W * NC[2, :])

    return VN