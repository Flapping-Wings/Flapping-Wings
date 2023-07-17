import matplotlib.pyplot as plt
import numpy as np
import globals as g

def plot_GAM(m, iwing, t, GAMA, XC, NC):
    # Plot GAMA at the collocation points of elements using the normal direction
    # INPUT:
    # m: 1 (front), 2 (rear) wing
    # iwing: 1 (right wing), 2 (left)
    # GAMA: GAMA(i)
    # XC: coordinate j of the collocation point
    # NC: unit normal component j at the collocation

    # End points for the vector
    sf = 1.0  # Scale factor for the velocity plot
    xaif = XC[0]
    yaif = XC[1]
    zaif = XC[2]
    xtip = xaif + sf * np.multiply(GAMA , NC[0])
    ytip = yaif + sf * np.multiply(GAMA , NC[1])
    ztip = zaif + sf * np.multiply(GAMA , NC[2])

    # Plot GAMA along the normal velocity vectors at collocation points
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    ax.scatter(xaif, yaif, zaif, marker='o')
    
    for i in range(len(xtip)):
      ax.plot([xaif[i],xtip[i]] , [yaif[i],ytip[i]], [zaif[i],ztip[i]])
    

    ax.set_title('GAMA at collocation points')
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
    ax.set_box_aspect([1, 1, 1])
    ax.axis('equal')

    if m == 0:
        if iwing == 0:
            plt.savefig(g.folder + 'debug/GAMA_fr_' + f'{t:.4f}' + '.png')
        else:
            plt.savefig(g.folder + 'debug/GAMA_fl_' + f'{t:.4f}' + '.png')
    else:
        if iwing == 0:
            plt.savefig(g.folder + 'debug/GAMA_rr_' + f'{t:.4f}' + '.png')
        else:
            plt.savefig(g.folder + 'debug/GAMA_rl_' + f'{t:.4f}' + '.png')

    plt.close(fig)
