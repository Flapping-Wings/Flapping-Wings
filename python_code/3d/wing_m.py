import numpy as np

def wing_m(mpath, t, rt, tau, e, gMax, p, rtOff, phiT, phiB):
    """
    Calculate airfoil translational and rotational parameters.
    All input parameters are nondimensional.

    Parameters
    ----------
    mpath: int
        Motion path parameter
    t: float
        Time
    rt: float
        Ratio of T_[0] / T[i]
    tau: float
        Phase shift
    e: float
        Stroke difference
    gMax: float
        Max rotation angle
    p: float
        Rotation speed parameter
    rtOff: float
        Rotation timing offset
    phiT: float
        Top stroke angle
    phiB: float
        Bottom stroke angle

    Returns
    -------
    phi: float
        Rolling angle
    theta: float
        Rotation angle
    dph: float
        Derivative of phi with respect to time (dphi / dt)
    dth: float
        Derivative of theta with respect to time (dtheta) / dt)
    """
    if mpath == 0:
        # Rolling motion
        sump = phiT - phiB
        phi = 0.5 * sump * (np.cos(np.pi * (t * rt + tau)) + e)
        dph = -0.5 * sump * np.pi * rt * np.sin(np.pi * (t * rt + tau))   

        # Rotational motion
        gam = table_g(t, rt, tau, p, rtOff)
        theta = gMax * gam
        dgam = d_table_g(t, rt, tau, p, rtOff)
        dth = gMax * dgam

    elif mpath == 1:
        pass

    elif mpath == 2:
        pass

    elif mpath == 3:
        pass

    elif mpath == 4:
        pass

    elif mpath == 5:
        pass

    else:
        raise ValueError("invalid mpath value")
    
    return phi, theta, dph, dth


# TODO: Helper functions
def table_g(t, rt, tau, p, rtOff):
    def table_b(t, rt, tau, p, rtOff):
        pass

    tB = t % (2.0 / rt)
    return table_b(tB, rt, tau, p, rtOff)

def d_table_g(t, rt, tau, p, rtOff):
    def d_table_b(t, rt, tau, p, rtOff):
        pass

    tB = t % (2.0 / rt)
    return d_table_b(tB, rt, tau, p, rtOff)