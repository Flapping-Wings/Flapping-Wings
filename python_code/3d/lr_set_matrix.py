import numpy as np

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

        # Rest of code here
