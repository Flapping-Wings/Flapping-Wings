import numpy as np
import globals as g
import matplotlib.pyplot as plt

def symmetric_5_sided_mesh(W, lt_, lr_, bang_, hfactor, wfactor):
    """
    Create a symmetric, 5-sided wing mesh

    Equivalent to MATLAB function `tbs5mesh`

    Parameters
    ----------
    W: int 
        1 (forward wing), 2 (rear wing)
    lt_: float
        Length of tapered section of the wing in cm
    lr_: float
        Length of straight section of the wing in cm
    bang_: float
        Base angle (angle between tapered edge and centerline) of the wing in degrees
    hfactor: float
        Ratio of border element height to wing chord length
    wfactor: float
        Ratio of border element width to border element height

    Returns
    -------
    Xb: ndarray[j, n, i]
        Border element coordinates
    nXb: int
        Number of border elements
    Nb: ndarray[j, i]
        Unit normals to the border elements
    Xc: ndarray[j, n, i]
        Center element coordinates
    nXc: int
        Number of center elements
    Nc: ndarray[j, i]
        Unit normals to the center elements
    l_: float
        Wing span length
    c_: float
        Wing chord length
    h: float
        Height of border element
    """
    g.itaper = bang_ != 90

    bang = np.pi * bang_ / 180.00
    l_ = lt_ * np.cos(bang) + lr_
    c_ = 2.0 * lt_ * np.sin(bang)
    h = c_ * hfactor
    
    """
    Center elements:
    
    If ielong is False, use the same # of border strips (n(i)) to create rectangular grid:
        Tapered Section
        - nCelmti = n[2] : # of major division in x-direction
        - nCelmtj = n[0] : # of major division in y-direction
        Rectangular Section
        - nCelmri = n[2] : # of square elements in x-direction
        - nCelmrj = n[1] : # of square elements in y-direction
    If ielong is True, use n[2] to create rectangular grid
        Tapered Section
        - nCelmti = n[2] : # of major division in x-direction
        - nCelmtj = n[2] : # of major division in y-direction
        Rectangular Section
        - nCelmri = n[2] : # of square elements in x-direction
        - nCelmri = n[2] : # of square elements in y-direction
    """

    Xb, nXb, Nb, Lt, Lr, C, n, wi_1 = WingBorder(lt_, lr_, bang, l_, c_, hfactor, wfactor)
    Xc, nXc, Nc = WingCenter(Lt, Lr, C, bang, l_, c_, n, wi_1)

    # Plot Mesh
    if g.mplot:
        fig2, ax2 = plt.subplots()
        plot2Elem(fig2, ax2, Xb, nXb, 4, 'r', 2)
        plot2Elem(fig2, ax2, Xc, nXc, 4, 'b', 2)
        fig2.savefig(f"{g.folder}mesh/2dmesh_{W}.png")
        plt.close()

        fig3 = plt.figure()
        ax3 = fig3.add_subplot(projection='3d')
        plot3Elem(fig3, ax3, Xb, nXb, Nb)
        plot3Elem(fig3, ax3, Xc, nXc, Nc)
        fig3.savefig(f"{g.folder}mesh/3dmesh_{W}.png")
        plt.close()
        
    return Xb, nXb, Nb, Xc, nXc, Nc, l_, c_, h

#------------------------------------------------------------#

