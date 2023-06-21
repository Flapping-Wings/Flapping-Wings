import numpy as np
from globals import g

def tombo():
    pass


def check_input():
    if g.b_r - g.b_f >= 0.5 * (g.c_r + g.c_f):
        print("Wing clearance checked")
    else:
        raise ValueError("rear and forward wings interfere")
    
    if np.any(g.p < 4):
        raise ValueError("p must >=4 for all wings")
    
    if np.any(np.abs(g.rtOff) > 0.5):
        raise ValueError("-0.5 <= rtOff <= 0.5 must be satisfied for all wings")
    
    if np.any((g.tau < 0) | (g.tau >= 2)):
        raise ValueError("0 <= tau < 2 must be satisfied for all wings")


if __name__ == "__main__":
    check_input()
    tombo()