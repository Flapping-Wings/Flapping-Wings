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
    # Create copies to avoid mutating the original arrays
    # in the case of left wing (iwing == 1)
    Xt__ = Xt.copy()
    XC__ = XC.copy()
    NC__ = NC.copy()

    # The left wing geometry is obtained by reversing the sign of the 
    # y-coordinate of the right wing
    if iwing == 1:
        Xt__[1, :, :] = -Xt__[1, :, :]
        XC__[1, :] = -XC__[1, :]
        NC__[1, :] = -NC__[1, :]

    VN = np.zeros((nXt, nXt))
    s = XC__.shape

    for i in range(nXt):
        U = np.zeros(s[1])
        V = np.zeros(s[1])
        W = np.zeros(s[1])

        for n in range(4):
            k = (n + 1) % 4
            dU, dV, dW = VORTEXm(XC__[0], XC__[1], XC__[2],
                                 Xt__[0, n, i], Xt__[1, n, i], Xt__[2, n, i],
                                 Xt__[0, k, i], Xt__[1, k, i], Xt__[2, k, i],
                                 1.0)
            U += dU
            V += dV
            W += dW

        # Normal velocity
        VN[:, i] = U * NC__[0] + V * NC__[1] + W * NC__[2]

    return VN
