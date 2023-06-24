import numpy as np
from mVORTEX import mVORTEX

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
    Vncw = np.zeros(nXt)

    if istep <= 0:
        return Vncw
    
    # TODO: Lots of repetition, probably lots of parallelizable tasks, lots of opitmization opportunities
    # Contribution from forward wing wake
    GAMAw = GAMAw2_f[0, :]
    GAMw = np.reshape(GAMAw, (1, 1 , nXw_f))
    Xw = Xw2_f[:, :, :, 0]
    for i in range(nXt):
        x = XC[0, i]
        y = XC[1, i]
        z = XC[2, i]
        u, v, w = 0, 0, 0
    
        u1, v1, w1 = mVORTEX(x, y, z, Xw[0,0,:], Xw[1,0,:], Xw[2,0,:], Xw[0,1,:], Xw[1,1,:], Xw[2,1,:], GAMw)
        u = u + u1
        v = v + v1
        w = w + w1
        u2, v2, w2 = mVORTEX(x, y, z, Xw[0,1,:], Xw[1,1,:], Xw[2,1,:], Xw[0,2,:], Xw[1,2,:], Xw[2,2,:], GAMw)
        u = u + u2
        v = v + v2
        w = w + w2
        u3, v3, w3 = mVORTEX(x, y, z, Xw[0,2,:], Xw[1,2,:], Xw[2,2,:], Xw[0,3,:], Xw[1,3,:], Xw[2,3,:], GAMw)
        u = u + u3
        v = v + v3
        w = w + w3
        u4, v4, w4 = mVORTEX(x, y, z, Xw[0,3,:], Xw[1,3,:], Xw[2,3,:], Xw[0,0,:], Xw[1,0,:], Xw[2,0,:], GAMw)
        u = u + u4
        v = v + v4
        w = w + w4
    
        Vncw[i] += u * NC[0, i] + v * NC[1, i] + w * NC[2, i]
    
    GAMAw = GAMAw2_f[1, :]
    GAMw = np.reshape(GAMAw, (1, 1, nXw_f))
    Xw = Xw2_f[:, :, :, 1]
    for i in range(nXt):
        x = XC[0, i]
        y = XC[1, i]
        z = XC[2, i]
        u, v, w = 0, 0, 0
    
        u1, v1, w1 = mVORTEX(x, y, z, Xw[0,0,:], Xw[1,0,:], Xw[2,0,:], Xw[0,1,:], Xw[1,1,:], Xw[2,1,:], GAMw)
        u = u + u1
        v = v + v1
        w = w + w1
        u2, v2, w2 = mVORTEX(x, y, z, Xw[0,1,:], Xw[1,1,:], Xw[2,1,:], Xw[0,2,:], Xw[1,2,:], Xw[2,2,:], GAMw)
        u = u + u2
        v = v + v2
        w = w + w2
        u3, v3, w3 = mVORTEX(x, y, z, Xw[0,2,:], Xw[1,2,:], Xw[2,2,:], Xw[0,3,:], Xw[1,3,:], Xw[2,3,:], GAMw)
        u = u + u3
        v = v + v3
        w = w + w3
        u4, v4, w4 = mVORTEX(x, y, z, Xw[0,3,:], Xw[1,3,:], Xw[2,3,:], Xw[0,0,:], Xw[1,0,:], Xw[2,0,:], GAMw)
        u = u + u4
        v = v + v4
        w = w + w4
    
        Vncw[i] += u * NC[0, i] + v * NC[1, i] + w * NC[2, i]    
 
    # Contribution from rear wing wake
    GAMAw = GAMAw2_r[0, :]
    GAMw = np.reshape(GAMAw, (1, 1, nXw_r))
    Xw = Xw2_r[:, :, :, 0]
    for i in range(nXt):
        x = XC[0, i]
        y = XC[1, i]
        z = XC[2, i]
        u, v, w = 0, 0, 0
    
        u1, v1, w1 = mVORTEX(x, y, z, Xw[0,0,:], Xw[1,0,:], Xw[2,0,:], Xw[0,1,:], Xw[1,1,:], Xw[2,1,:], GAMw)
        u = u + u1
        v = v + v1
        w = w + w1
        u2, v2, w2 = mVORTEX(x, y, z, Xw[0,1,:], Xw[1,1,:], Xw[2,1,:], Xw[0,2,:], Xw[1,2,:], Xw[2,2,:], GAMw)
        u = u + u2
        v = v + v2
        w = w + w2
        u3, v3, w3 = mVORTEX(x, y, z, Xw[0,2,:], Xw[1,2,:], Xw[2,2,:], Xw[0,3,:], Xw[1,3,:], Xw[2,3,:], GAMw)
        u = u + u3
        v = v + v3
        w = w + w3
        u4, v4, w4 = mVORTEX(x, y, z, Xw[0,3,:], Xw[1,3,:], Xw[2,3,:], Xw[0,0,:], Xw[1,0,:], Xw[2,0,:], GAMw)
        u = u + u4
        v = v + v4
        w = w + w4
    
        Vncw[i] += u * NC[0, i] + v * NC[1, i] + w * NC[2, i]
    
    GAMAw = GAMAw2_r[1, :]
    GAMw = np.reshape(GAMAw, (1, 1, nXw_r))
    Xw = Xw2_r[:, :, :, 1]
    for i in range(nXt):
        x = XC[0, i]
        y = XC[1, i]
        z = XC[2, i]
        u, v, w = 0, 0, 0
    
        u1, v1, w1 = mVORTEX(x, y, z, Xw[0,0,:], Xw[1,0,:], Xw[2,0,:], Xw[0,1,:], Xw[1,1,:], Xw[2,1,:], GAMw)
        u = u + u1
        v = v + v1
        w = w + w1
        u2, v2, w2 = mVORTEX(x, y, z, Xw[0,1,:], Xw[1,1,:], Xw[2,1,:], Xw[0,2,:], Xw[1,2,:], Xw[2,2,:], GAMw)
        u = u + u2
        v = v + v2
        w = w + w2
        u3, v3, w3 = mVORTEX(x, y, z, Xw[0,2,:], Xw[1,2,:], Xw[2,2,:], Xw[0,3,:], Xw[1,3,:], Xw[2,3,:], GAMw)
        u = u + u3
        v = v + v3
        w = w + w3
        u4, v4, w4 = mVORTEX(x, y, z, Xw[0,3,:], Xw[1,3,:], Xw[2,3,:], Xw[0,0,:], Xw[1,0,:], Xw[2,0,:], GAMw)
        u = u + u4
        v = v + v4
        w = w + w4
    
        Vncw[i] += u * NC[0, i] + v * NC[1, i] + w * NC[2, i]     

    return Vncw
