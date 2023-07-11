import numpy as np
import matplotlib.pyplot as plt
import math


def tbwingPathTail(td, nhp, w, iwing, t, rt, e, c, a, b, beta, delta, gMax, p, rtOff, tau, U, V, W, phiT, phiB, l, AZ,
                   EL):
    # Wing path For left wing
    # INPUT Variables (all nondimensional)
    # td        1 (top-down), 2(down-up)
    # nhp       # of half-period for sinusoidal & tail
    # w         1 (right), 2 (left) wing
    # iwing     wing numbering (2 or 4)
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

    # LOCAL Variables
    sump = phiT - phiB

    # Rolling Motion
    phi = 0.5 * sump * cosTailG(td, nhp, t, rt, g.tau, e)

    # Rotational Motion
    gam = tableSTailG(td, nhp, t, rt, g.tau, p, rtOff)
    theta = gMax * gam

    # Effective flap plane angle considering the body angle
    beta = beta - delta

    # Edge positions of the tip code for the composite motion
    x0L = -0.5 * c
    x0T = 0.5 * c
    x0C = 0.0
    y0L = l
    y0T = l
    y0C = l
    XL, YL, ZL, XT, YT, ZT, XC, YC, ZC = wingMotionNC(a, x0L, x0T, x0C, y0L, y0T, y0C, theta, phi, beta)
    if w == 2:
        # Change the sign of y-components
        YL = -YL
        YT = -YT
        YC = -YC

    # Edge positions of the base code for the composite motion
    x0L = -0.5 * c
    x0T = 0.5 * c
    x0C = 0.0
    y0L = 0
    y0T = 0
    y0C = 0
    XLB, YLB, ZLB, XTB, YTB, ZTB, XCB, YCB, ZCB = wingMotionNC(a, x0L, x0T, x0C, y0L, y0T, y0C, theta, phi, beta)
    if w == 2:
        # Change the sign of y-components
        YLB = -YLB
        YTB = -YTB
        YCB = -YCB

    # Add effect of the ambient air velocity
    XL, ZL, YL = tbtranslate(XL, ZL, YL, t, U, V, W, b, delta)
    XT, ZT, YT = tbtranslate(XT, ZT, YT, t, U, V, W, b, delta)
    XC, ZC, YC = tbtranslate(XC, ZC, YC, t, U, V, W, b, delta)
    XLB, ZLB, YLB = tbtranslate(XLB, ZLB, YLB, t, U, V, W, b, delta)
    XTB, ZTB, YTB = tbtranslate(XTB, ZTB, YTB, t, U, V, W, b, delta)
    XCB, ZCB, YCB = tbtranslate(XCB, ZCB, YCB, t, U, V, W, b, delta)

    if g.iplot == 1:
        if iwing == 1:
            gid = plt.figure()
        plt.plot([XL, XT, XTB, XLB, XL], [YL, YT, YTB, YLB, YL], [ZL, ZT, ZTB, ZLB, ZL])
        plt.plot(XC, YC, ZC, '-', linewidth=2)
        plt.plot(XCB, YCB, ZCB, 'r-', linewidth=2)
        plt.view_init(AZ, EL)
        plt.axis('equal')
        plt.grid(True)

        if iwing == 1:
            plt.savefig(g.folder + 'pass/wingPassTail.png')

        plt.show()


def cosTailG(t, e):
    # cos tail function for an arbitrary time
    # cos for 2 periods and constant for 2 periods (wing stays still at the top)
    # motion starts from the top (no other options)
    tB = t % 8
    y = cosTailB(tB)
    y += e
    return y


def tableSTailG(t, p, rtOff):
    # Table function for an arbitrary time
    tB = t % 8
    y = tableSTailB(tB + g.tau, p, rtOff)
    return y


def tableSTailB(td, nhp, t, rt, tau, p, rtOff):
    # Table function with tail for gamma for 4 periods 0 <= t <= 8
    switch_td = {
        1: lambda nhp, t, rt, tau, p, rtOff: tableSTailB_case1(nhp, t, rt, tau, p, rtOff),
        2: lambda nhp, t, rt, tau, p, rtOff: tableSTailB_case2(nhp, t, rt, tau, p, rtOff)
    }
    return switch_td[td](nhp, t, rt, tau, p, rtOff)


def tableSTailB_case1(nhp, t, rt, tau, p, rtOff):
    switch_nhp = {
        8: lambda t, rt, tau, p, rtOff: tableSTailB_case1_nhp8(t, rt, tau, p, rtOff),
        4: lambda t, rt, tau, p, rtOff: tableSTailB_case1_nhp4(t, rt, tau, p, rtOff)
    }
    return switch_nhp[nhp](t, rt, tau, p, rtOff)


def tableSTailB_case1_nhp8(t, rt, tau, p, rtOff):
    f0 = 1.0 / (1.0 + np.exp(-2.0 * p * (t * rt + tau - (0.0 + rtOff))))
    f1 = 2.0 / (1.0 + np.exp(-2.0 * p * (t * rt + tau - (1.0 + rtOff))))
    f2 = 2.0 / (1.0 + np.exp(-2.0 * p * (t * rt + tau - (2.0 + rtOff))))
    f3 = 2.0 / (1.0 + np.exp(-2.0 * p * (t * rt + tau - (3.0 + rtOff))))
    f4 = 1.0 / (1.0 + np.exp(-2.0 * p * (t * rt + tau - (4.0 + rtOff))))
    f8 = 1.0 / (1.0 + np.exp(-2.0 * p * (t * rt + tau - (8.0 + rtOff))))
    y = -f0 + f1 - f2 + f3 - f4 - f8
    return y


