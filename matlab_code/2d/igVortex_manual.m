function [  ] = igVortex_manual( )
%Thin 2D airfoil by the discrete vortex method
%Motion path consists of the flapping and rotation, which is specified 
%   based on the insect morphology and flight data.
%While dVortex uses the wing fixed coordinate system
%      gVortex used the global coordinate system
%Version 1 gVortex: Global version of dVortex (not completed)
%Version 2 igVortex  (October  8, 2014 by Mitch Denda)
%                    (October 15, 2014, checked the code and thory)
%Impuse calculation, wake vortex plot are performed after 1. vortex
%   convection and 2. wing increment motion
% (previously, they were obtained right after 1. vortex convection and
% before 2. wing incremental motion. This provides a time lag between the
% positions of the vortices and the wing.)
%SAMPLE STARTUP PROCEDURE
% istep=1:
%   Calculate the bound vortices. There are no wake vortices
%   Calculate impulses and plot wake vortices (here is none)
%   Calculate convecting velocities
%   Convect free vortices (bound edge and tail vortices) to generate wake vortices.
%   Move the wing to a new porition for istep=2.
% istep=2:
%   Calculate the bound vortices using the 2 wake vortices from istep=1
%   Calculate the impulses and plot wake vortices (there are two)
%   Calcuate the convectiong velocities
%   Convect free vortices (bound edge and tail and wake vortices)
%   Move the wing to a new position for istep=3
% istep=3:
%   ......

%DEBUGGING PARAMETERS======================================================
%How to specify the file path:
    folder = 'fig/';
%Airfoil Mesh plot: mplot mesh plot 0 (no), 1(yes), 2(Compare equal arc and equal abscissa mesh points)
    mplot = 0;
%Airfoil normal velocity plot: vplot 0(no), 1(yes)
    vplot = 0;
%Wake Vortex plot: 0(n0), 1(yes)
    wplot = 1;
%END DEBUGGING PARAMETERS==================================================

%Open an Output File:    
fid=fopen([folder 'output.txt'],'w');
        
%INPUT VARIABLES===========================================================
%==========WING GEOMETRY
% l_ = wing span (cm)
    l_      = 4;
% c_ = chord length (cm)
%    calculated whie specifying the airfoil shape
%# of data points that define the airfoil shape
    n=101;
%Read airfoil shape data and determine the chord length
    %Here, use a formula to spefify the airfoil shape
    atmp_=0.5;
    x_=linspace(-atmp_,atmp_,n);
    %Camber options are not ellaborated yet
        camber=+0.0; %zero sets a straight airfoil    
        y_=camber*(atmp_^2-x_.^2);
        %OR give arrays x_ and y_ from NASA airfoil data base
    c_=x_(n)-x_(1);
    fprintf(fid,'c_ = %6.3f camber = %6.3f\n',c_,camber);
%# of vortex points on the airfoil
    m=21;
    
%==========WING MOTION PARAMETERS
% stroke angles (degrees)
    phiT_   = 80;
    phiB_   = -45;
% a_ rotation axis offset (cm)
    a_      = 0;
% beta = stroke plane angle (degrees)
    beta_   = 50;
% f_ = flapping frequency (1/sec)
    f_      = 30;
% gMax = max rotation (degrees)
    gMax_   = 60;
% p = rotation speed parameter (nondimentional)
%   p>=4
    p       = 5;
    if p<4
        disp('p must be bigger than 4')
    end
% rtOff = rotation timing offset (nondimentional)
%   rtOff<0(advanced), rtOff=0 (symmetric), rtOff>0(delayed)
%   -0.5<rtOff<0.5
    rtOff   = 0.0;
    if abs(rtOff)>0.5
        disp('-0.5<=rtOff<=0.5 is not satisfied')
    end
% tau = phase shift for the time 
%   0(start from TOP), 0<tau<1(in between, start with DOWN STROKE),
%   1(BOTTOM), 1<tau<2(in between, start with UP STROKE), 2(TOP): 
%   0 <= tau < 2
    tau     = 0.0;
    if  tau < 0 || tau >2
        disp('0<= tau < 2 is not satisfied')
    end
%Motion path parameter: mpath 0(no tail), 1 (DUTail; 2eriods), 2(UDTail; 2 periods),
%3(DUDUTail; 4 periods), 4(UDUDTail; 4 periods)
    mpath = 0;
    fprintf(fid,'mpath = %3d\n',mpath);
    
%==========FLUID PARAMETERS
%Air density
    rho_=0.001225; %g/cm^3
%ambient velocity (cm/sec, assume constant)
%Can be interpreted as the flight velocity when the wind is calm
    U_= 40;
    V_= 0.0;
%Time increment and # of time steps
    dt = 0.1;
    nstep = 40;
%Distance between the source and the observation point to be judged as zero
    eps=1.0E-03;   

%==========================================================================
end

