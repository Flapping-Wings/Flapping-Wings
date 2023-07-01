import numpy as np
import matplotlib.pyplot as plt

def wingPath(t, e, c, a, beta, gMax, p, rtOff, U, V, W, phiT, phiB, l, AZ, EL):
    # Wing motion path for cambered wing
    # INPUT Variables (all nondimensional)
    # t         time
    # e         stroke difference
    # c         chord length
    # a         rotation distance offset
    # beta      stroke angle
    # gMax      maximum rotation
    # p         rotation velocity parameter
    # rtOff     rotation timing offset
    # U, V, W   ambient velocity
    # phiT, phiB top and bottom stroke angles
    # l         wing span
    # AZ, EL    3dplot view
    # ========================================================================
    global tau, iplot, folder

    # LOCAL Variables
    sump = phiT - phiB

    # Rolling Motion
    phi = 0.5 * sump * (np.cos(np.pi * (t + tau)) + e)

    # Rotational Motion
    f = tableG(t, p, rtOff)
    theta = gMax * f

    # Edge positions of the tip code for the composite motion
    x0L = -0.5 * c
    x0T = +0.5 * c
    x0C = 0.0
    y0L = l
    y0T = l
    y0C = l
    z0L = Camber2(x0L, y0L, c, l)
    z0T = Camber2(x0T, y0T, c, l)
    z0C = Camber2(x0C, y0C, c, l)
    XL, YL, ZL, XT, YT, ZT, XC, YC, ZC = wingMotion(a, x0L, x0T, x0C, y0L, y0T, y0C, z0L, z0T, z0C, theta, phi, beta)

    # Edge positions of the base code for the composite motion
    x0L = -0.5 * c
    x0T = +0.5 * c
    x0C = 0.0
    y0L = 0
    y0T = 0
    y0C = 0
    z0L = Camber2(x0L, y0L, c, l)
    z0T = Camber2(x0T, y0T, c, l)
    z0C = Camber2(x0C, y0C, c, l)
    XLB, YLB, ZLB, XTB, YTB, ZTB, XCB, YCB, ZCB = wingMotion(a, x0L, x0T, x0C, y0L, y0T, y0C, z0L, z0T, z0C, theta, phi, beta)

    # Add effect of the ambient air velocity
    #XL, ZL, YL = translate(XL, ZL, YL, t, U, V, W)
    #XT, ZT, YT = translate(XT, ZT, YT, t, U, V, W)
    #XC, ZC, YC = translate(XC, ZC, YC, t, U, V, W)
    #XLB, ZLB, YLB = translate(XLB, ZLB, YLB, t, U, V, W)
    #XTB, ZTB, YTB = translate(XTB, ZTB, YTB, t, U, V, W)
    #XCB, ZCB, YCB = translate(XCB, ZCB, YCB, t, U, V, W)

    #if iplot == 1:
    #    fig = plt.figure()
    #    ax = fig.add_subplot(111, projection='3d')
    #    ax.plot([XL, XT, XTB, XLB, XL], [YL, YT, YTB, YLB, YL], [ZL, ZT, ZTB, ZLB, ZL])
    #    ax.plot(XC, YC, ZC, '-', linewidth=2)
    #    ax.plot(XCB, YCB, ZCB, 'r-', linewidth=2)
    #    ax.view_init(AZ, EL)
    #    ax.axis('equal')
    #    ax.grid(True)
    #    plt.savefig(folder + 'pass/chordPassR.fig')
    #    plt.close()

def tableG(t, p, rtOff):
    # Table function for an arbitrary time
    global tau

    tB = t % 2
    y = tableB(tB + tau, p, rtOff)

    return y

def tableB(t, p, rtOff):
    # Basic Table function for gamma for two periods 0<= t <= 4
    # INPUT VARIABLES
    # rtOff     rotation timing offset

    f0 = 2.0 / (1.0 + np.exp(-2.0 * p * (t - (0.0 + rtOff))))
    f1 = 2.0 / (1.0 + np.exp(-2.0 * p * (t - (1.0 + rtOff))))
    f2 = 2.0 / (1.0 + np.exp(-2.0 * p * (t - (2.0 + rtOff))))
    f3 = 2.0 / (1.0 + np.exp(-2.0 * p * (t - (3.0 + rtOff))))
    f4 = 2.0 / (1.0 + np.exp(-2.0 * p * (t - (4.0 + rtOff))))
    y = 1.0 - f0 + f1 - f2 + f3 - f4

    return y


def Camber2(x, y, c, l):
    # Calculate z values of the wing, given (x,y)
    # INPUT (can be all dimensional or all nondimensional)
    # x(j),y(j) x, y coordinates of the node j
    # l,c       span, chord lengths

    global icamber, acamber

    # icamber   camber option
    # acamber   camber amplitude

    if icamber == 0:
        z = np.zeros_like(x)
    elif icamber == 1:
        z = acamber * (-(x / (0.5 * c)) ** 2 + 1)
    elif icamber == 2:
        z = acamber * (-(y / l) ** 2 + 1)
    elif icamber == 3:
        z = acamber * (-(x / (0.5 * c)) ** 2 + 1) * (-(y / l) ** 2 + 1)
    else:
        print('Use icamber 1, 2, or 3')

    return z

def wingMotion(a, x0L, x0T, x0C, y0L, y0T, y0C, z0L, z0T, z0C, theta, phi, beta):
    # INPUT
    # a         rotation offset from the y-axis
    # x0L,y0L,z0L   leading edge point on the wing-coordinate
    # x0C,y0C,z0C   center point on the wing-coordinate
    # x0T,y0T,z0T   trailing edge point on the wing-coordinate
    # theta     pitching
    # phi       roll
    # beta      stroke plane angle

    xL, yL, zL = wingMotionB(a, x0L, y0L, z0L, theta, phi)
    xT, yT, zT = wingMotionB(a, x0T, y0T, z0T, theta, phi)
    xC, yC, zC = wingMotionB(a, x0C, y0C, z0C, theta, phi)

    sb = np.sin(beta)
    cb = np.cos(beta)
    XL, ZL, YL = yRotate(sb, cb, xL, zL, yL)
    XT, ZT, YT = yRotate(sb, cb, xT, zT, yT)
    XC, ZC, YC = yRotate(sb, cb, xC, zC, yC)

    return XL, YL, ZL, XT, YT, ZT, XC, YC, ZC

def yRotate(sb, cb, x, z, y):
    #INPUT
    # sb,cb         sin and cos beta
    # x,z,y         position for beta=pi/2
    X = sb * x + cb * z
    Z = -cb * x + sb * z
    Y = y

    return X, Z, Y

def wingMotionB(a, x0, y0, z0, theta, phi):
    # Motion of a single point on a cambered wing
    # a         rotation offset
    # x0,y0,z0     coordinates of the wing point
    # theta     pitch
    # phi       roll

    cth = np.cos(theta)
    sth = np.sin(theta)
    cph = np.cos(phi)
    sph = np.sin(phi)

    x = (a + x0) * cth + z0 * sth
    y = y0 * cph + (a + x0) * sth * sph - z0 * cth * sph
    z = y0 * sph - (a + x0) * sth * cph + z0 * cth * cph

    return x, y, z


def translate(X, Z, Y, t, U, V, W):
    # Implement the translate function
    pass
