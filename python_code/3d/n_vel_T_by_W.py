import numpy as np

def n_vel_T_by_W(istep, nXt, XC, NC, Xw2_f, GAMAw2_f, nXw_f, Xw2_r, GAMAw2_r, nXw_r):
    """
    Calculate normal velocity contribution on the airfoil by wake vortices

    Parameters
    ----------
    istep: int
        Current iteration step
    nXt: int
        Number of collocation points
    XC: ndarray[3, nXt]
        Total collocation points
    NC: ndarray[3, nXt]
        Unit normal at the collocation points
    Xw2_f: ndarray[3, 4, nXw_f, nwing]
        Coordinates of the wake vortices (front)
    GAMAw2_f: ndarray[nwing, nXw_f]
        Wake vortices (front)
        (USE the value set in the previous step)
    nXw_f: int
        Number of wake vortices = istep*nXb (front)
        (USE the value set in the previous step)
    Xw2_r: ndarray[3, 4, nXw_r, nwing]
        Coordinates of the wake vortices (rear)
    GAMAw2_r: ndarray[nwing, nXw_r]
        Wake vortex (rear) 
        (USE the value set in the previous step)
    nXw_r: int
        Number of wake vortices = istep*nXb (rear)
        (USE the value set in the previous step)

    Returns
    -------
    Vncw: ndarray[nXt]
        Normal velocity components at the collocation points due to
        wake vortices
    """
    pass
