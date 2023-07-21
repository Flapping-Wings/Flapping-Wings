from lrs_wing_NVs import plot_normal_vel
from plot_GAM import plot_GAM
from plot_WB import plot_WB
import globals as g
from multiprocessing.pool import Pool
import os
import numpy as np
import matplotlib.pyplot as plt
plt.ioff()


def plot_iteration(iteration):
    if g.gplot:
        gamf = iteration["GAM_front"]
        plot_GAM(0, *gamf.values())

        gamr = iteration["GAM_rear"]
        plot_GAM(1, *gamr.values())

    if g.wplot:
        wf = iteration["wake"]
        plot_WB(*wf.values())

    if g.vplot:
        vel = iteration["vel"]
        plot_normal_vel(*vel.values())


def plot_graphs():

    if len(g.iterations) > 10:
        pool = Pool(processes=os.cpu_count())

        for _ in pool.imap_unordered(plot_iteration, g.iterations):
            pass
    else:
        for iteration in g.iterations:
            plot_iteration(iteration)
