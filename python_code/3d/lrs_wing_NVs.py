import numpy as np
from matplotlib import pyplot as plt
import globals as g

def lrs_wing_NVs(m, iwing, xC, XC, NC, t, theta, phi, dph, dth, a, beta, U, iteration):
    """
    Get the normal velocity at the wing collocation points XC[j, i]
    in the global system.

    Parameters
    ----------
    m: int
        0 (front wing), 1 (rear wing)
    iwing: int
        0 (right wing), 1 (left wing)
    xC: ndarray[j, i]
        Collocation points (wing-fixed)
    XC: ndarray[j, i]
        Collocation points (global)
    NC[j, i]
        Unit normals at collocation points (global)
    t: float
        Time
    theta: float
        Wing pitch angle
    phi: float
        Wing rolling angle
    dph: float
        Rate of change of rolling angle
    dth: float
        Rate of change of pitch angle
    a: float
        Rotation axis offset
    beta: float
        Stroke plane angle wrt the body axis
    U: ndarray
        Ambient velocity

    Returns
    -------
    Vnc: ndarray[1, nXC]
        Normal velocity (global)
    """
    # Airfoil velocity components in global system
    sbt = np.sin(beta)
    cbt = np.cos(beta)
    sth = np.sin(theta)
    cth = np.cos(theta)
    sph = np.sin(phi)
    cph = np.cos(phi)  
        
    ab = -sth * (xC[0, :] + a) + cth * xC[2, :]
    xb =  cth * (xC[0, :] + a) + sth * xC[2, :]
    vxb = dth * ab
    vyb =  sph * dth * xb - cph * dph * ab - sph * dph * xC[1, :]
    vzb = -cph * dth * xb - sph * dph * ab + cph * dph * xC[1, :]
    
    if iwing == 1:      # Flip left wing coordinates
        vyb = -vyb
    
    vx = -U[0] + sbt * vxb + cbt * vzb
    vy = -U[1] + vyb
    vz = -U[2] - cbt * vxb + sbt * vzb

    # Normal velocity components of the airfoil
    Vnc = vx * NC[0, :] + vy * NC[1, :] + vz * NC[2, :]

    if g.vplot:
        iteration["vel"] = {
            "XC": np.copy(XC),
            "Vnc": np.copy(Vnc),
            "NC": np.copy(NC),
            "m": m,
            "iwing": iwing,
            "t": t
        }
        # plot_normal_vel(XC, Vnc, NC, m, iwing, t)

    return Vnc


# TODO
def plot_normal_vel(XC, Vnc, NC, m, iwing, t):
    # End points for the normal velocity vector
    sf = 0.1    # Scale factor for the velocity plot
    xaif = XC[0,:]
    yaif = XC[1,:]
    zaif = XC[2,:]
    
    xtip = xaif + sf * Vnc * NC[0,:]
    ytip = yaif + sf * Vnc * NC[1,:]
    ztip = zaif + sf * Vnc * NC[2,:]
    
    # Plot normal velocity vectors at collocation points     
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')

    for i in range(len(xtip)):
      ax.plot([xaif[i],xtip[i]], [yaif[i],ytip[i]], [zaif[i],ztip[i]])

    ax.scatter(XC[0,:], XC[1,:], XC[2,:], marker='o')

    ax.set_title('Normal velocity vectors at collocation points')
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
    ax.set_box_aspect([1, 1, 1])
    ax.axis('equal')

    if m == 0:
        if iwing == 0:
            plt.savefig(g.folder + 'debug/Vairfoil_fr_' + f'{t:.4f}' + '.png')
        else:
            plt.savefig(g.folder + 'debug/Vairfoil_fl_' + f'{t:.4f}' + '.png')
    else:
        if iwing == 0:
            plt.savefig(g.folder + 'debug/Vairfoil_rr_' + f'{t:.4f}' + '.png')
        else:
            plt.savefig(g.folder + 'debug/Vairfoil_rl_' + f'{t:.4f}' + '.png')

    plt.close(fig)
