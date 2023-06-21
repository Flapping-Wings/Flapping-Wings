import numpy as np

def lr_mass_L2GT(
    iwing, 
    beta, 
    delta, 
    phi, 
    theta, 
    a, 
    U, 
    t, 
    b, 
    xc, 
    xb, 
    xt, 
    xC, 
    nC
):
    """
    Convert vectors from the wing-fixed to global or translating system
    
    Parameters
    ----------
    iwing: int
        0 (right wing), 1 (left wing)
    beta: float
        Stroke plane angle
    delta: float
        Body angle
    phi: float
        Wing rolling angle
    theta: float
        Wing rotation angle
    a: float
        Rotation axis offset
    U: ndarray
        Ambient velocity
    t: float
        Time
    b: float
        Wing offset from body center
    xc: ndarray[j, n, i]
        TODO
    xb: ndarray[j, n, i]
        Coordinates of the border elements on the wing (wing-fixed)
    xt: ndarray[j, n, i]
        Coordinates of the total elements on the wing (wing-fixed)
    xC: ndarray[j, i]
        Coordinates of the total collocation points on the wing (wing-fixed)
    nC: ndarray[j, i]
        Unit normal at tht total collocation points on the wing (wing-fixed)

    Returns
    -------
    Xc: ndarray[j, n, i]
        TODO
    Xb: ndarray[j, n, i]
        Coordinates of the border elements on the wing (global)
    Xt: ndarray[j, n, i]
        Coordinates of the total elements on the wing (global)
    XC: ndarray[j, i]
        Coordinates of the total collocation points on the wing (global)
    NC_T: ndarray[j, i]
        nit normal at the total collocation points on the wing 
        (global & translating system)
    """
    s  = np.shape(xt)
    sb = np.shape(xb)
    sc = np.shape(xc)

    Xc   = lr_L2G_1(iwing, xc, sc[2], beta, delta, phi, theta, a, U, t, b )
    Xb   = lr_L2G_1(iwing, xb, sb[2], beta, delta, phi, theta, a, U, t, b )
    Xt   = lr_L2G_1(iwing, xt,  s[2], beta, delta, phi, theta, a, U, t, b )
    XC   = lr_L2G_2(iwing, xC,  s[2], beta, delta, phi, theta, a, U, t, b )
    NC_T = lr_L2T_2(iwing, nC,        beta, delta, phi, theta)

    return Xc, Xb, Xt, XC, NC_T


def lr_L2G_1(iwing, x, n, beta, delta, phi, theta, a, U, t, b):
    """
    Coordinate transformation from the wing-fixed to global system
    
    Returns
    -------
    X: ndarray[j, n, i]
        Global coordinates
    xt: ndarray[j, n, i]
        Translating system coordinates
    """
    pass

def lr_L2G_2(iwing, x, n, beta, delta, phi, theta, a, U, t, b):
    """
    Coordinate transformation from the wing-fixed to global & translating systems
    
    Returns
    -------
    X: ndarray[j, n, i]
        Global coordinates
    xt: ndarray[j, n, i]
        Translating system coordinates
    """
    pass

def lr_L2T_2(iwing, x, beta, delta, phi, theta):
    """
    Coordinate transformation of the free vector from the wing-fixed to translationg system
    Examples of free vectors: velocity, unit normal to the element

    Returns
    -------
    X: ndarray[j, i]
        Vector in translating system
    """
    pass