def WingBorder(lt, lr, bang, l_, c_, hfactor, wfactor):
    
    """
    Create mesh for tapered/nontapered rectangular wings
    
    Parameters
    ----------
    lt: float
        Length of tapered section of the wing in cm
    lr: float
        Length of straight section of the wing in cm
    bang: float
        Base angle (angle between tapered edge and centerline) of the wing in radians
    c_: float
        Wing chord length
    hfactor: float
        Ratio of border element height to wing chord length

    Returns
    -------
    Xb: ndarray[j, n, i]
        Border element coordinates
    nXb: int 
        Number of border elements
    Nb: ndarray[j, i]
        Unit normals to the border elements
    Lt: float
        Length of tapered section of the wing
    Lr: float
        Length of straight section of the wing
    C: float
        Length of center region of the mesh
        (wing chord length with border elements removed)
    n: ndarray
        Number of rectangles in each border strip
    wi_0: float
        TODO
    """
    
    N = 5               # Number of border strips
    h = hfactor * c_    # Dimensional border height

    # Global position of the origin of the border strip systems
    sdel = np.sin(bang)
    cdel = np.cos(bang)
    xo = np.array([[0.0, -lt*sdel, -lt*sdel   , lt*sdel   , lt*sdel],
                   [0.0,  lt*cdel,  lt*cdel+lr, lt*cdel+lr, lt*cdel]])
    ang = np.array([bang, 0.0, -0.5*np.pi, -(np.pi), -(np.pi+bang)])

    # Width of the rectangular elements in the border strips and number of rectangular elements on them
    if not g.ielong:
        n, w, wi, wf, Lt, Lr, C = BStrip(lt, lr, c_, bang, h, wfactor)
    else:
        n, w, wi, wf, Lt, Lr, C = BStripElongated(lt, lr, c_, bang, h)

    sumn = np.sum(n)
    nXb = sumn # No Corner Elements
    Xb = np.zeros((3, 5, nXb))
    Nb = np.zeros((3, nXb))

    inf = -1

    for i in range(N):
        xeE = BRelemLoc(n[i], wi[i], w[i], wf[i], h)
        xeE = BRelem(xeE, xo[:, i], ang[i])
        Xb[0:2, 0, (inf+1)] = xeE[:, 0, 0]
        Xb[0:2, 1:4, (inf+1)] = xeE[:, 1:4, 1]

        inf += n[i]
        ini = inf - n[i] + 2
        Xb[0:2, :, ini:(inf+1)] = xeE[:, :, 2:(n[i] + 1)]
        Xb[0:2, 1, inf] = xeE[:, 1, n[i]+1]

    # Introduce the camber
    Xb[2, :, :] = Camber(Xb[0, ...], Xb[1, ...], l_, c_, g.icamber, g.acamber)

    # Unit normal to the element
    for i in range(nXb):
        Nb[:, i] = uNormal(Xb[0, :, i], Xb[1, :, i], Xb[2, :, i])

    # Centroid
    Xb[:, 4, :] = 0.25 * (Xb[:, 0, :] + Xb[:, 1, :] + Xb[:, 2, :] + Xb[:, 3, :])

    wi_0 = wi[0]

    return Xb, nXb, Nb, Lt, Lr, C, n, wi_0

def BStrip(lt, lr, c, bang, h, wfactor):
    
    """
    Width of the rectangular elements in the border strips with # of rectangular elements on them
    
    INPUT:
    - lt     : Length of the tapered section
    - lr     : Length of the Rectangular Section
    - c      : Chord length of the rectangular section
    - bang  : Half taper angle (radian)
    - h      : height of the border strip
    
    OUTPUT:
    - n[i]   : # of rectangles in the strip
    - w[i]   : width of the multiple middle rectangular elements
    - wi[i]  : width of the first rec element
    - wf[i]  : width of the last rec element, where i = [0:5)
    - Lt
    - Lr
    - C
    """
    
    alpha = 0.5 * (np.pi - bang)
    float_eps = np.finfo(float).eps
    
    # Reduced outline length for the center region
    Lt = lt - h * ((1.0 / np.tan(bang)) + (1.0 / np.tan(alpha)))
    Lr = lr - h * ((1.0 / np.tan(alpha)) + 1)
    C = c - 2.0 * h

    n = np.zeros(5, dtype=int)
    w = np.zeros(5)
    wi = np.zeros(5)
    wf = np.zeros(5)

    r = np.zeros(3)

    wh = wfactor * h

    # Border Strip 1
    Lt += float_eps
    n[0] = np.floor(Lt / wh).astype(int)  # # of rectangles in the strip
    r[0] = Lt % wh
    if n[0] != 0:
        w[0] = wh + r[0] / n[0]  # Width of the multiple middle rectangular elements
    else:
        n[0] = 1
        w[0] = Lt
    wi[0] = h * (1 / np.tan(bang)) # Width of the first rec element
    wf[0] = h * (1 / np.tan(alpha)) # Width of the last rec element

    # Border Strip 2
    Lr += float_eps
    n[1] = np.floor(Lr / wh)
    r[1] = Lr % wh
    if n[1] != 0:
        w[1] = wh + r[1] / n[1]
    else:
        n[1] = 1
        w[1] = Lr
    wi[1] = h * (1 / np.tan(alpha))
    wf[1] = h

    # Border Strip 3
    C += float_eps  # Add the small machine epsilon to avoid truncation
    n[2] = np.floor(C / wh)
    r[2] = C % wh
    if n[2] != 0:
        w[2] = wh + r[2] / n[2]
    else:
        n[2] = 1
        w[2] = C
    wi[2] = h
    wf[2] = h

    # Border Strip 4
    n[3] = n[1]
    w[3] = w[1]
    wi[3] = wf[1]
    wf[3] = wi[1]

    # Border Strip 5
    n[4] = n[0]
    w[4] = w[0]
    wi[4] = wf[0]
    wf[4] = wi[0]

    return n, w, wi, wf, Lt, Lr, C

