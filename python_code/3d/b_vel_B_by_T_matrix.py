import numpy as np

from globals import g
from VORTEXm import VORTEXm


def b_vel_B_by_T_matrix(nXb, nXt, Xb, Xt):
    """
    Velocity coefficients at border element nodes (no offset) due to bound vertices

    @param nXb: # of border elements.
    @param nXt: # of all elements on the wing.
    @param Xb: [j, n, i, nwing] Border element coordinates j for node n of element i.
    @param Xt: [j, n, i, nwing] Coordinates of the nodes for total elements on the wing.

    @return: cVBT[j (1 - 3 (x, y, z)), n (4 nodes for each shed element), ibelm, itelm]
    """

    cVBT = np.zeros((3, 4, nXb, nXt, g.nwing))
    r = (1, 4, nXb)

    for w in range(g.nwing):
        for i in range(nXt):
            U = np.zeros(r)
            V = np.zeros(r)
            W = np.zeros(r)

            dU, dV, dW = VORTEXm(Xb[0, :, :, w], Xb[1, :, :, w], Xb[2, :, :, w], Xt[0, 0, i, w],
                                 Xt[1, 0, i, w], Xt[2, 0, i, w], Xt[0, 1, i, w], Xt[1, 1, i, w], Xt[2, 1, i, w])
            U += dU
            V += dV
            W += dW

            dU, dV, dW = VORTEXm(Xb[0, :, :, w], Xb[1, :, :, w], Xb[2, :, :, w], Xt[0, 1, i, w],
                                 Xt[1, 1, i, w], Xt[2, 1, i, w], Xt[0, 2, i, w], Xt[1, 2, i, w], Xt[2, 2, i, w])
            U += dU
            V += dV
            W += dW

            dU, dV, dW = VORTEXm(Xb[0, :, :, w], Xb[1, :, :, w], Xb[2, :, :, w], Xt[0, 2, i, w],
                                 Xt[1, 2, i, w], Xt[2, 2, i, w], Xt[0, 3, i, w], Xt[1, 3, i, w], Xt[2, 3, i, w])
            U += dU
            V += dV
            W += dW

            dU, dV, dW = VORTEXm(Xb[0, :, :, w], Xb[1, :, :, w], Xb[2, :, :, w], Xt[0, 3, i, w],
                                 Xt[1, 3, i, w], Xt[2, 3, i, w], Xt[0, 0, i, w], Xt[1, 0, i, w], Xt[2, 0, i, w])
            U += dU
            V += dV
            W += dW

            cVBT[0, :, :, i, w] = U
            cVBT[1, :, :, i, w] = V
            cVBT[2, :, :, i, w] = W

    return cVBT


if __name__ == "__main__":
    nXb = 1
    nXt = 1
    Xb = None
    Xt = None
