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
        f0 = 2.0 / (1.0 + np.exp(-2.0 * p * (t * rt + tau - (0.0 + rtOff))))
        f1 = 2.0 / (1.0 + np.exp(-2.0 * p * (t * rt + tau - (1.0 + rtOff))))
        f2 = 2.0 / (1.0 + np.exp(-2.0 * p * (t * rt + tau - (2.0 + rtOff))))
        f3 = 2.0 / (1.0 + np.exp(-2.0 * p * (t * rt + tau - (3.0 + rtOff))))
        f4 = 2.0 / (1.0 + np.exp(-2.0 * p * (t * rt + tau - (4.0 + rtOff))))
        
        return 1.0 - f0 + f1 - f2 + f3 - f4

    tB = t % (2.0 / rt)
    return table_b(tB, rt, tau, p, rtOff)

def d_table_g(t, rt, tau, p, rtOff):
    def d_table_b(t, rt, tau, p, rtOff):
        e0 = np.exp(-2.0 * p * (t * rt + tau - (0.0 + rtOff)))    
        e1 = np.exp(-2.0 * p * (t * rt + tau - (1.0 + rtOff)))    
        e2 = np.exp(-2.0 * p * (t * rt + tau - (2.0 + rtOff)))
        e3 = np.exp(-2.0 * p * (t * rt + tau - (3.0 + rtOff)))   
        e4 = np.exp(-2.0 * p * (t * rt + tau - (4.0 + rtOff))) 

        f0 = 4.0 * p * rt * e0 / (1.0+e0)**2
        f1 = 4.0 * p * rt * e1 / (1.0+e1)**2
        f2 = 4.0 * p * rt * e2 / (1.0+e2)**2
        f3 = 4.0 * p * rt * e3 / (1.0+e3)**2
        f4 = 4.0 * p * rt * e4 / (1.0+e4)**2

        return -f0 + f1 - f2 + f3 - f4

    tB = t % (2.0 / rt)
    return d_table_b(tB, rt, tau, p, rtOff)