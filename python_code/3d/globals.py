class g:
    # General configuration

    stime: bool = True
    """
    Time specification:
    - multiple times (False),
    - time marching (True)
    """
    solver: bool = False
    """
    Linear equation solver: 
    - forward elim/backward sub (False),
    - backslash (True)
    """


    # Output files

    folder: str = 'fig/'
    """Path to output folder"""
    fid = open(f"{folder}/output.txt", 'w')
    """Output file"""


    # Plotting

    iplot: bool = True
    """Toggle chord path plot"""
    mplot: bool = True
    """Toggle airfoil mesh plot"""
    vplot: bool = True
    """Toggle airfoil normal velocity plot"""
    wplot: bool = True
    """Toggle wake vortex plot"""
    idebg: bool = True
    """Toggle debug prints"""


    # Time

    dt: float = 0.1
    """Time increment"""
    nstep: int = None
    """Number of time steps to iterate through"""
    istep: int = 0
    """Current iteration step"""


    # Body geometry

    twing: int = 4
    """Total number of wings"""
    nwing: int = twing // 2
    """Number of wings in fore/rear"""
    delta_: float = 0.0
    """Body angle in degrees"""
    b_f: float = -1.5
    """Fore wing location in cm"""
    b_r: float = 1.5
    """Rear wing location in cm"""


    # Wing geometry

    # Front wing
    xb_f = None
    """Border element coordinates (front)"""
    nxb_f = None
    """Number of border elements (front)"""
    nb_f = None
    """Unit normal to the border elements (front)"""
    xc_f = None
    """Center element coordinates (front)"""
    nxc_f = None
    """Number of center elements (front)"""
    nc_f = None
    """Unit normal to the center elements (front)"""
    l_f = None
    """Wing span (front)"""
    c_f = None
    """Wing chord length (front)"""
    h_f = None
    """Border height (front)"""

    # Rear wing
    xb_r = None
    """Border element coordinates (rear)"""
    nxb_r = None
    """Number of border elements (rear)"""
    nb_r = None
    """Unit normal to the border elements (rear)"""
    xc_r = None
    """Center element coordinates (rear)"""
    nxc_r = None
    """Number of center elements (rear)"""
    nc_r = None
    """Unit normal to the center elements (rear)"""
    l_r = None
    """Wing span (rear)"""
    c_r = None
    """Wing chord length (rear)"""
    h_r = None
    """Border height (rear)"""


    # Wing motion

    phiT_: tuple[float] = (80.0, 80.0, 80.0, 80.0)
    """Top stroke angle in degrees"""
    phiB_: tuple[float] = (-45.0, -45.0, -45.0, -45.0)
    """Bottom stroke angle in degrees"""
    a_: tuple[float] = (0.0, 0.0, 0.0, 0.0)
    """Rotation axis offset in cm"""
    beta_: tuple[float] = (90.0, 90.0, 90.0, 90.0)
    """Stroke plane angle in degrees wrt the body axis"""
    f_: tuple[float] = (30.0, 30.0, 30.0, 30.0)
    """Flapping frequency in Hz"""
    gMax_: tuple[float] = (30.0, 30.0, 30.0, 30.0)
    """Max rotation amplitude in degrees; actual rotation is `2*gMax`"""
    p: tuple[float] = (5.0, 5.0, 5.0, 5.0)
    """Rotation speed parameter (nondimensional); `p >= 4`"""
    rtOff: tuple[float] = (0.0, 0.0, 0.0, 0.0)
    """
    Rotation timing offset (nondimensional):
    - `-0.5 < rtOff < 0.5`
    - `rtOff < 0` (advanced), 
    - `rtOff = 0` (symmetric),
    - `rtOff > 0` (delayed);
    """
    tau: tuple[float] = (0.0, 0.0, 0.0, 0.0)
    """
    Phase shift for the time (nondimensional):
    - `0 <= tau < 2`
    - `tau = 0` (start from top, start with down stroke)
    - `0 < tau < 1` (start in between, start with down stroke)
    - `tau = 1` (start from bottom, start wtih up stroke)
    - `1 < tau < 2` (start in between, start with up stroke)
    """
    mpath: tuple[int] = (0, 0, 0, 0)
    """
    Motion path parameter:
    - `0`: noTail Standard flapping(sinusoidal) & rotation (smoothed step func)
    - `1`: `td = 1` (DUTail), `nhp = 4` (2 periods)     
    - `2`: `td = 2` (UDTail), `nhp = 4` (2 periods) 
    - `3`: `td = 1` (DUDUTail), `nhp = 8` (4 periods) 
    - `4`: `td = 2` (UDUDTail), `nhp = 8` (4 periods) 
    - `5`: ctct(UDTailUTail), nhp = 4
    """


    # Fluid

    rho_: float = 0.001225
    """Air density"""
    U_: tuple[float] = (100.0, 0.0, 0.0)
    """
    Ambient velocity in (x, y, z); can be interpreted as the flight velocity
    when the wind is calm
    """


    # Cutoffs (error)
    
    RCUT: float = 1.0e-10
    """Distance between source and observation points to be judged as zero"""
    LCUT: float = None
    """
    Cutoff distance of the extension of a vortex line; velocity evaluation points
    within this distance from the vortex line and/or its extension is set to zero
    """

    # TODO: Finish below
    
    v_ = None
    t_ = None
    f_ = None
    d_ = None
    h_ = None
    rt = None

    limpa_f = None
    aimpa_f = None
    limpw_f = None
    aimpw_f = None
    limpa_r = None
    aimpa_r = None
    limpw_r = None
    aimpw_r = None

    ielong = None
    hfactor = None
    wfactor = None
    itaper = None
    c_ = None
    l_ = None
    icamber = None
    acamber = None
