import numpy as np
import globals as g
from numba import njit

@njit(cache=True)
def mVORTEX(x, y, z, X1, Y1, Z1, X2, Y2, Z2, GAMA, RCUT, LCUT):
    """
    Calculates the induced velocity [u, v, w] at a point [x, y, z]
    due to multiple line segements with the same side belonging to
    multiple vortex elements with strength GAMA per unit length
    pointing in the direction [X2, Y2, Z2] - [X1, Y1, Z1]

    Parameters
    ----------
    x, y, z: floats
        Observation point coordinates
    X1, Y1, Z1: ndarray     # TODO: Ask questions about this
        Vectors of size m, where m is the number of vortex elements.
        Endpoints 1 of the lines for all vortex element with the common side.
    X2, Y2, Z2: ndarray
        Vectors of size m, where m is the number of vortex elements.
        Endpoints 2 of the lines for all vortex element with the common side.
    GAMA: ndarray
        # TODO

    Returns
    -------
    u, v, w: floats
        Velocity components at the observation point [x, y, z] due to 
        all lines with common sides, belonging to all vortex elements
    """
    # Calculate R1 x R2
    x_diff1 = x - X1
    y_diff1 = y - Y1
    z_diff1 = z - Z1
    x_diff2 = x - X2
    y_diff2 = y - Y2
    z_diff2 = z - Z2

    R1R2X = y_diff1 * z_diff2 - z_diff1 * y_diff2
    R1R2Y = z_diff1 * x_diff2 - x_diff1 * z_diff2
    R1R2Z = x_diff1 * y_diff2 - y_diff1 * x_diff2
    
    # Calculate (R1 x R2) ** 2
    SQUARE = R1R2X * R1R2X + R1R2Y * R1R2Y + R1R2Z * R1R2Z
    
    # Calculate R0(R1/R(R1) - R2/R(R2))
    R1 = np.sqrt(x_diff1 * x_diff1 + y_diff1 * y_diff1 + z_diff1 * z_diff1)
    R2 = np.sqrt(x_diff2 * x_diff2 + y_diff2 * y_diff2 + z_diff2 * z_diff2)   
    ROR1 = (X2-X1) * x_diff1 + (Y2-Y1) * y_diff1 + (Z2-Z1) * z_diff1
    ROR2 = (X2-X1) * x_diff2 + (Y2-Y1) * y_diff2 + (Z2-Z1) * z_diff2

    zshape = np.shape(X1)
    COEF = np.zeros(zshape)
    U = np.zeros(zshape)
    V = np.zeros(zshape)
    W = np.zeros(zshape)

    # Find all line segments not located on the observation point
    i = (R1 > RCUT) * (R2 > RCUT) * (np.sqrt(SQUARE) > LCUT)

    # SQUARE = 0 when (X,Y,Z) lies in the middle of the line
    #    warning: = 0 also (X,Y,Z) lies on the extension of the line
    # R1 = 0 or R2 = 0 when [X,Y,Z] is at the end point.
    # When [X,Y,Z] lies on vortex element, its induced velocity is
    #   U = 0, V = 0, W = 0.
    # Contributions from the line segments on the observation points are excluded 
    # and assigned 0 values for each of the following vector outputs.
    # This way, their contributions are effectively set to zero.
    COEF[i] = GAMA[i] / (4.0 * np.pi * SQUARE[i]) * (ROR1[i] / R1[i] - ROR2[i] / R2[i])
    U = R1R2X * COEF
    V = R1R2Y * COEF
    W = R1R2Z * COEF

    # For each velocity component, sum contributions from all line segments 
    # into a single scalar
    u = U.sum()
    v = V.sum()
    w = W.sum()

    return u, v, w
