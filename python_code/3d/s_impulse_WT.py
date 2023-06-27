import numpy as np
from globals import g

def s_impulse_WT(istep, U, t, Xt, Xw, GAM, GAMAw, beta, phi, theta, a):
    """
    Calculate linear and angular impulses due to bound and wake 
    vortices in the body-translating system

    Parameters
    ----------
    istep: int
        Iteration step
    U: ndarray
        Ambient velocity
    t: float
        Time
    Xt: ndarray[j, n, i, w]
        Coordinates of the total elements on the wing
    Xw: ndarray[j, n, i, w]
        Coordinates of the wake vortices
    GAM: ndarray[w, i]
        Bound vortices
    GAMAw: ndarray[w, i]
        Wake vortices
    beta: ndarray
        Stroke plane angle
    phi: ndarray
        Wing rolling angle
    theta: ndarray
        Wing rotation angle
    a: ndarray
        Rotation axis offset

    Returns
    -------
    limpa: ndarray[j, w]
        Linear impulse from bound vortices
    aimpa: ndarray[j, w]
        Angular impulse from bound vortices
    limpw: ndarray[j, w]
        Linear impulse from wake vortices
    aimpw: ndarray[j, w]
        Angular impulse from wake vortices
    """
    pass
