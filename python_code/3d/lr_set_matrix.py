import numpy as np
from VORTEXm import VORTEXm

def lr_set_matrix(iwing, Xt, nXt, XC, NC):
    """
    Set up a self-coefficient matrix for the nonpenetration condition on the 
    airfoil surface: coefficient matrix of normal vel by itself

    Parameters
    ----------
    iwing: int
        0 (right wing), 1 (left wing)
    Xt: ndarray[j, n, i]
        Coordinates of total elements on the wing
    nXt: int
        Number of total elements on the wing
    XC: ndarray[j, i]
        Coordinates of the total collocation points on the wing
    NC: ndarray[j, i]
        Unit normal at the total collocation points on the wing

    Returns
    -------
    VN: ndarray[nXt, nXt]
        Matrix for the nonpenetration condition
    """
    # The left wing geometry is obtained by reversing the sign of the 
    # y-coordinate of the right wing
    if iwing == 1:
        Xt[1, :, :] = -Xt[1, :, :]
        XC[1, :] = -XC[1, :]
        NC[1, :] = -NC[1, :]

    VN = np.zeros((nXt, nXt))
    s = np.shape(XC)
    
    for i in range(nXt):
        U = np.zeros((1, s[1]))
        V = np.zeros((1, s[1]))
        W = np.zeros((1, s[1]))

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
