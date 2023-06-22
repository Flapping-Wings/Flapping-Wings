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
    NC_T = lr_L2T_2(iwing, nC,  s[2], beta, delta, phi, theta)

    return Xc, Xb, Xt, XC, NC_T


def lr_L2G_1(iwing, x, n, beta, delta, phi, theta, a, U, t, b):
    """
    Coordinate transformation from the wing-fixed to global system
    """
    xb = np.zeros((3, 4, n))
    xt = np.zeros((3, 4, n))
    X  = np.zeros((3, 4, n))

    # Local to flap plane inertia system Xb[j]
    cth = np.cos(theta)
    sth = np.sin(theta)
    cph = np.cos(phi)
    sph = np.sin(phi)

    xb[0,:,:] =        cth * (x[0,:,:] + a)                        + sth * x[2,:,:]
    xb[1,:,:] =  sph * sth * (x[0,:,:] + a) + cph * x[1,:,:] - sph * cth * x[2,:,:]
    xb[2,:,:] = -cph * sth * (x[0,:,:] + a) + sph * x[1,:,:] + cph * cth * x[2,:,:]

    if iwing == 1:          # Flip left wing coordinates
        xb[1, :, :] = -xb[1, :, :]

    # From flap plane inertia to translating inertia
    beta = beta - delta     # Effective flap plane angle
    cb = np.cos(beta)
    sb = np.sin(beta)

    xt[0, :, :] =  sb * xb[0, :, :] + cb * xb[2, :, :]
    xt[1, :, :] =       xb[1, :, :]
    xt[2, :, :] = -cb * xb[0, :, :] + sb * xb[2, :, :]

    # From translating inertia to global
    X[0, :, :] = -U[0] * t + b * np.cos(delta) + xt[0, :, :]
    X[1, :, :] = -U[1] * t                     + xt[1, :, :]
    X[2, :, :] = -U[2] * t - b * np.sin(delta) + xt[2, :, :]

    return X

def lr_L2G_2(iwing, x, n, beta, delta, phi, theta, a, U, t, b):
    """
    Coordinate transformation from the wing-fixed to global & translating systems
    """
    xb = np.zeros((3, n))
    xt = np.zeros((3, n))
    X  = np.zeros((3, n))

    # Local to flap plane inertia system Xb[j]
    cth = np.cos(theta)
    sth = np.sin(theta)
    cph = np.cos(phi)
    sph = np.sin(phi)

    xb[0,:] =        cth * (x[0,:] + a)                     + sth * x[2,:]
    xb[1,:] =  sph * sth * (x[0,:] + a) + cph * x[1,:] -sph * cth * x[2,:]
    xb[2,:] = -cph * sth * (x[0,:] + a) + sph * x[1,:] +cph * cth * x[2,:]

    if iwing == 1:          # Flip left wing coordinates
        xb[1, :] = -xb[1, :]

    # From flap plane inertia to translating inertia
    beta = beta - delta     # Effective flap plane angle
    cb = np.cos(beta)
    sb = np.sin(beta)

    xt[0, :] =  sb * xb[0, :] + cb * xb[2, :]
    xt[1, :] =       xb[1, :]
    xt[2, :] = -cb * xb[0, :] + sb * xb[2, :]


    # From translating inertia to the global
    X[0, :] = -U[0] * t + b * np.cos(delta) + xt[0, :]
    X[1, :] = -U[1] * t                     + xt[1, :]
    X[2, :] = -U[2] * t - b * np.sin(delta) + xt[2, :]

    return X

def lr_L2T_2(iwing, x, n, beta, delta, phi, theta):
    """
    Coordinate transformation of the free vector from the wing-fixed to translationg system
    Examples of free vectors: velocity, unit normal to the element
    """
    xb = np.zeros((3, n))
    X  = np.zeros((3, n))
    # Rotation offset is zero
    a = 0.0

    # Local to flap plane inertia system xb[j]
    cth = np.cos(theta)
    sth = np.sin(theta)
    cph = np.cos(phi)
    sph = np.sin(phi)

    xb[0,:] =        cth * (x[0,:] + a)                      + sth * x[2,:]
    xb[1,:] =  sph * sth * (x[0,:] + a) + cph * x[1,:] - sph * cth * x[2,:]
    xb[2,:] = -cph * sth * (x[0,:] + a) + sph * x[1,:] + cph * cth * x[2,:]

    if iwing == 1:          # Flip left wing coordinates
        xb[1, :] = -xb[1, :]

    # Flap plane inertia to translation inertia
    beta = beta - delta     # Effective stroke angle
    cb = np.cos(beta)
    sb = np.sin(beta)

    X[0, :] =  sb * xb[0, :] + cb * xb[2, :]
    X[1, :] =       xb[1, :]
    X[2, :] = -cb * xb[0, :] + sb * xb[2, :]

    return X
