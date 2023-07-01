import numpy as np
from globals import g

# TODO: Remove unused parameters beta, phi, theta
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
            s = GAMAw.shape[1]  # Index limit to account for pre-allocation

            # Wake vortices
            # Linear impulse
            n1, n2, limp = limpulse(Xw_T[:,:,:s,i], GAMAw[i,:], beta[i], phi[i], theta[i], a[i])
            limpw[:,i] = limp       # limpw(:,istep) + limp

            # Angular impulse
            aimp = aimpulse(Xw_T[:,:,:s,i], n1, n2, GAMAw[i,:], beta[i], phi[i], theta[i], a[i])
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
    X = np.zeros((3, 3, s[2]))
    tindex = [0, 2, 3]
    X = Xa[:, tindex, :]
    n2, limp2 = slimpulse_tr(X, gama, beta, phi, theta, a)

    # Add linear impulses from the two triangles
    limp = limp1 + limp2

    return n1, n2, limp

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
    X = np.zeros((3, 3, s[2]))
    X = Xa[:, 0:3, :]
    aimp1 = saimpulse_tr(X, n1, gama, beta, phi, theta, a)

    # For triangle 0 2 3
    X = np.zeros((3, 3, s[2]))
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
    # Initialization
    s = np.shape(X)
    x1   = np.zeros((3,s[2]))
    x2   = np.zeros((3,s[2]))
    x1x2 = np.zeros((3, s[2]))
    n    = np.zeros((3,s[2]))
    limp = np.zeros(3)

    # Linear impulse
    for j in range(3):
        x1[j,:] = X[j,2,:] - X[j,0,:]
        x2[j,:] = X[j,1,:] - X[j,0,:]
    # Cross product of x1 and x2
    x1x2[0,:] = x1[1,:] * x2[2,:] - x1[2,:] * x2[1,:]
    x1x2[1,:] = x1[2,:] * x2[0,:] - x1[0,:] * x2[2,:]
    x1x2[2,:] = x1[0,:] * x2[1,:] - x1[1,:] * x2[0,:]
    # Add contributions from all elements
    limp[0] = -0.5 * np.dot(x1x2[0,:], gama)
    limp[1] = -0.5 * np.dot(x1x2[1,:], gama)
    limp[2] = -0.5 * np.dot(x1x2[2,:], gama)

    # Unit normal
    nx1x2 = np.sqrt(x1x2[0,:]**2 + x1x2[1,:]**2 + x1x2[2,:]**2)
    
    for j in range(3):
        n[j,:] = x1x2[j,:] / nx1x2

    return n, limp

def saimpulse_tr(X, n, gama, beta, phi, theta, a):
    """
    Calculate moment of inertia for the triangular elements in 
    the wing-translating system
    """
    h, lR, lL, S, xi, eta, xH = triangle(X)

    A = [a, 0, 0]

    s = np.shape(X)
    Int      = np.zeros((3, s[2]))
    IN       = np.zeros((3, s[2]))
    impulseA = np.zeros((3, s[2]))
    aimp = np.zeros(3)

    for j in range(3):
        Int[j,:] = (S * (A[j] + xH[j,:]) 
                    + (1/6) * h * (lR+lL) * (xi[j,:] * (lR-lL) + eta[j,:] *h))

    # Cross product of Int and n
    IN[0,:]= Int[1,:] * n[2,:] - Int[2,:] * n[1,:]
    IN[1,:]= Int[2,:] * n[0,:] - Int[0,:] * n[2,:]
    IN[2,:]= Int[0,:] * n[1,:] - Int[1,:] * n[0,:]

    for j in range(3):
        impulseA[j,:] = -gama * IN[j,:]
    
    for j in range(3):
        aimp[j] = np.sum(impulseA[j,:])
    
    return aimp

def triangle(X):
    """Geometry of a triangle element"""
    s = np.shape(X)
    x21 = np.zeros((3, s[2]))
    x23 = np.zeros((3, s[2]))

    for j in range(3):
        x21[j,:] = X[j,0,:] - X[j,1,:]
        x23[j,:] = X[j,2,:] - X[j,1,:]

    nx21 = np.sqrt(x21[0,:]**2 + x21[1,:]**2 + x21[2,:]**2)
    # nx23 = np.sqrt(x23[0,:]**2 + x23[1,:]**2 + x23[2,:]**2)   # Unused, TODO: Ask why

    l = nx21
    xi = np.zeros((3, s[2]))
    for j in range(3):
        xi[j,:] = x21[j,:] / l
    
    lL = x23[0,:] * xi[0,:] + x23[1,:] * xi[1,:] + x23[2,:] * xi[2,:]
    lR = l - lL

    xj2 = np.zeros((3, s[2]))
    xj3 = np.zeros((3, s[2]))
    x2H = np.zeros((3, s[2]))
    xH  = np.zeros((3, s[2]))
    xH3 = np.zeros((3, s[2]))

    for j in range(3):
        xj2[j,:] = X[j,1,:]
        xj3[j,:] = X[j,2,:]
        x2H[j,:] = x21[j,:] * lL / l
        xH [j,:] = xj2[j,:] + x2H[j,:]
        xH3[j,:] = xj3[j,:] - xH[j,:]
    
    h = np.sqrt(xH3[0,:]**2 + xH3[1,:]**2 + xH3[2,:]**2)

    eta = np.zeros((3, s[2]))
    for j in range(3):
        eta[j,:] = xH3[j,:] / h
    
    S = 0.5 * l * h

    return h, lR, lL, S, xi, eta, xH