# TODO: Test this function
def BStripElongated(lt, lr, c, bang, h):
    
    """
    Width of the rectangular elements in the border strips
    # of rectangular elements on them is fixed, determined by the # for the tip border

    INPUT:
    - lt     : Length of the tapered section
    - lr     : Length of the Rectangular Section
    - c      : Chord length of the rectangular section
    - bang  : Half taper angle (radian)
    - h      : height of the border strip
    
    OUTPUT:
    - n[i]   : # of rectangles in the strip
    - w[i]   : width of the multiple middle rectangular elements
    - wi[i]  : width of the first rec element
    - wf[i]  : width of the last rec element, where i = [0:5)
    - Lt
    - Lr
    - C
    
    """
    
    altha = 0.5 * (np.pi - bang)
    Lt = lt - h * ((1 / np.tan(bang)) + (1 / np.tan(altha)))
    Lr = lr - h * (1 / np.tan(altha) + 1)
    C = c - 2.0 * h
    float_eps = np.finfo(float).eps
    tmp = C / h + float_eps  # Add the smallest number to avoid truncation

    r = C % h
    n = np.zeros(5)
    w = np.zeros(5)
    wi = np.zeros(5)
    wf = np.zeros(5)

    # Border Strip 1 
    n[0] = np.floor(tmp).astype(int)
    w[0] = Lt / n[0]                 # Width of the multiple middle rectangular elements
    wi[0] = h * (1 / np.tan(bang))  # Width of the first rec element
    wf[0] = h * (1 / np.tan(altha))  # Width of the last rec element
    
    # Border Strip 2
    n[1] = n[0]
    w[1] = Lr / n[1]
    wi[1] = h * (1 / np.tan(altha))
    wf[1] = h
    
    # Border Strip 3
    n[2] = n[0]
    w[2] = h + r / n[0]
    wi[2] = h
    wf[2] = h

    # Border Strip 4
    n[3] = n[0]
    w[3] = w[1]
    wi[3] = wf[1]
    wf[3] = wi[1]

    # Border Strip 5
    n[4] = n[0]
    w[4] = w[0]
    wi[4] = wf[0]
    wf[4] = wi[0]

    return n, w, wi, wf, Lt, Lr, C

def BRelemLoc(m, wi, w, wf, h):
    
    """
    Node Coordinates of local rectangular edge elements over a border strip
    For each element, the node starts at the left bottom and rotates clock-wise
    1     2
       4
    0     3
    x = horizontal, y = vertical directions
    
    INPUT:
    - m            : # of middle elements
    - wi, w, wf    : size of initial, middle, and final elements (in y-direction)
    - h            : height of all the elements (in x-direction)
    
    OUTPUT:
    - xeE[j, n, i] : j coordinates of the n-th node of the i-th edge square elements
                    -> j = 0,1 ; n = 0-4 (4 - center point) ; i = 0-(m+1)  
    """
    
    # Element Width Array
    ww = np.zeros(m + 2)
    y = np.zeros(m + 2)
    xeE = np.zeros((2, 5, m+2))

    # y-coordinates array of the center points
    ww[0] = wi
    ww[1:(m+1)] = w
    ww[m+1] = wf

    # Coordinates of 5 nodes of elements
    y[0] = 0.5 * wi
    for i in range(1, m+2):
        y[i] = wi + (i - 0.5) * w
    y[m + 1] = wi + m * w + 0.5 * wf

    xeE[0, 0:2, :] = 0.0
    xeE[0, 2:4, :] = h
    xeE[0, 4  , :] = 0.5 * h
    xeE[1, 0  , :] = y[:] - 0.5 * ww[:]
    xeE[1, 1  , :] = y[:] + 0.5 * ww[:]
    xeE[1, 2  , :] = y[:] + 0.5 * ww[:]
    xeE[1, 3  , :] = y[:] - 0.5 * ww[:]
    xeE[1, 4  , :] = y[:]

    return xeE

