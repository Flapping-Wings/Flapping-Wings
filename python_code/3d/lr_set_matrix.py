import numpy as np
from numba import njit
from VORTEXm import VORTEXm

def lr_set_matrix(Xt, nXt, XC, NC, RCUT):
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

    VN = np.zeros((nXt, nXt, 2)) # 2 for right and left wing
    VN[:, :, 0] = one_side(Xt, nXt, XC, NC, RCUT)
    VN[:, :, 1] = -VN[:, :, 0]  # Left side is just a mirror of the right

    return VN

@njit(cache=True)
def one_side(Xt, nXt, XC, NC, RCUT):
    VN = np.zeros((nXt, nXt))
    s = XC.shape

    for i in range(nXt):
        U = np.zeros(s[1])
        V = np.zeros(s[1])
        W = np.zeros(s[1])

        for n in range(4):
            k = (n + 1) % 4
            dU, dV, dW = VORTEXm(XC[0], XC[1], XC[2],
                                 Xt[0, n, i], Xt[1, n, i], Xt[2, n, i],
                                 Xt[0, k, i], Xt[1, k, i], Xt[2, k, i],
                                 1.0, RCUT)
            U += dU
            V += dV
            W += dW

        # Normal velocity
        VN[:, i] = U * NC[0] + V * NC[1] + W * NC[2]

    return VN