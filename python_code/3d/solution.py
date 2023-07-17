import numpy as np
from scipy.linalg import lu_factor, lu_solve
import globals as g

def solution(nxt_f, nxt_r, MVN, Vnc_f, Vncw_f, Vnc_r, Vncw_r):
    """
    Solve the equations for the non-penetration condition

    Parameters
    ----------
    nxt_f: int
        Number of bound vortices for front wing
    nxt_r: int
        Number of bound vorties for rear wing
    MVN: ndarray[2 * (nxt_f + nxt_r), 2 * (nxt_f + nxt_r)]
        Coefficient matrix to be solved
    Vnc_f: ndarray[2, nxt_f]
        Normal velocity at the collocation points due to bound vortices (front)
    Vncw_f: ndarray[2, nxt_f]
        Normal velocity at the collocation points due to wake vortices (front)
    Vnc_r: ndarray[2, nxt_r]
        Normal velocity at the collocation points due to bound vortices (rear)
    Vncw_r: ndarray[2, nxt_r]
        Normal velocity at the collocation points due to wake vortices (rear)
    
    Returns
    -------
    GAMA: ndarray[2 * (nxt_f + nxt_r)]
    TODO
    """
    GAMA = np.zeros(2 * (nxt_f + nxt_r))

    # Front wings
    # Right
    GAMA[0:nxt_f]         = Vnc_f[0, 0:nxt_f] - Vncw_f[0, 0:nxt_f]
    # Left
    GAMA[nxt_f:(2*nxt_f)] = Vnc_f[1, 0:nxt_f] - Vncw_f[1, 0:nxt_f]

    # Rear wings
    # Right
    GAMA[(2*nxt_f):(2*nxt_f + nxt_r)]           = Vnc_r[0, 0:nxt_r] - Vncw_r[0, 0:nxt_r]
    # Left
    GAMA[(2*nxt_f + nxt_r):(2*nxt_f + 2*nxt_r)] = Vnc_r[1, 0:nxt_r] - Vncw_r[1, 0:nxt_r]

    if g.solver:
        # TODO
        pass
    else:
        MVN_lu = lu_factor(MVN)
        GAMA = lu_solve(MVN_lu, GAMA)

    return GAMA