def BRelem(xeE, Xo, Ang):
    
    """
    Transform coordinates from local to global border rectangular elements
    
    INPUT:
    - xeE[j, n, i]  : local j coordinates of the n-th node of the i-th edge square elements
    - Xo[j]         : global coordinates of the origin of the local system 
    - Ang           : rotation of the local wrt of the global system
    
    OUTPUT:
    - xeE[j, n, i]  : global j coordinates of the n-th node of the i-th node square elements
    
    """
    
    new_xeE = xeE
    cang = np.cos(Ang)
    sang = np.sin(Ang)
    xeE_1 = xeE[0, :, :]
    xeE_2 = xeE[1, :, :]
    XEE_1 = cang * xeE_1 - sang * xeE_2 + Xo[0]
    XEE_2 = sang * xeE_1 + cang * xeE_2 + Xo[1]
    new_xeE[0, :, :] = XEE_1
    new_xeE[1, :, :] = XEE_2

    return new_xeE

def Camber(x, y, l_, c_, icamber, amplitude):

    """
    Calculate z values of the wing, given (x, y)

    Parameters
    ----------
    x, y: ndarrays
        (x, y) coordinates of node j
    l_: float
        Wing span length
    c_: float
        Wing chord length
    icamber: int
        Camber direction
    amplitude: float
        Camber amplitude

    Returns
    -------
    z: ndarray
        z coordinates of node j

    """
    if icamber == 0:
        z = np.zeros(x.shape)
    elif icamber == 1:
        z = amplitude * (np.pow(float(-(x / (0.5 * c_))), 2) + 1)
    elif icamber == 2:
        z = amplitude * (np.pow(float(-(y / l_)), 2) + 1)
    elif icamber == 3:
        z = amplitude * (np.pow(float(-(x / (0.6 * c_))), 2) + 1) * (np.pow(float(-(y / l_)), 2) + 1)
    else:
        raise ValueError("invalid value for icamber")

    return z

def uNormal(x, y, z):

    """
    Calculate the unit normal to a rectangular element

    Parameters
    ----------
    x, y, z: ndarrays
        Coordinates of the nodes of the element

    Returns
    -------
    uN: ndarray
        Unit normal to the rectangular plane
    """
    
    node = np.hstack((x[:, np.newaxis], y[:, np.newaxis], z[:, np.newaxis]))
    N = np.cross(node[2, :] - node[0, :], node[1, :] - node[3, :])
    magN = np.linalg.norm(N)
    uN = N / magN

    return uN

#------------------------------------------------------#

