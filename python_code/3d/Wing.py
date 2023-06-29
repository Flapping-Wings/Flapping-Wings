import numpy as np
from globals import g

""" Initialize all Wing dimensions for the forward and rear wings to use later in the code. """

def Wing():
    """
    Output (ALL DIMENSIONAL):

    -------FORWARD WING--------
    Xb_f[j, n, i]    - Border element coordinates
    nXb_f            - # of border elements
    Nb_f[j, i]       - Unit normal to the border elements
    Xc_f[j, n, i]    - Center element coordinates
    nXc_f            - # of center elements
    Nc_f[j, i]       - Unit normal to the center elements
    l_f              - Span
    c_f              - Chord
    h_f              - Border Height

    
    
    ---------REAR WING---------
    Xb_r[j, n, i]    - Border element coordinates
    nXb_r            - # of border elements
    Nb_r[j, i]       - Unit normal to the border elements
    Xc_r[j, n, i]    - Center element coordinates
    nXc_r            - # of center elements
    Nc_r[j, i]       - Unit normal to the center elements
    l_r              - Span
    c_r              - Chord
    h_r              - Border Height 
    """

    # Forward Wing Dimensions
    hfactor_f = 0.1
    wfactor_f = 3

    Xb_f, nXb_f, Nb_f, Xc_f, nXc_f, Nc_f, l_f, c_f = tbs5Mesh(1, 2, 2, 30, hfactor_f, wfactor_f)
    h_f = c_f * hfactor_f

    # Rear Wing Dimensions
    hfactor_r = 0.1
    wfactor_r = 3

    Xb_r, nXb_r, Nb_r, Xc_r, nXc_r, Nc_r, l_r, c_r = tbs5Mesh(2, 1, 1, 30, hfactor_r, wfactor_r)
    h_r = c_r * hfactor_r

    return Xb_f, nXb_f, Nb_f, Xc_f, nXc_f, Nc_f, l_f, c_f, h_f, Xb_r, nXb_r, Nb_r, Xc_r, nXc_r, Nc_r, l_r, c_r, h_r


def tbs5Mesh(W, lt_, lr_, bang_, hfac, wfac):
    """
    Input:
    - W   = 1 (forward), 2(rear) wing

    Output:
    - lo_ = span
    - co_ = chord length

    """

    # Symmetrical Tapered Mesh
    g.mplot = 1

    """
    Rectangular Elements Count:
    - nXb = # of shed edge elements
    - nXc = # of center elements

    Wing Geometry:
    - lt_ = tapered section wing span (cm)
    - lr_ = square section wing span (cm)
    - bang_ = base angle (deg)
    - c_ = chord length of the rectangular section

    """

    # Assume a tapered wing by default
    g.itaper = 1

    if bang_ == 90:
        g.itaper = 0

    bang = np.pi * bang_ / 180.00

    g.c_ = 2.0 * lt_ * np.sin(bang)
    g.l_ = lt_ * np.cos(bang) + lr_
    g.hfactor = hfac
    g.wfactor = wfac
    g.ielong = 0
    
    g.icamber = 0
    g.acamber = 0.2

    Xb, nXb, Nb, Lt, Lr, C, n, wi_1 = WingBorder(lt_, lr_, bang)

    Xc, nXc, Nc = WingCenter(Lt, Lr, C, bang, n, wi_1)

    lo_ = g.l_
    co_ = g.c_

    if g.mplot == 1:
        print("hello")

    return Xb, nXb, Nb, Xc, nXc, Nc, lo_, co_

#------------------------------------------------------------#

def WingBorder(lt, lr, delta):
    
    N = 5                   # Number of border Strips
    g.h_ = g.hfactor * g.c_ # Height of each border strip
    c = g.c_                  # Dimensional Chord Length
    h = g.h_                  # Dimensional Border Height

    # Global position of the origin of the border strip systems
    sdel = np.sin(delta)
    cdel = np.cos(delta)
    xo = np.array([[0.0, -lt*sdel, -lt*sdel   , lt*sdel   , lt*sdel],
                   [0.0,  lt*cdel,  lt*cdel+lr, lt*cdel+lr, lt*cdel]])
    ang = np.array([delta, 0.0, -0.5*np.pi, -(np.pi), -(np.pi+delta)])

    # Width of the rectangular elements in the border strips and number of rectangular elements on them
    if g.ielong == 0:
        n, w, wi, wf, Lt, Lr, C = BStrip(lt, lr, c, delta, h)
    else:
        n, w, wi, wf, Lt, Lr, C = BStripElongated(lt, lr, c, delta, h)

    sumn = np.sum(n)
    nXb = sumn
    Xb = np.zeros((3, 5, nXb))
    Nb = np.array([[],[],[]])

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

    Xb[2, :, :] = Camber(Xb[0, :, :], Xb[1, :, :])

    for i in range(nXb):
        Nb = np.hstack((Nb, uNormal(Xb[0, :, i], Xb[1, :, i], Xb[2, :, i])))

    Xb[:, 4, :] = 0.25 * (Xb[:, 0, :] + Xb[:, 1, :] + Xb[:, 2, :] + Xb[:, 3, :])

    wi_0 = wi[0]

    return Xb, nXb, Nb, Lt, Lr, C, n, wi_0

