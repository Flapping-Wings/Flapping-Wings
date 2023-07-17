import numpy as np
import globals as g

def assemble_vel_B_by_T(nxb_f, VBTs_f, VBTs_12, VBTs_13, VBTs_14, VBTs_21, VBTs_23, VBTs_24,
                        nxb_r, VBTs_r, VBTs_31, VBTs_32, VBTs_34, VBTs_41, VBTs_42, VBTs_43
):
    """
    Get total velocity of the border elements on front wing w 
    and rear winng w due to total bound vortices on 4 wings

    Parameters
    ----------
    nxb_f: int
        Number of border elements on front wing
    nxb_r: int
        Number of border elements on rear wing
    VBTs_f: ndarray[j, n, i, w]
        Velocity on front wing w due to total elem on wing w
    VBTs_r: ndarray[j, n, i, w]
        Velocity on rear wing w due to total elem on wing w
    VBTs_ij: ndarrays[j, n, i]
        Velocity on target wing i due to total elem on source wing j
    
    Returns
    -------
    VBT_f: ndarray[i, n, j, w]
        Velocity on front wing w due to all four wing vound vortices
    VBT_r: ndarray[i, n, j, w]
        Velocity on rear wing w due to all four wing vound vortices
    """
    VBT_f = np.zeros((3, 4, nxb_f, g.nwing))
    VBT_r = np.zeros((3, 4, nxb_r, g.nwing))

    VBT_f[:,:,:,0] = VBTs_f [:,:,:,0] + VBTs_12[:,:,:]   + VBTs_13[:,:,:]   + VBTs_14[:,:,:]
    VBT_f[:,:,:,1] = VBTs_21[:,:,:]   + VBTs_f [:,:,:,1] + VBTs_23[:,:,:]   + VBTs_24[:,:,:]
    VBT_r[:,:,:,0] = VBTs_31[:,:,:]   + VBTs_32[:,:,:]   + VBTs_r [:,:,:,0] + VBTs_34[:,:,:]
    VBT_r[:,:,:,1] = VBTs_41[:,:,:]   + VBTs_42[:,:,:]   + VBTs_43[:,:,:]   + VBTs_r [:,:,:,1]

    return VBT_f, VBT_r
