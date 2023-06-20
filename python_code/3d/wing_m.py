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
