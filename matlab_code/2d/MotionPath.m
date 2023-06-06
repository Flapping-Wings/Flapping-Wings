function [  ] = MotionPath( )
%Motion path of the leading, trailing and center points of the Thin 2D airfoil 
%Motion path consists of the flapping and rotation, which is specified 
%   based on the insect morphology and flight data.

%==========================================================================
%GLOBAL VARIABLES
global tau fid  folder iplot


%==========================================================================

%DEBUGGING PARAMETERS======================================================
%How to specify the file path:
    folder = 'fig/';
%Chord path plot: iplot  0(no plot), 1(chord path plot), 2(edge points polt)
    iplot = 2;
%END DEBUGGING PARAMETERS==================================================

%Open an Output File:    
fid=fopen([folder 'output.txt'],'w');
        
%INPUT VARIABLES===========================================================
%==========WING GEOMETRY
% l_ = wing span (cm)
    l_      = 3;
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
    
%==========WING MOTION PARAMETERS
% stroke angles (degrees)
    phiT_   = 45;
    phiB_   = -45;
% a_ rotation axis offset (cm)
    a_      = 0.5;
% beta = stroke plane angle (degrees)
    beta_   = 30;
% f_ = flapping frequency (1/sec)
    f_      = 100;
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
    rtOff   = -0.25;
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

    
%==========FLUID PARAMETERS
%ambient velocity (cm/sec, assume constant)
%Can be interpreted as the flight velocity when the wind is calm
    U_= 0.0; %Set U_=V_=0 for hovering
    V_= 0.0; 
%Time increment and # of time steps
    dt = 0.1;   %no need to change
    nstep = 21; %Set 21 for hovering, 41 for U_ nonzero
%==========================================================================

%PRINT INPUT DATA==========================================================

fprintf(fid, 'l_   = %6.3f, phiT_= %6.3f, phiB  = %6.3f, a   = %6.3f, beta_ = %6.3f, f_ = %6.3f\n', ...
            l_,phiT_,phiB_,a_,beta_,f_);
    fprintf(fid, 'gMax_= %6.3f, p    = %6.3f, rtOff = %6.3f, tau = %6.3f\n',...
            gMax_,p,rtOff,tau);
    fprintf(fid, 'U_   = %6.3f, V_   = %6.3f\n', ...
            U_,V_);
    fprintf(fid,'nstep = %4d dt = %6.3f\n',nstep,dt);
%==========================================================================

%Nondimentionalize the input variables
    [v_,t_, d_,e,c,x,y,a,beta,gMax, U, V ] = iginData(l_,phiT_,phiB_,c_,x_,y_,a_, ...
                                           beta_,f_,gMax_,U_,V_);
%Comparison of flapping, pitching and air speeds                                       
    air=sqrt(U_^2+V_^2);
    fprintf(fid, 'air speed = %6.3e\n',air);
    if air > 1.0E-03
        %Flapping/Air Speed Ratio
        fk=2*f_*d_/air;
        fprintf(fid, 'flapping/air: speed ratio = %6.3e\n', fk);
        %Pitch/Flapping Speed Ratio
        r=0.25*(c_/d_)*(p/t_)*(gMax/f_);
        fprintf(fid, 'pitch/flapping: speed ratio = %6.3e\n', r);
        %Pitch/Air Speed Ratio
        k=fk*r;
        fprintf(fid, 'pitch/air: speed ratio = %6.3e\n', k);
    else
        %Pitch/Flapping Speed Ratio
        r=0.25*(c_/d_)*(p/t_)*(gMax/f_);
        fprintf(fid, 'pitch/flapping: speed ratio = %6.3e\n', r);        
    end

%multiple times (FOR PLOTTING THE CHORD PATH)
    tmax=dt*nstep;
    t=linspace(0,tmax,100*ceil(tmax/2));
    %Motion path selection: mPath =0 (sinusoidal), =1 (sinusoidal+constant tail)
    %For plotting the chord path (stime=1). Not used in the main time marching
    mPath=0;
    %Plot Chord Path (and time history of flapping & rotation)
    switch mPath
        case 0
            chordPath_d(t,e,c,a,beta,gMax,p,rtOff, U, V);
        case 1
            chordPathTail(t,e,c,a,beta,gMax,p,rtOff, U, V);
        otherwise
    end        

%close opened files
    fclose('all');
end

