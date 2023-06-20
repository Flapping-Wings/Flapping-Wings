import numpy as np
from globals import g

def VORTEXm(X, Y, Z, x1, y1, z1, x2, y2, z2, GAMA):
    """
    Calculate the induced velocity [U, V, W] at multiple points
    [X, Y, Z] due to one line segment with strength GAMA per unit
    length pointing in the direction [x2, y2, z2] - [x1, y1, z1]

    Parameters
    ----------
    X, Y, Z: ndarrays
        Coordinates of observation points
    x1, y1, z1: floats
        Endpoint 1 of the line
    x2, y2, z2: floats
        Endpoint 2 of the line
    GAMA: float
        TODO
    
    Returns
    -------
    U, V, W: ndarrays
        Velocity components at the observation points [X, Y, Z]
        due to one line
    """
    # Calculate R1 x R2
    R1R2X = (Y - y1) * (Z - z2) - (Z - z1) * (Y - y2)
    R1R2Y = (Z - z1) * (X - x2) - (X - x1) * (Z - z2)
    R1R2Z = (X - x1) * (Y - y2) - (Y - y1) * (X - x2)

    # Calculate (R1 x R2) ** 2
    SQUARE = R1R2X * R1R2X + R1R2Y * R1R2Y + R1R2Z * R1R2Z

    # Calculate R0(R1/R(R1) - R2/R(R2))
    # TODO: Optimize out repeated calculations
    R1 = np.sqrt((X-x1) * (X-x1) + (Y-y1) * (Y-y1) + (Z-z1) * (Z-z1))
    R2 = np.sqrt((X-x2) * (X-x2) + (Y-y2) * (Y-y2) + (Z-z2) * (Z-z2))    
    ROR1 = (x2-x1) * (X-x1) + (y2-y1) * (Y-y1) + (z2-z1) * (Z-z1)
    ROR2 = (x2-x1) * (X-x2) + (y2-y1) * (Y-y2) + (z2-z1) * (Z-z2)

    zshape = np.shape(X)
    COEF = np.zeros(zshape)
    U = np.zeros(zshape)
    V = np.zeros(zshape)
    W = np.zeros(zshape)

    # Find all observation points not located on the line or its extension
    i = (R1 > g.RCUT) * (R2 > g.RCUT) * (SQUARE > g.RCUT)

    # SQUARE = 0 when [X,Y,Z] lies in the middle of the line.
    #    warning: =0 also [X,Y,Z] lies on the extension of the line.
    # R1 = 0 or R2 = 0 when [X,Y,Z] is at the end point.
    # When [X,Y,Z] lies on vortex element, its induced velocity is
    #   U = 0, V = 0, W = 0.
    # Contributions from the line segments on the observation points are excluded 
    # and assigned 0 values for each of the following vector outputs.
    # This way, their contributions are effectively set to zero.
    COEF[i] = GAMA / (4.0 * np.pi * SQUARE[i]) * (ROR1[i] / R1[i] - ROR2[i] / R2[i])
    U[i] = R1R2X[i] * COEF[i]
    V[i] = R1R2Y[i] * COEF[i]
    W[i] = R1R2Z[i] * COEF[i]

    return U, V, W


if __name__ == "__main__":
    # TEST 1
    GAMA = 1
    x1, y1, z1 = 0, 0, 0
    x2 = -0.070400396170853
    y2 = 0.121937063040895
    z2 = 0

    X = np.array([
        -0.0298819853229070,
        -0.0851504735837784,
        -0.110536976521743,
        -0.110536976521743,
        -0.0552684882608715,
         0.0552684882608715,
         0.110536976521743,
         0.110536976521743,
         0.0851504735837784,
         0.0298819853229070,
         1.704454116762352e-18,
        -0.0368456588405810,
         0.0368456588405810,
        -0.0491275451207746,
         0.0491275451207746,
        -0.0491275451207746,
         0.0491275451207746,
    ])
    Y = np.array([
        0.0763208893706897,
        0.172048719096043,
        0.271287920271966,
        0.386320379178651,
        0.446084349824465,
        0.446084349824465,
        0.386320379178651,
        0.271287920271966,
        0.172048719096043,
        0.0763208893706896,
        0.112946098271010,
        0.176764651421246,
        0.176764651421246,
        0.272933381027120,
        0.272933381027120,
        0.380179436038554,
        0.380179436038554,
    ])
    Z = np.zeros(17)

    VORTEXm(X, Y, Z, x1, y1, z1, x2, y2, z2, GAMA)

    # TEST 2
    GAMA = 1
    x1 = -0.049127545120775
    x2 = -0.070400396170853
    y1 = 0.134218949321089
    y2 = 0.121937063040895
    z1 = 0
    z2 = 0

    VORTEXm(X, Y, Z, x1, y1, z1, x2, y2, z2, GAMA)
