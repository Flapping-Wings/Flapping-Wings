import numpy as np
from mVORTEX import mVORTEX
from numba import njit

@njit(cache=True)
def vel_by(istep, X_target, nX_target, X_f, GAMA_f, nX_f, X_r, GAMA_r, nX_r):
    """
    Calculate velocity at target nodes due to source vortices

    This is a generalization of `tbvelBbyW`, `tbvelWbyT`, and
    `tbvelWbyW`

    Parameters
    ----------
    istep: int
        Current iteration step
    X_target: ndarray[j, n, iXw]
        Coordinate j of observation node n of the target element node
    nX: int
        Number of target elements
    X_f: ndarray[j, n, iXt, w]
        Coordinate j of source node n for source elements on front wings
    GAMA_f: ndarray[w, iXt]
        Source elements on front wings
    nX_f: int
        Number of source elements on front wings
    X_r: ndarray[j, n, iXt, w]
        Coordinate j of source node n for source elements on rear wings
    GAMA_r: ndarray[w, iXt]
        Source elements on rear wings
    nX_r: int
        Number of total elements on rear wings

    Returns
    -------
    vel: ndarray[j, n, iXb]
        Induced velocity
    """
    vel = np.zeros((3, 4, nX_target))

    if istep == 0:
        return vel

    # Front wings
    # Contribution from right wing
    GAMA = GAMA_f[0,:]
    GAM = np.reshape(GAMA, nX_f)
    X = X_f[:,:,:nX_f,0]
    helper(X_target, nX_target, vel, X, GAM)

    # Contribution from left wing
    GAMA = GAMA_f[1,:]
    GAM = np.reshape(GAMA, nX_f)
    X = X_f[:,:,:nX_f,1]
    helper(X_target, nX_target, vel, X, GAM)


    # Rear wings
    # Contribution from right wing
    GAMA = GAMA_r[0,:]
    GAM = np.reshape(GAMA, nX_r)
    X = X_r[:,:,:nX_r,0]
    helper(X_target, nX_target, vel, X, GAM)


    # Contribution from left wing
    GAMA = GAMA_r[1,:]
    GAM = np.reshape(GAMA, nX_r)
    X = X_r[:,:,:nX_r,1]
    helper(X_target, nX_target, vel, X, GAM)

    return vel


@njit(cache=True)
def helper(X_target, nX_target, vel, X, GAM):
    for i in range(nX_target):
        for n in range(4):
            x = X_target[0, n, i]
            y = X_target[1, n, i]
            z = X_target[2, n, i]
            u, v, w = 0, 0, 0

            u1, v1, w1 = mVORTEX(x, y, z, X[0,0,:], X[1,0,:], X[2,0,:], X[0,1,:], X[1,1,:], X[2,1,:], GAM)
            u += u1
            v += v1
            w += w1
            u2, v2, w2 = mVORTEX(x, y, z, X[0,1,:], X[1,1,:], X[2,1,:], X[0,2,:], X[1,2,:], X[2,2,:], GAM)
            u += u2
            v += v2
            w += w2
            u3, v3, w3 = mVORTEX(x, y, z, X[0,2,:], X[1,2,:], X[2,2,:], X[0,3,:], X[1,3,:], X[2,3,:], GAM)
            u += u3
            v += v3
            w += w3
            u4, v4, w4 = mVORTEX(x, y, z, X[0,3,:], X[1,3,:], X[2,3,:], X[0,0,:], X[1,0,:], X[2,0,:], GAM)
            u += u4
            v += v4
            w += w4

            vel[0, n, i] += u
            vel[1, n, i] += v
            vel[2, n, i] += w