def WingCenter(Lt, Lr, C, bang, l_, c_, n, wi_1):

    """
    Meshing for the center region

    INPUT:
    - Lt     : Length of the tapered edge for the center region
    - Lr     : Length of the horizontal edge for the center region
    - C      : Length of vertical tip edge of the center region
    - bang  : Base opening angle / 2
    - n[i]   : Number of border strip elements: i = 0:5 
    - wi_1

    OUTPUT:
    - Xc     : Total center rectangular elements
    - nXc    : # of total center rectangular elements
    - Nc     : Unit normal to the elements
    """

    Xct, Xcr = CRnodes(Lt, Lr, C, bang, n) # Coordinates of the nodes for the center region

    """
    RECTANGULAR MESH POINTS BY ROWS (x-direction) & COLUMNS (y-direction)
    For each element, the node starts at the bottom-left and rotates clock-wise
    1     2       ir,ic+1   ir+1,ic+1
       4      =
    0     3       ir,ic     ir+1,ic
    x - horizontal, y - vertical direction
    """

    XctS = np.empty([2, 4, n[2], n[0]])
    XcrS = np.empty([2, 4, n[2], n[0]])
    XcrR = np.empty([2, 4, n[1] * n[2]])

    if g.itaper:
        # Tapered Region
        for ic in range(n[0]):
            for ir in range(n[2]):
                for j in range(2):
                    XctS[j, 0, ir, ic] = Xct[j, ir    , ic    ]
                    XctS[j, 1, ir, ic] = Xct[j, ir    , ic + 1]
                    XctS[j, 2, ir, ic] = Xct[j, ir + 1, ic + 1]
                    XctS[j, 3, ir, ic] = Xct[j, ir + 1, ic    ]
    # Rectangular Region
    for ic in range(n[1]):
        for ir in range(n[2]):
            for j in range(2):
                XcrS[j, 0, ir, ic] = Xcr[j, ir    , ic    ]
                XcrS[j, 1, ir, ic] = Xcr[j, ir    , ic + 1]
                XcrS[j, 2, ir, ic] = Xcr[j, ir + 1, ic + 1]
                XcrS[j, 3, ir, ic] = Xcr[j, ir + 1, ic    ]

    # Rectangular and Polygon Mesh
    if g.itaper:
        # Tapered Region - Triangular Apex Mesh w/ 4 Nodes
        i = 0
        ic = 0
        XctR = np.empty([2, 4, n[0] + 1]) 

        for j in range(2):
            XctR[j, 0, i] = XctS[j, 0, 0, ic]
            XctR[j, 1, i] = XctS[j, 1, 0, ic]
            XctR[j, 3, i] = XctS[j, 2, n[2] - 1, ic]

        XctR[0, 2, i] = 0.0
        XctR[1, 2, i] = XctS[1, 1, 0, ic]
        i += 1


        for ic in range(1, n[0]):
            for ir in range(n[2]):
                for j in range(2):
                    XctR[j, 0, i] = XctS[j, 0, ir, ic]
                    XctR[j, 1, i] = XctS[j, 1, ir, ic]
                    XctR[j, 2, i] = XctS[j, 2, ir, ic]
                    XctR[j, 3, i] = XctS[j, 3, ir, ic]
                i += 1
        
        nXctR = i

    # Rectangular Region
    i = 0
    for ic in range(n[1]):
        for ir in range(n[2]):
            for j in range(2):
                XcrR[j, 0, i] = XcrS[j, 0, ir, ic]
                XcrR[j, 1, i] = XcrS[j, 1, ir, ic]
                XcrR[j, 2, i] = XcrS[j, 2, ir, ic]
                XcrR[j, 3, i] = XcrS[j, 3, ir, ic]
            i += 1
    nXcrR = i

    if g.itaper:
        # Total Center Rectangular Elements
        nXc = nXctR + nXcrR
        Xc = np.zeros([2, 5, nXc])
        Nc = np.zeros((3, nXc))

        Xc[:, 0:4, 0:nXctR] = XctR 
        Xc[:, 0:4, nXctR:nXc] = XcrR

        # Introduce the camber 
        temp = np.zeros((1, 5, nXc))
        temp[:, 0:4, 0:] = Camber(Xc[0, 0:4, :], Xc[1, 0:4, :], l_, c_, g.icamber, g.acamber)
        Xc = np.vstack((Xc, temp))
        
        # Unit Normal to the element
        for i in range(nXc):
            Nc[:, i] = uNormal(Xc[0, :, i], Xc[1, :, i], Xc[2, :, i])

        # Centroid
        Xc[:, 4, :] = 0.25 * (Xc[:, 0, :] + Xc[:, 1, :] + Xc[:, 2, :] + Xc[:, 3, :])

        # Add the eta-coordinate (vertical) of the corder
        yshift = wi_1 / np.cos(bang)
        Xc[1, :, :] = Xc[1, :, :] + yshift
    else:
        # Total center rectangular element
        nXc = nXcrR
        Xc = np.zeros([2, 4, nXc])
        Nc = np.zeros([3, nXc])

        Xc[:, :, 0:nXc] = XcrR
        
        # Introduce the Camber
        Xc[2, :, :] = Camber(Xc[0, :, :], Xc[1, :, :], l_, c_, g.icamber, g.acamber)
        
        # Unit normal to the element
        for i in range(nXc):
            Nc[:, i] = uNormal(Xc[0, :, i], Xc[1, :, i], Xc[2, :, i])
        
        # Centroid 
        Xc[:, 4, :] = 0.25 * (Xc[:, 0, :] + Xc[:, 1, :] + Xc[:, 2, :] + Xc[:, 3, :])
        
        # Add the eta-coordinate (vertical) of the corder
        yshift = g.h_
        Xc[1, :, :] = Xc[1, :, :] + yshift

    return Xc, nXc, Nc

