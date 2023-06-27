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
    limpa = np.zeros((3, g.nwing))
    aimpa = np.zeros((3, g.nwing))
    limpw = np.zeros((3, g.nwing))
    aimpw = np.zeros((3, g.nwing))

    # From global to translating inertia
    Xt_T = np.zeros_like(Xt)
    Xw_T = np.zeros_like(Xw)

    for i in range(g.nwing):
        Xt_T[0,:,:,i] = U[0] * t + Xt[0,:,:,i]
        Xt_T[1,:,:,i] = U[1] * t + Xt[1,:,:,i]
        Xt_T[2,:,:,i] = U[2] * t + Xt[2,:,:,i]

        if istep > 0:
            Xw_T[0,:,:,i] = U[0] * t + Xw[0,:,:,i]
            Xw_T[1,:,:,i] = U[1] * t + Xw[1,:,:,i]
            Xw_T[2,:,:,i] = U[2] * t + Xw[2,:,:,i]

    for i in range(g.nwing):
        # Bound vortices
        # Linear impulse
        n1, n2, limp = limpulse(Xt_T[:,:,:,i], GAM[i,:], beta[i], phi[i], theta[i], a[i])
        # n1[j,nXt], n2[j,nXt] = unit normal for 2 triangular iXt_th element
        limpa[:,i] = limp
        # Angular impulse
        aimp = aimpulse(Xt_T[:,:,:,i], n1, n2, GAM[i,:], beta[i], phi[i], theta[i], a[i])
        aimpa[:,i] = aimp

        if istep > 0:
            # Wake vortices
            # Linear impulse
            n1, n2, limp = limpulse(Xw_T[:,:,:,i], GAMAw[i,:], beta[i], phi[i], theta[i], a[i])
            limpw[:,i] = limp       # limpw(:,istep) + limp

            # Angular impulse
            aimp = aimpulse(Xw_T[:,:,:,i], n1, n2, GAMAw[i,:], beta[i], phi[i], theta[i], a[i])
            aimpw[:,i] = aimp       # aimpw(:,istep) + aimp
    
    return limpa, aimpa, limpw, aimpw


def limpulse(Xa, gama, beta, phi, theta, a):
    """
    Calculate linear impulses in the wing-translating system

    Returns
    -------
    n1, n2: ndarray[j, i]
        Two unit normal vectors for two triangles
    limp: ndarray
        Linear impulse vector
    """
    # Divide Xa into 2 triangular elements
    # Rectangular element node numbering (x-horizontal; y-vertical)
    #  1   2
    # 
    #  0   3
    # Divide into 2 triangle elements: 012 & 023
    #  1   2        2
    #         &
    #  0        0   3
    s = np.shape(Xa)

    # For Triangle 0 1 2
    X = np.zeros((3, 3, s[2]))
    X = Xa[:, 0:3, :]
    n1, limp1 = slimpulse_tr(X, gama, beta, phi, theta, a)

    # For triangle 0 2 3
    X = np.zeros(3, 3, s[2])
    tindex = [0, 2, 3]
    X = Xa[:, tindex, :]
    n2, limp2 = slimpulse_tr(X, gama, beta, phi, theta, a)

    # Add linear impulses from the two triangles
    limp = limp1 + limp2

    return limp

def aimpulse(Xa, n1, n2, gama, beta, phi, theta, a):
    """
    Calculate moment of inertia in the wing-translating system

    Returns
    -------
    aimp: ndarray
        Angular impulse vector
    """
    # Divide Xa into 2 triangular elements
    # Rectangular element node numbering (x-horizontal; y-vertical)
    #  1   2
    # 
    #  0   3
    # Divide into 2 triangle elements: 012 & 023
    #  1   2        2
    #         &
    #  0        0   3
    s = np.shape(Xa)

    # For Triangle 0 1 2
    X = np.zeros(3, 3, s[2])
    X = Xa[:, 0:3, :]
    aimp1 = saimpulse_tr(X, n1, gama, beta, phi, theta, a)

    # For triangle 0 2 3
    X = np.zeros(3, 3, s[2])
    tindex = [0, 2, 3]
    X = Xa[:, tindex,:]
    aimp2 = saimpulse_tr(X, n2, gama, beta, phi, theta, a)

    # Add angular impulses from the two triangles
    aimp = aimp1 + aimp2
    
    return aimp

def slimpulse_tr(X, gama, beta, phi, theta, a):
    """
    Calculate linear impulses due to the triangular bound or wake 
    vortex elements in the wing-translating system
    """
    pass

def saimpulse_tr(X, n, gama, beta, phi, theta, a):
    """
    Calculate moment of inertia for the triangular elements in 
    the wing-translating system
    """

def triangle(X):
    """Geometry of a triangle element"""
    pass
