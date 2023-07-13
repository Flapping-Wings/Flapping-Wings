import numpy as np
import matplotlib.pyplot as plt
from globals import g

def plot_WB(istep, nXb_f, nXw_f, Xb_f, Xw_f, nXb_r, nXw_r, Xb_r, Xw_r):
    """
    Plot  wake elements along with the original border elements
    
    Parameters
    ----------
    m: int
        0 (front wing), 1(rear) wing
    istep: int
        Iteration step
    nXb_f: int
        Number of border vortices (front)
    nXw_f: int
        Number of wake vortices (front)
    Xb_f: ndarray[j, inode, iXb, w]
        Coordinate j of node point for the border iXb (front)
    Xw_f: ndarray[j, inode, iXw, w]
        Coordinate j of node point for wake element iXb (front)
    nXb_r: int
        Number of border vortices (rear)
    nXw_r: int
        Number of wake vortices (rear)
    Xb_r: ndarray[j, inode, iXb, w]
        Coordinate j of node point for the border iXb (rear)
    Xw_r: ndarray[j, inode, iXw, w]
        Coordinate j of node point for wake element iXb (rear)
    """
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')

    plot_wing_set(ax, nXb_f, nXw_f, Xb_f, Xw_f)
    plot_wing_set(ax, nXb_r, nXw_r, Xb_r, Xw_r)

    ax.axis('equal')
    plt.savefig(f'{g.folder}wake/wake_{istep}.png')
    plt.close(fig)


def plot_wing_set(ax, nXb, nXw, Xb, Xw):
    # Original border elements
    for w in range(g.nwing):
        for i in range(nXb):
            x = [Xb[0,0,i,w], Xb[0,1,i,w], Xb[0,2,i,w], Xb[0,3,i,w], Xb[0,0,i,w]]
            y = [Xb[1,0,i,w], Xb[1,1,i,w], Xb[1,2,i,w], Xb[1,3,i,w], Xb[1,0,i,w]]
            z = [Xb[2,0,i,w], Xb[2,1,i,w], Xb[2,2,i,w], Xb[2,3,i,w], Xb[2,0,i,w]]

            ax.plot(x, y, z, 'r')
    
    # Wake elements
    for w in range(g.nwing):
        for i in range(nXw):
            x = [Xw[0,0,i,w], Xw[0,1,i,w], Xw[0,2,i,w], Xw[0,3,i,w], Xw[0,0,i,w]]
            y = [Xw[1,0,i,w], Xw[1,1,i,w], Xw[1,2,i,w], Xw[1,3,i,w], Xw[1,0,i,w]]
            z = [Xw[2,0,i,w], Xw[2,1,i,w], Xw[2,2,i,w], Xw[2,3,i,w], Xw[2,0,i,w]]

            if w == 0:
                ax.plot(x, y, z, 'k')
            else:
                ax.plot(x, y, z, 'b')
