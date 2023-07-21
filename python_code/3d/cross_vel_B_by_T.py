import numpy as np
from mVORTEX import mVORTEX

def cross_vel_B_by_T(Xb, nXb, Xt, GAMA, nXt, RCUT, LCUT):
    """
    Calculate velocity at border element nodes of wing i due to total vortices
    on the wing j. The velocity is evaluated at the nodes; no offset 

    Parameters
    ----------
    Xb: ndarray[j, n, iXb]
        Coordinate j of observation node n of the wake element (destination)
    nXb: int
        Number of border vortices (destination)
    Xt[j, n, iXt]
        Coordinate j of source node n for the total element iXt on the wing
    GAMA: ndarray[iXt]
        Entire bound vortex (source)
    nXt: int
        Number of total elements on the wing (source)

    Returns
    -------
    VBT: ndarray[j, n, iXb]
        TODO
    """
    VBT = np.zeros((3, 4, nXb)) 
    GAMt = np.reshape(GAMA, nXt)

    for i in range(nXb):
        for n in range(4):
            x = Xb[0, n, i]
            y = Xb[1, n, i]
            z = Xb[2, n, i]
            u, v, w = 0, 0, 0

            u1, v1, w1 = mVORTEX(x, y, z, 
                                 Xt[0,0,:], Xt[1,0,:], Xt[2,0,:], 
                                 Xt[0,1,:], Xt[1,1,:], Xt[2,1,:], 
                                 GAMt, RCUT, LCUT)
            u += u1
            v += v1
            w += w1

            u2, v2, w2 = mVORTEX(x, y, z, 
                                 Xt[0,1,:], Xt[1,1,:], Xt[2,1,:], 
                                 Xt[0,2,:], Xt[1,2,:], Xt[2,2,:], 
                                 GAMt, RCUT, LCUT)
            u += u2
            v += v2
            w += w2

            u3, v3, w3 = mVORTEX(x, y, z, 
                                 Xt[0,2,:], Xt[1,2,:], Xt[2,2,:], 
                                 Xt[0,3,:], Xt[1,3,:], Xt[2,3,:], 
                                 GAMt, RCUT, LCUT)  
            u += u3
            v += v3
            w += w3

            u4, v4, w4 = mVORTEX(x, y, z, 
                                 Xt[0,3,:], Xt[1,3,:], Xt[2,3,:], 
                                 Xt[0,0,:], Xt[1,0,:], Xt[2,0,:], 
                                 GAMt, RCUT, LCUT)
            u += u4
            v += v4
            w += w4

            VBT[0, n, i] = u
            VBT[1, n, i] = v
            VBT[2, n, i] = w

    return VBT
