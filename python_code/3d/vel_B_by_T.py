import numpy as np

import globals as g


def vel_B_by_T(cVBT, GAM, nXt):
    s = np.shape(cVBT)
    r = (s[0], s[1], s[2], g.nwing)
    VBT = np.zeros(r)
    dVBT = np.zeros(r)

    for w in range(g.nwing):
        for itelem in range(nXt):
            dVBT[:, :, :, w] = cVBT[:, :, :, itelem, w] * GAM[w, itelem]
            VBT[:, :, :, w] = VBT[:, :, :, w] + dVBT[:, :, :, w]

    return VBT


if __name__ == "__main__":
    from scipy.io import loadmat

    data = loadmat("data.mat")

    cVBT = data['cVBT']
    GAM = data['GAM']
    nXt = data['nXt']
    nXt = int(nXt)

    VBT_og = data['VBT']
    VBT = vel_B_by_T(cVBT, GAM, nXt)

    print(np.alltrue(np.isclose(VBT_og, VBT)))
