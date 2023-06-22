import numpy as np
from globals import g

def lrs_wing_NVs(m, iwing, xC, XC, NC, t, theta, phi, dph, dth, a, beta, U):
    """
    Get the normal velocity at the wing collocation points XC[j, i]
    in the global system.

    Parameters
    ----------
    m: int
        0 (front wing), 1 (rear wing)
    iwing: int
        0 (right wing), 1 (left wing)
    xC: ndarray[j, i]
        Collocation points (wing-fixed)
    XC: ndarray[j, i]
        Collocation points (global)
    NC[j, i]
        Unit normals at collocation points (global)
    t: float
        Time
    theta: float
        Wing pitch angle
    phi: float
        Wing rolling angle
    dph: float
        Rate of change of rolling angle
    dth: float
        Rate of change of pitch angle
    a: float
        Rotation axis offset
    beta: float
        Stroke plane angle wrt the body axis
    U: ndarray
        Ambient velocity

    Returns
    -------
    Vnc: ndarray[1, nXC]
        Normal velocity (global)
    """
    pass
