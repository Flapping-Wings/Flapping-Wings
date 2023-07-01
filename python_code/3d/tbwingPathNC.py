import numpy as np
import matplotlib.pyplot as plt
import math
from globals import g

def tbwingPathNC(iwing,t,rt,e,c,a,b,beta,delta,gMax,p,rtOff, tau,U, V,W,phiT,phiB,l,AZ,EL):
    # Wing motion path for non-cambered wing
    # INPUT Variables (all nondimensional)
    # iwing     wing numbering (1:4)
    # t         time
    # rt        period ratio
    # e         stroke difference
    # c         chord length
    # a         rotation distance offset
    # b         wing offset
    # beta      stroke angle
    # delta     body angle
    # gMax      maximum rotation
    # p         rotation velocity parameter
    # rtOff     rotation timing offset
    # tau       phase shift
    # U, V, W   ambient velocity
    # phiT, phiB top and bottom stroke angles
    # l         wing span
    # AZ, EL    3dplot view

    # Global Variables
    global iplot, folder, gid

    # LOCAL Variables
    sump = phiT - phiB

    # Rolling Motion
    phi = 0.5 * sump * (np.cos(np.pi * (t * rt + tau)) + e)

    # Rotational Motion
    gam = dptableG(t, rt, tau, p, rtOff)
    theta = gMax * gam

    # Effective flap plane angle considering the body angle
    beta = beta - delta

    # Edge positions of the tip code for the composite motion
    x0L = -0.5 * c
    x0T = +0.5 * c
    x0C = 0.0
    y0L = l
    y0T = l
    y0C = l
    XL, YL, ZL, XT, YT, ZT, XC, YC, ZC = wingMotionNC(a, x0L, x0T, x0C, y0L, y0T, y0C, theta, phi, beta)

    # Edge positions of the base code for the composite motion
    x0L = -0.5 * c
    x0T = +0.5 * c
    x0C = 0.0
    y0L = 0
    y0T = 0
    y0C = 0
    XLB, YLB, ZLB, XTB, YTB, ZTB, XCB, YCB, ZCB = wingMotionNC(a, x0L, x0T, x0C, y0L, y0T, y0C, theta, phi, beta)

    # Add effects of the ambient air velocity and wing offset
    XL, ZL, YL = tbtranslate(XL, ZL, YL, t, U, V, W, b, delta)
    XT, ZT, YT = tbtranslate(XT, ZT, YT, t, U, V, W, b, delta)
    XC, ZC, YC = tbtranslate(XC, ZC, YC, t, U, V, W, b, delta)
    XLB, ZLB, YLB = tbtranslate(XLB, ZLB, YLB, t, U, V, W, b, delta)
    XTB, ZTB, YTB = tbtranslate(XTB, ZTB, YTB, t, U, V, W, b, delta)
    XCB, ZCB, YCB = tbtranslate(XCB, ZCB, YCB, t, U, V, W, b, delta)

    if iplot == 1:
        if iwing == 1:
            gid = plt.figure()

        plt.plot([XL, XT, XTB, XLB, XL], [YL, YT, YTB, YLB, YL], [ZL, ZT, ZTB, ZLB, ZL])
        plt.plot(XC, YC, ZC, '-', linewidth=2)
        plt.plot(XCB, YCB, ZCB, 'r-', linewidth=2)
        plt.view_init(AZ, EL)
        plt.axis('equal')
        plt.grid(True)
        plt.savefig(folder + 'pass/chordPassR.fig')
        plt.show()

def dptableG(t, rt, tau, p, rtOff):

    #Table function for an arbitrary time
    tB = t % (2.0 / rt)
    y = dptableB(tB, rt, tau, p, rtOff)
    return y


def wingMotionNC(a, x0L, x0T, x0C, y0L, y0T, y0C, theta, phi, beta):
    #INPUT
    # a         rotation offset from the y-axis
    # x0L,y0L   leading edge point on the wing-coordinate
    # x0C,y0C   center point on the wing-coordinate
    # x0T,y0T   trailing edge point on the wing-coordinate
    # theta     pitching
    # phi       roll
    # beta      stroke plane angle
    xL, yL, zL = wingMotionNCB(a, x0L, y0L, theta, phi)
    xT, yT, zT = wingMotionNCB(a, x0T, y0T, theta, phi)
    xC, yC, zC = wingMotionNCB(a, x0C, y0C, theta, phi)

    sb = math.sin(beta)
    cb = math.cos(beta)
    XL, ZL, YL = yRotate(sb, cb, xL, zL, yL)
    XT, ZT, YT = yRotate(sb, cb, xT, zT, yT)
    XC, ZC, YC = yRotate(sb, cb, xC, zC, yC)
    
    return XL, YL, ZL, XT, YT, ZT, XC, YC, ZC

def tbtranslate(X, Z, Y, t, U, V, W, b, delta):
    #translation of the loction
    #INPUT
    # X,Z,Y     position
    # U,V,W     air speed (constant)
    # t         time
    # b         wing offset
    # delta     body angle
    X = X - U * t + b * math.cos(delta)
    Y = Y - V * t
    Z = Z - W * t - b * math.sin(delta)
    
    return X, Z, Y

def dptableB(t, rt, tau, p, rtOff):
    #Basic Table function for gamma fot two periods 0<= t <= 4

    #INPUT VARIABLES
    # rtOff     rotation timing offset
    # rt        period ratio T_(1)/T_(i)
    # tau       phase shift
    # p         rotatio parameter
    f0 = 2.0 / (1.0 + math.exp(-2.0 * p * (t * rt + tau - (0.0 + rtOff))))
    f1 = 2.0 / (1.0 + math.exp(-2.0 * p * (t * rt + tau - (1.0 + rtOff))))
    f2 = 2.0 / (1.0 + math.exp(-2.0 * p * (t * rt + tau - (2.0 + rtOff))))
    f3 = 2.0 / (1.0 + math.exp(-2.0 * p * (t * rt + tau - (3.0 + rtOff))))
    f4 = 2.0 / (1.0 + math.exp(-2.0 * p * (t * rt + tau - (4.0 + rtOff))))
    
    y = 1.0 - f0 + f1 - f2 + f3 - f4
    return y

def wingMotionNCB(a, x0, y0, theta, phi):
    #Motion of a single point on a non-cambered wing
    # a         rotation offfset
    # xo,yo     coordinates of the wing point
    # theta     pitch
    # phi       roll
    x = (a + x0) * math.cos(theta)
    y = y0 * math.cos(phi) + (a + x0) * math.sin(theta) * math.sin(phi)
    z = y0 * math.sin(phi) - (a + x0) * math.sin(theta) * math.cos(phi)
    
    return x, y, z

def yRotate(sb, cb, x, z, y):
    #INPUT
    # sb,cb         sin and cos beta
    # x,z,y         position for beta=pi/2
    X = sb * x + cb * z
    Z = -cb * x + sb * z
    Y = y
    
    return X, Z, Y