def CRnodes(Lt, Lr, C, bang, n):

    """
    Coordinates of the nodes for the rectangular mesh in the center region

    INPUT:
    - Lt    : Length of the tapered edge for the center region
    - Lr    : Length of the horizontal edge for the center region
    - C     
    - bang : Half-base opening angle
    - n[i]  : Number of border strips elements: i = 0:5

    OUTPUT:
    - Xct   : Nodes in the tapered region
    - Xcr   : Nodes in the rectangular region
    """
    
    # Angle and length of radial lines
    e = Lt * np.cos(bang)
    lt = np.zeros(n[2] + 1)
    ang = np.zeros(n[2] + 1)
    Xct = np.zeros([2, n[2] + 1, n[0] + 1])
    Xcr = np.zeros([2, n[2] + 1, n[1] + 1])

    for i in range(n[2] + 1):
        z = (-0.5 + i / n[2]) * C
        lt[i] = np.sqrt(z ** 2 + e ** 2)
        ang[i] = np.arccos(z / lt[i])

    # Tapered Region
    for ir in range(n[2] + 1):
        theta = ang[ir]
        dlt = lt[ir] / n[0]
        for ic in range(n[0] + 1):
            r = ic * dlt
            Xct[0, ir, ic] = r * np.cos(theta)
            Xct[1, ir, ic] = r * np.sin(theta)

    # Rectangular Region
    y0 = Lt * np.cos(bang)
    dy = Lr / n[1]
    for ir in range(n[2] + 1):
        x = lt[ir] * np.cos(ang[ir])
        for ic in range(n[1] + 1):
            y = y0 + ic * dy
            Xcr[0, ir, ic] = x
            Xcr[1, ir, ic] = y

    return Xct, Xcr

#------------------------------------------------------#

def plot2Elem(fig, axs, Xn, nXn, npoly, color, lw):
    
    """
    Plot a group of polygonal elements in x-y plane

    INPUT:
    - Xn[j, n, i] : Polynomial element array
    - nXn         : # of elements 
    - npoly       : Order of polygon
    - color       : Color in the plot
    - lw          : Line width
    """

    for i in range(nXn):
        x = np.zeros(npoly + 1)
        y = np.zeros(npoly + 1)

        for ipoly in range(npoly):
            x[ipoly] = Xn[0, ipoly, i]
            y[ipoly] = Xn[1, ipoly, i]
        
        x[npoly] = Xn[0, 0, i]
        y[npoly] = Xn[1, 0, i]
        cx = Xn[0, npoly, i]
        cy = Xn[1, npoly, i]

        axs.plot(x, y, color, linewidth=lw)
        axs.plot(cx, cy, 'o')
        axs.axis('equal')

    return

def plot3Elem(fig, axs, X, nX, N):
    
    """
    Plot 3D elements with the unit normals

    INPUT:
    - X[j, n, i] : Rectangular element array
    - nX         : # of elements
    - N[j, i]    : Unit normal to the element
    """

    scale = 0.1
    Nline = np.zeros((2, 3))
    x = np.zeros(5)
    y = np.zeros(5)
    z = np.zeros(5)

    for i in range(nX):
        for n in range(4):
            x[n] = X[0, n, i]
            y[n] = X[1, n, i]
            z[n] = X[2, n, i]
        x[4] = X[0, 0, i]
        y[4] = X[1, 0, i]
        z[4] = X[2, 0, i]
        axs.plot(x, y, z, 'k')
        Nline[:,:] = np.array([X[:, 4, i], X[:, 4, i] + scale * N[:, i]]) 
        axs.plot(Nline[:, 0], Nline[:, 1], Nline[:, 2], 'r') 
        axs.axis('equal')


    return