def BStrip(lt, lr, c, delta, h):
    alpha = 0.5 * (np.pi - delta)
    float_eps = np.finfo(float).eps
    
    # Reduced outline length for the center region
    Lt = lt - h * ((1.0 / np.tan(delta)) + (1.0 / np.tan(alpha)))
    Lr = lr - h * ((1.0 / np.tan(alpha)) + 1)
    C = c - 2.0 * h

    n = np.zeros(5, dtype=int)
    w = np.zeros(5)
    wi = np.zeros(5)
    wf = np.zeros(5)

    r = np.zeros(3)

    wh = g.wfactor * h

    # Border Strip 1
    Lt += float_eps
    n[0] = np.floor(Lt / wh).astype(int)
    r[0] = Lt % wh
    if n[0] != 0:
        w[0] = wh + r[0] / n[0]
    else:
        n[0] = 1
        w[0] = Lt
    wi[0] = h * (1 / np.tan(delta))
    wf[0] = h * (1 / np.tan(alpha))

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
    C += float_eps
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
    wi[3] = wi[1]
    wf[3] = wf[1]

    # Border Strip 5
    n[4] = n[0]
    w[4] = w[0]
    wi[4] = wi[0]
    wf[4] = wf[0]

    return n, w, wi, wf, Lt, Lr, C

def BStripElongated(lt, lr, c, delta, h):
    altha = 0.5 * (np.pi - delta)
    Lt = lt - h * ((1 / np.tan(delta)) + (1 / np.tan(altha)))
    Lr = lr - h * (1 / np.tan(altha) + 1)
    C = c - 2.0 * h
    float_eps = np.finfo(float).eps
    tmp = C / h + float_eps

    r = C % h
    n = np.zeros(5)
    w = np.zeros(5)
    wi = np.zeros(5)
    wf = np.zeros(5)

    # Border Strip 1 
    n[0] = np.floor(tmp).astype(int)
    w[0] = Lt / n[0]
    wi[0] = h * (1 / np.tan(delta))
    wf[0] = h * (1 / np.tan(altha))
    
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
    wi[3] = wi[1]
    wf[3] = wi[1]

    # Border Strip 5
    n[4] = n[0]
    w[4] = w[0]
    wi[4] = wi[0]
    wf[4] = wf[0]

    return n, w, wi, wf, Lt, Lr, C

def BRelemLoc(m, wi, w, wf, h):
    
    ww = np.zeros(m + 2)
    y = np.zeros(m + 2)
    xeE = np.zeros((2, 5, m+2))

    ww[0] = wi
    ww[1:(m+1)] = w
    ww[m+1] = wf

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

def Camber(x, y): # TODO: Test if this actually works, this implementation might need some NumPy fandangling
    
    if g.icamber == 0:
        z = np.zeros(x.shape)
    elif g.icamber == 1:
        z = g.acamber * (np.pow(float(-(x / (0.5 * g.c_))), 2) + 1)
    elif g.icamber == 2:
        z = g.acamber * (np.pow(float(-(y / g.l_)), 2) + 1)
    elif g.icamber == 3:
        z = g.acamber * (np.pow(float(-(x / (0.6 * g.c_))), 2) + 1) * (np.pow(float(-(y / g.l_)), 2) + 1)
    # Not sure if we need the last default output where it outputs the necessity to use icamber = [0, 1, 2, 3]

    return z

def uNormal(x, y, z):
    
    node = np.zeros([4,3])
    for i in range(4):
        node[i, :] = np.array([x[i], y[i], z[i]])
    N = np.cross(np.subtract(node[2, :], node[0, :]), np.subtract(node[1, :], node[3, :]))
    magN = np.linalg.norm(N)
    uN = N / magN
    uN = uN[..., np.newaxis]

    return uN

#------------------------------------------------------#