def tableSTailB_case1_nhp4(t, rt, tau, p, rtOff):
    f0 = 1.0 / (1.0 + np.exp(-2.0 * p * (t * rt + tau - (0.0 + rtOff))))
    f1 = 2.0 / (1.0 + np.exp(-2.0 * p * (t * rt + tau - (1.0 + rtOff))))
    f2 = 1.0 / (1.0 + np.exp(-2.0 * p * (t * rt + tau - (2.0 + rtOff))))
    f4 = 1.0 / (1.0 + np.exp(-2.0 * p * (t * rt + tau - (4.0 + rtOff))))
    y = -f0 + f1 - f2 - f4
    return y


def tableSTailB_case2(nhp, t, rt, tau, p, rtOff):
    switch_nhp = {
        8: lambda t, rt, tau, p, rtOff: tableSTailB_case2_nhp8(t, rt, tau, p, rtOff),
        4: lambda t, rt, tau, p, rtOff: tableSTailB_case2_nhp4(t, rt, tau, p, rtOff)
    }
    return switch_nhp[nhp](t, rt, tau, p, rtOff)


def tableSTailB_case2_nhp8(t, rt, tau, p, rtOff):
    f0 = 1.0 / (1.0 + np.exp(-2.0 * p * (t * rt + tau - (0.0 + rtOff))))
    f1 = 2.0 / (1.0 + np.exp(-2.0 * p * (t * rt + tau - (1.0 + rtOff))))
    f2 = 2.0 / (1.0 + np.exp(-2.0 * p * (t * rt + tau - (2.0 + rtOff))))
    f3 = 2.0 / (1.0 + np.exp(-2.0 * p * (t * rt + tau - (3.0 + rtOff))))
    f4 = 1.0 / (1.0 + np.exp(-2.0 * p * (t * rt + tau - (4.0 + rtOff))))
    f8 = 1.0 / (1.0 + np.exp(-2.0 * p * (t * rt + tau - (8.0 + rtOff))))
    y = f0 - f1 + f2 - f3 + f4 + f8
    return y


def tableSTailB_case2_nhp4(t, rt, tau, p, rtOff):
    f0 = 1.0 / (1.0 + np.exp(-2.0 * p * (t * rt + tau - (0.0 + rtOff))))
    f1 = 2.0 / (1.0 + np.exp(-2.0 * p * (t * rt + tau - (1.0 + rtOff))))
    f2 = 1.0 / (1.0 + np.exp(-2.0 * p * (t * rt + tau - (2.0 + rtOff))))
    f4 = 1.0 / (1.0 + np.exp(-2.0 * p * (t * rt + tau - (4.0 + rtOff))))
    y = -f0 + f1 - f2 - f4
    y = -y
    return y


def wingMotionNC(a, x0L, x0T, x0C, y0L, y0T, y0C, theta, phi, beta):
    # INPUT
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
    # translation of the loction
    # INPUT
    # X,Z,Y     position
    # U,V,W     air speed (constant)
    # t         time
    # b         wing offset
    # delta     body angle
    X = X - U * t + b * math.cos(delta)
    Y = Y - V * t
    Z = Z - W * t - b * math.sin(delta)

    return X, Z, Y


def wingMotionNCB(a, x0, y0, theta, phi):
    # Motion of a single point on a non-cambered wing
    # a         rotation offfset
    # xo,yo     coordinates of the wing point
    # theta     pitch
    # phi       roll
    x = (a + x0) * math.cos(theta)
    y = y0 * math.cos(phi) + (a + x0) * math.sin(theta) * math.sin(phi)
    z = y0 * math.sin(phi) - (a + x0) * math.sin(theta) * math.cos(phi)

    return x, y, z


def yRotate(sb, cb, x, z, y):
    # INPUT
    # sb,cb         sin and cos beta
    # x,z,y         position for beta=pi/2
    X = sb * x + cb * z
    Z = -cb * x + sb * z
    Y = y

    return X, Z, Y


def cosTailB(td, nhp, t, rt, tau):
    # Basic cos function (0 <= t <= 4) with a tail (4 <= t <= 8)
    st = t.shape
    y = np.zeros(st)
    switch_td = {
        1: lambda nhp, t, rt, tau: cosTailB_case1(nhp, t, rt, tau),
        2: lambda nhp, t, rt, tau: cosTailB_case2(nhp, t, rt, tau)
    }
    return switch_td[td](nhp, t, rt, tau, y)


def cosTailB_case1(nhp, t, rt, tau, y):
    for i in range(len(t)):
        if t[i] <= nhp / 2:
            y[i] = np.cos(np.pi * (t[i] * rt + tau))
        else:
            y[i] = 1
    return y


def cosTailB_case2(nhp, t, rt, tau, y):
    for i in range(len(t)):
        if t[i] <= nhp / 2:
            y[i] = -np.cos(np.pi * (t[i] * rt + tau))
        else:
            y[i] = -1
    return y
