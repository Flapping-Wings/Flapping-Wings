import numpy as np
from globals import g

def nd_data(
        l_f, 
        c_f,
        h_f,
        l_r,
        c_r,
        h_r,
        phiT_,
        phiB_,
        a_,
        beta_,
        delta_,
        gMax_,
        U_,
        Xb_f,
        Xc_f,
        Xb_r,
        Xc_r,
        b_f,
        b_r
):
    """Nondimensionalize the input data"""
    # Wing span, chord, and border height
    l_ = np.array([l_f, l_f, l_r, l_r])
    c_ = np.array([c_f, c_f, c_r, c_r])
    h_ = np.array([h_f, h_f, h_r, h_r])

    # Period
    T_ = 1.0 / g.f_
    g.rt = T_[0] / T_
    # print statement here

    # Convert angles to radians
    fac = np.pi / 180
    phiT = fac * phiT_
    phiB = fac * phiB_
    beta = fac * beta_
    delta = fac * delta_
    gMax = fac * gMax_

    # Get non-dimensional quantities based on given
    # flight data of actual insect
    dT_ = l_ * phiT
    dB_ = l_ * -phiB
    g.d_ = dT_ + dB_
    # print here
    e_ = dT_ - dB_       # Stroke difference
    d = g.d_ / g.d_[0]      # d_[0] is the reference length

    a = a_ / g.d_[0]
    c = c_ / g.d_[0]
    l = l_ / g.d_[0]
    h = h_ / g.d_[0]
    # print here

    b_f = b_f / g.d_[0]
    b_r = b_r / g.d_[0]
    Xb_f = Xb_f / g.d_[0]
    Xb_r = Xb_r / g.d_[0]
    Xc_f = Xc_f / g.d_[0]
    Xc_r = Xc_r / g.d_[0]

    e = e_ / g.d_

    # Reference time - use the time for the right front wing
    g.t_ = T_[0] / 2.0

    # Reference velocity - use the right front wing flapping velocity
    g.v_ = g.d_[0] / g.t_
    # print here

    # Ambient velocity (nondimensional)
    U = U_ / g.v_
    # print here

    return l, c, h, phiT, phiB, a, beta, delta, gMax, U, Xb_f, Xc_f, Xb_r, Xc_r, \
        b_f, b_r, e, d