def WingCenter(Lt, Lr, C, delta, n, wi_1):

    Xct, Xcr = CRnodes(Lt, Lr, C, delta, n)
    print(f"Xct: {Xct}\n")
    print(f"Xcr: {Xcr}\n")

    XctS = np.empty([2, 4, n[2], n[0]])
    XcrS = np.empty([2, 4, n[2], n[0]])
    XcrR = np.empty([2, 4, n[1] * n[2]])

    if g.itaper == 1:
        # Tapered Region
        for ic in range(n[0]):
            for ir in range(n[2]):
                for j in range(2):
                    XctS[j, 0, ir, ic] = Xct[j, ir    , ic    ]
                    XctS[j, 1, ir, ic] = Xct[j, ir    , ic + 1]
                    XctS[j, 2, ir, ic] = Xct[j, ir + 1, ic + 1]
                    XctS[j, 3, ir, ic] = Xct[j, ir + 1, ic    ]

    for ic in range(n[1]):
        for ir in range(n[2]):
            for j in range(2):
                XcrS[j, 0, ir, ic] = Xcr[j, ir    , ic    ]
                XcrS[j, 1, ir, ic] = Xcr[j, ir    , ic + 1]
                XcrS[j, 2, ir, ic] = Xcr[j, ir + 1, ic + 1]
                XcrS[j, 3, ir, ic] = Xcr[j, ir + 1, ic    ]

    # Rectangular and Polygon Mesh
    if g.itaper == 1:
        # Tapered Region - Triangular Apex Mesh w/ 4 Nodes
        i = 0
        ic = 0
        XctR = np.empty([2, 4, n[0] + 1]) # TODO: This one is a bit iffy, might need a check on this one

        for j in range(2):
            XctR[j, 0, i] = XctS[j, 0, 0, ic]
            XctR[j, 1, i] = XctS[j, 1, 0, ic]
            XctR[j, 3, i] = XctS[j, 2, n[2] - 1, ic]

        XctR[0, 2, i] = 0.0
        XctR[1, 2, i] = XctS[1, 1, 0, ic]
        i += 1


        for ic in range(1, n[0]): # TODO: Test out of bounds error
            for ir in range(n[2]):
                for j in range(2):
                    XctR[j, 0, i] = XctS[j, 0, ir, ic]
                    XctR[j, 1, i] = XctS[j, 1, ir, ic]
                    XctR[j, 2, i] = XctS[j, 2, ir, ic]
                    XctR[j, 3, i] = XctS[j, 3, ir, ic]
                print(f"i before increment: {i}")
                i += 1
        print(f"i after loops: {i}")
        
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

    if g.itaper == 1:
        # Total Center Rectangular Elements
        nXc = nXctR + nXcrR
        Xc = np.zeros([2, 5, nXc])
        Nc = np.array([[],[],[]])
        print(f"nXctR: {nXctR}, nXcrR: {nXcrR}, nXc: {nXc}")
        print(f"XctR: {XctR}, XcrR: {XcrR}")

        Xc[:, 0:4, 0:nXctR] = XctR # TODO: Test if the indices are correct when outputting
        Xc[:, 0:4, nXctR:nXc] = XcrR

        temp = np.zeros((1, 5, nXc))
        temp[:, 0:4, 0:] = Camber(Xc[0, 0:4, :], Xc[1, 0:4, :])
        Xc = np.vstack((Xc, temp))
        
        for i in range(nXc):
            print(f"i in Nc: {i}")
            Nc = np.hstack((Nc, uNormal(Xc[0, :, i], Xc[1, :, i], Xc[2, :, i])))

        Xc[:, 4, :] = 0.25 * (Xc[:, 0, :] + Xc[:, 1, :] + Xc[:, 2, :] + Xc[:, 3, :])

        yshift = wi_1 / np.cos(delta)
        Xc[1, :, :] = Xc[1, :, :] + yshift
    else:
        nXc = nXcrR
        Xc = np.zeros([2, 4, nXc])
        Nc = np.zeros([3, nXc])

        Xc[:, :, 0:nXc] = XcrR

        Xc[2, :, :] = Camber(Xc[0, :, :], Xc[1, :, :])

        for i in range(nXc):
            Nc[:, i] = uNormal(Xc[0, :, i], Xc[1, :, i], Xc[2, :, i])

        Xc[:, 4, :] = 0.25 * (Xc[:, 0, :] + Xc[:, 1, :] + Xc[:, 2, :] + Xc[:, 3, :])

        yshift = g.h_
        Xc[1, :, :] = Xc[1, :, :] + yshift

    return Xc, nXc, Nc

def CRnodes(Lt, Lr, C, delta, n):
    
    e = Lt * np.cos(delta)
    lt = np.zeros(n[2] + 1)
    ang = np.zeros(n[2] + 1)
    Xct = np.zeros([2, n[2] + 1, n[0] + 1])
    Xcr = np.zeros([2, n[2] + 1, n[1] + 1])

    for i in range(n[2] + 1):
        z = (-0.5 + i / n[2]) * C
        lt[i] = np.sqrt(z ** 2 + e ** 2)
        ang[i] = np.arccos(z / lt[i])

    print(f"LT: {lt}\n")
    print(f"ANG: {ang}\n")

    # Tapered Region
    for ir in range(n[2] + 1):
        theta = ang[ir]
        dlt = lt[ir] / n[0]
        for ic in range(n[0] + 1):
            r = ic * dlt
            Xct[0, ir, ic] = r * np.cos(theta)
            Xct[1, ir, ic] = r * np.sin(theta)

    # Rectangular Region
    y0 = Lt * np.cos(delta)
    dy = Lr / n[1]
    for ir in range(n[2] + 1):
        x = lt[ir] * np.cos(ang[ir])
        for ic in range(n[1] + 1):
            y = y0 + ic * dy
            Xcr[0, ir, ic] = x
            Xcr[1, ir, ic] = y

    return Xct, Xcr
