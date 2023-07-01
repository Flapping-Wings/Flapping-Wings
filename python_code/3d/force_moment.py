import numpy as np
import matplotlib.pyplot as plt
from scipy.interpolate import splev, splrep, splder
from globals import g

def force_moment(rho_, v_, d_1, nstep, dt, U):
    # Reference values of force and moment
    f_ = rho_ * (v_ * d_1)**2
    m_ = f_ * d_1

    # Translational velocity of the moving inertia system
    U0 = -U

    # Combine impulses
    # Front wings
    limps_f = g.limpa_f + g.limpw_f
    aimps_f = g.aimpa_f + g.aimpw_f
    # Rear wings
    limps_r = g.limpa_r + g.limpw_r
    aimps_r = g.aimpa_r + g.aimpw_r

    # Add contributions from nwing/2 wings
    # Front wings
    limp_f = limps_f[:, :, 0] + limps_f[:, :, 1]
    aimp_f = aimps_f[:, :, 0] + aimps_f[:, :, 1]
    # Rear wings
    limp_r = limps_r[:, :, 0] + limps_r[:, :, 1]
    aimp_r = aimps_r[:, :, 0] + aimps_r[:, :, 1]

    # Add contributions from front and rear wings
    limp = limp_f + limp_r
    aimp = aimp_f + aimp_r

    # Get the splines and their derivatives for the impulses
    for i in range(g.nwing):
        time = dt * np.arange(1, nstep + 1)
        impLx = splrep(time, limp[0, :])
        impLy = splrep(time, limp[1, :])
        impLz = splrep(time, limp[2, :])
        dimpLx = splder(impLx, 1)
        dimpLy = splder(impLy, 1)
        dimpLz = splder(impLz, 1)

        impAx = splrep(time, aimp[0, :])
        impAy = splrep(time, aimp[1, :])
        impAz = splrep(time, aimp[2, :])
        dimpAx = splder(impAx, 1)
        dimpAy = splder(impAy, 1)
        dimpAz = splder(impAz, 1)

    # Evaluate force and moments at sample times
    times = np.arange(0, dt * (nstep + 1), dt)  # include time=0

    forcex = splev(times, dimpLx)
    forcey = splev(times, dimpLy)
    forcez = splev(times, dimpLz)
    limpx = splev(times, impLx)
    limpy = splev(times, impLy)
    limpz = splev(times, impLz)
    momx = splev(times, dimpAx)
    momy = splev(times, dimpAy)
    momz = splev(times, dimpAz)

    momentx = momx + U0[1] * limpz - U0[2] * limpy
    momenty = momy + U0[2] * limpx - U0[0] * limpz
    momentz = momz + U0[0] * limpy - U0[1] * limpx

    # Reverse the sign to get forces/moments acting on the wing
    forcex = -f_ * forcex
    forcey = -f_ * forcey
    forcez = -f_ * forcez

    momentx = -m_ * momentx
    momenty = -m_ * momenty
    momentz = -m_ * momentz

    # Plot forces and moments
    fm = plt.figure()
    plt.plot(times, forcex, 'x-k')
    plt.grid(True)
    plt.savefig(g.folder + 'f&m/fx.png')
    plt.close(fm)

    fm = plt.figure()
    plt.plot(times, forcey, '+-k')
    plt.grid(True)
    plt.savefig(g.folder + 'f&m/fy.png')
    plt.close(fm)

    fm = plt.figure()
    plt.plot(times, forcez, 'x-k')
    plt.grid(True)
    plt.savefig(g.folder + 'f&m/fz.png')
    plt.close(fm)

    fm = plt.figure()
    plt.plot(times, momentx, 'o-r')
    plt.grid(True)
    plt.savefig(g.folder + 'f&m/m1.png')
    plt.close(fm)

    fm = plt.figure()
    plt.plot(times, momenty, 'o-r')
    plt.grid(True)
    plt.savefig(g.folder + 'f&m/m2.png')
    plt.close(fm)

    fm = plt.figure()
    plt.plot(times, momentz, 'o-r')
    plt.grid(True)
    plt.savefig(g.folder + 'f&m/m3.png')
    plt.close(fm)
