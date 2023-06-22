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
    # Airfoil velocity components in global system
    sbt = np.sin(beta)
    cbt = np.cos(beta)
    sth = np.sin(theta)
    cth = np.cos(theta)
    sph = np.sin(phi)
    cph = np.cos(phi)  
        
    ab = -sth * (xC[0, :] + a) + cth * xC[2, :]
    xb =  cth * (xC[0, :] + a) + sth * xC[2, :]
    vxb = dth * ab
    vyb =  sph * dth * xb - cph * dph * ab - sph * dph * xC[2, :]
    vzb = -cph * dth * xb - sph * dph * ab + cph * dph * xC[2, :]
    
    if iwing == 2:      # Flip left wing coordinates
        vyb = -vyb
    
    vx = -U[0] + sbt * vxb + cbt * vzb
    vy = -U[1] + vyb
    vz = -U[2] - cbt * vxb + sbt * vzb

    # Normal velocity components of the airfoil
    Vnc = vx * NC[0, :] + vy * NC[1, :] + vz * NC[2, :]

    if g.vplot:
        plot_normal_vel()

    return Vnc


# TODO
def plot_normal_vel():
    pass
