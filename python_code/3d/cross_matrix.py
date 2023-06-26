import numpy as np
from VORTEXm import VORTEXm

def cross_matrix(XC, NC, nxT, Xt, nxS):
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

        dU, dV, dW = VORTEXm(XC[0, :], XC[1, :], XC[2, :], 
                             Xt[0, 0, i], Xt[1, 0, i], Xt[2, 0, i], 
                             Xt[0, 1, i], Xt[1, 1, i], Xt[2, 1, i], 
                             1.0) 
        U = U + dU
        V = V + dV
        W = W + dW

        dU, dV, dW = VORTEXm(XC[0, :], XC[1, :], XC[2, :], 
                             Xt[0, 1, i], Xt[1, 1, i], Xt[2, 1, i], 
                             Xt[0, 2, i], Xt[1, 2, i], Xt[2, 2, i], 
                             1.0)
        U = U + dU
        V = V + dV
        W = W + dW

        dU, dV, dW = VORTEXm(XC[0, :], XC[1, :], XC[2, :], 
                             Xt[0, 2, i], Xt[1, 2, i], Xt[2, 2, i], 
                             Xt[0, 3, i], Xt[1, 3, i], Xt[2, 3, i], 
                             1.0)
        U = U + dU
        V = V + dV
        W = W + dW

        dU, dV, dW = VORTEXm(XC[0, :], XC[1, :], XC[2, :], 
                             Xt[0, 3, i], Xt[1, 3, i], Xt[2, 3, i], 
                             Xt[0, 0, i], Xt[1, 0, i], Xt[2, 0, i], 
                             1.0)
        U = U + dU
        V = V + dV
        W = W + dW
        
        # Normal velocity
        VN[:, i] = (U * NC[0, :] + V * NC[1, :] + W * NC[2, :])

    return VN
