function [  ] = igVortex( )
%rotation, which is specified 
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
%Version 3 (Feb. 17, 2015) Introduced the modified Biot-Savart equation
%Version 4 (Feb. 19, 2015) Time increment ans # of steps specification
%options are introduced: itinc=0 (manual), 1(automatic based on c,m and p)
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
%==========================================================================
%GLOBAL VARIABLES
global tau mplot vplot fid eps folder wplot zavoid mpath delta ibios
global impulseLb impulseAb impulseLw impulseAw LDOT HDOT ZETA
global svCont wvCont  ivCont vpFreq
%==========================================================================

%DEBUGGING PARAMETERS======================================================
%How to specify the file path:
    folder = 'fig/';
%Airfoil Mesh plot: mplot mesh plot 0 (no), 1(yes), 2(Compare equal arc and equal abscissa mesh points)
    mplot = 0;
%Airfoil normal velocity plot: vplot 0(no), 1(yes)
    vplot = 0;
%Wake Vortex plot: 0(n0), 1(yes)
    wplot = 1;
%Velocity plot by avoiding source and observation points coincidence:
%zaoid: 0 (no, faster), 1(yes, slower)
    zavoid = 0; 
%Velocity field plot: 0 (no), 1 (yes)
    vfplot=1;
%END DEBUGGING PARAMETERS==================================================

%Open an Output File:    
fid=fopen([folder 'output.txt'],'w');
        
%INPUT VARIABLES===========================================================
%==========WING GEOMETRY
% l_ = wing span (cm)
    l0_      = 5.0;
% Reduce the wing span by half to be used for 2D modeling
    l_=0.5*l0_;
% c_ = chord length (cm)
%    calculated whie specifying the airfoil shape
%# of data points that define the airfoil shape
    n=101;
%Read airfoil shape data and determine the chord length
    %Here, use a formula to spefify the airfoil shape
    atmp_=0.8;
    x_=linspace(-atmp_,atmp_,n);
    %Camber options are not ellaborated yet
        camber=0.0; %zero sets a straight airfoil    
        y_=camber*(atmp_^2-x_.^2);
        %OR give arrays x_ and y_ from NASA airfoil data base
    c_=x_(n)-x_(1);
    fprintf(fid,'c_ = %6.3f camber = %6.3f\n',c_,camber);
%# of vortex points on the airfoil
    m=5;
    
%==========WING MOTION PARAMETERS
% stroke angles (degrees)
    phiT_   = 45;
    phiB_   = -45;
% a_ rotation axis offset (cm)
    a_      = 0;
% beta = stroke plane angle (degrees)
    beta_   =-30;
% f_ = flapping frequency (1/sec)
    f_      = 30;
% gMax = max rotation (degrees)
    gMax_   = 30;
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
    U_= 100.0;
    V_= 0.0;
%Time increment and # of time steps option 0(manually specify),%1(automatic)
    itinc=1; %Specify nperiod (# of periods) below
%Distance between the source and the observation point to be judged as zero
    eps=0.5E-06;  
%Vortex core model (Modified Biot-Savart equation): 0(no), 1(yes)
    ibios=1;
    fprintf(fid, 'ibios = %3d\n',ibios);

%Velocity contour plots in space-fixed system
%Used as the 4th argument of contourf to control the range of velocity
    %space-fixed velocity plot: svInc (increment), svMax (max velocity)
    svInc=0.025;
    svMax=2.50;
    svCont=0.0:svInc:svMax;
    %wing-fixed  velocity plot: wvInc (increment), wvMax (max velocity)
    wvInc=0.1;
    wvMax=7.0;
    wvCont=0:wvInc:wvMax;
%Use of svCont and wvCont: ivCont = 0 (no), 1 (yes)
%The velocity range varies widely depending on the input parakmeters
%It is recommended to respecify this when input parameters are chamged
    ivCont = 0;
%Frequency of velocity plots: vpFreq
    vpFreq=1;
%==========================================================================

%PRINT INPUT DATA==========================================================

fprintf(fid, 'l_   = %6.3f, phiT_= %6.3f, phiB  = %6.3f, a   = %6.3f, beta_ = %6.3f, f_ = %6.3f\n', ...
            l_,phiT_,phiB_,a_,beta_,f_);
    fprintf(fid, 'gMax_= %6.3f, p    = %6.3f, rtOff = %6.3f, tau = %6.3f\n',...
            gMax_,p,rtOff,tau);
    fprintf(fid, 'U_   = %6.3f, V_   = %6.3f, m     = %4d, n = %4d\n', ...
            U_,V_,m,n);
    
%==========================================================================

%Nondimentionalize the input variables
    [v_,t_, d_,e,c,x,y,a,beta,gMax, U, V ] = iginData(l_,phiT_,phiB_,c_,x_,y_,a_, ...
                                           beta_,f_,gMax_,U_,V_);
%Threshold radius for modified Biot-Savart equation
    delta=0.5*c/(m-1);  %distance between the collocation point and the vortex point on the wing
    q=1.0;   %multiplier 0 < q <= 1
    delta=q*delta;
    fprintf(fid,'q = %6.3f, delta = %6.3f\n',q, delta);
%Time increment
switch itinc
    case 0 %Manual selection
        dt = 0.025;
        nstep = 81;
    case 1 %Automatic
        nperiod=1;
        dt= min(c/(m-1), 0.1*(4/p)); %4/p = duration of pitch
        nstep=nperiod*ceil(2/dt);  % One period=2(nondimensional)
end
fprintf(fid,'nstep = %4d dt = %6.3f\n',nstep,dt);        
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
%Generate the vortex and collocation points on the airfoil  
    [xv, yv, xc, yc, dfc,m] = igmeshR(c,x,y,n,m); %m is increased by 4 due to refinement
 
%time marching 
    %Initialize the wake vortex magnitude array
    % GAMAw(1:2) step 1, GAMAw(3:4) step 2, GAMAw(5:6) step 3, ...
    % Leading edge: odd components, Trailing edge: even components
    GAMAw=zeros(1,2*nstep);
    %Initialize the free vortex magnitude array
    %This is the vortex to be shed or convected
    %GAMAf=zeros(1,2*nstep);
    %Initialize the total wake vortex sum
    sGAMAw = 0.0;
    %Initialize the total wake vortex number
    iGAMAw = 0;
    %Initializing the # of vortices to be convected or shed
    iGAMAf = 0;
    %Initialize the free+wake vortex location array (before convection)
    % ZF(1:2) step 1, ZF(3:4) step 2, ZF(5:6) step 3, ...
    % Leading edge: odd components, Trailing edge: even components
    tmp = zeros(1,2*nstep);
    ZF = complex(tmp,tmp);
    %Initialize the wake vortex location array (after convection)
    % ZW(1:2) step 1, ZW(3:4) step 2, ZW(5:6) step 3, ...
    % Leading edge: odd components, Trailing edge: even components
    ZW = complex(tmp,tmp);
    %This is further transformed into a new body-fixed coordinate system
    
    %Initialize the linear and angular impuse array
    tmp=zeros(1,nstep);
    impulseLb=complex(tmp,tmp);
    impulseAb=tmp;
    impulseLw=complex(tmp,tmp);
    impulseAw=tmp;
    %Initialize the translational velocity
    LDOT=zeros(1,nstep);
    HDOT=zeros(1,nstep);
        
    %Vortex convection Time history sample
    %
    %step 1: iGAMAw_1=0, iGAMAf_1=2

     %GAMAw_1 = [0         , 0          ]; no wake vortex
     %GAMAf_1 = [GAMA_1(1) , GAMA_1(m)  ]; vortex to be convected or shed
     %ZF_1  = [ZV_1(1), ZV_1(m) ] = [ZF(1), ZF(2)]; leading and trailing edges
     %ZW_1  = [ ZW_1(1)  ,  ZW_1(2)   ]; Convect ZF_1 
        
    %step 2: iGAMAw_2=2, iGAMAf_2=4
     %GAMAw_2=GAMAf_1=[GAMA_1(1) , GAMA_1(m) ]; wake vortex
     %GAMAf_2=[GAMA_1(1) , GAMA_1(m), GAMA_2(1) , GAMA_2(m) ]; vortex to be convected or shed
     %ZF_2  = [ZW_1(1)  , ZW_1(2) , ZV_1(1), ZV_1(m) ] 
     %      = [ ZF_2(1)  ,  ZF_2(2) ,  ZF_2(3)  ,  ZF_2(4)  ]
     %ZW_2  = [ ZW_2(1)  ,  ZW_2(2) ,  ZW_2(3)  ,  ZW_2(4)  ]; Convect ZF_2 in the current coord system
        
    %step 3: iGAMAw_3=4, iGAMAf_3=6
     %GAMAw_3=GAMAf_2=[GAMA_1(1) , GAMA_1(m), GAMA_2(1) , GAMA_2(m) ]; wake vortex
     %GAMAf_3=[GAMA_1(1) , GAMA_1(m), GAMA_2(1) , GAMA_2(m), GAMA_3(1) , GAMA_3(m) ]; vortex to be convected or shed
     %ZF_3  = [ZW_2(1)  , ZW_2(2) , ZW_2(3)  , ZW_2(4) , ZV_1(1), ZV_1(m) ]
     %      = [ ZF_3(1)  ,  ZF_3(2) ,  ZF_3(3)  ,  ZF_3(4) ,  ZF_3(5)  ,  ZF_3(6)  ]
     %ZW_3  = [ ZW_3(1)  ,  ZW_3(2) ,  ZW_3(3)  ,  ZW_3(4) ,  ZW_3(5)  ,  ZW_3(6)  ]; Convect ZF_3 in the current coord system
    
    %Setup the matrix for the nonpenetration condition
    %Use the wing-fixed coordinate system to calcuate the matrix coefficients. 
    %The matrix coefficients in the global system are identical to
    %these and remain constant throughout the time steps.
    igmatrixCoef( xv,yv,xc,yc,dfc,m); %Calcuate only once and keep using for eaxh step
    
    if vfplot == 1
        %Generate a cartesian mesh in the wing-fixwd system for velocity plot
        if camber == 0.0
            [ZETA] = igcMESH(c_,d_);
        else
            [ZETA] = igcamberMESH(c_,d_, camber);
        end
    end
    %Start time marching
    for istep =1:nstep
        t=(istep-1)*dt; %Use (istep-1) to start with time=0
        %Get airfoil motion parameters
        [alp,l,h,dalp, dl,dh] = igairfoilM(t,e,beta,gMax,p,rtOff,U,V);
        LDOT(istep)=dl;
        HDOT(istep)=dh;
        
        %Get the global coordinates of the votex and collocation points on the wing
        %ZV,ZC      vortex and collocation points on the wing (global system)
        %ZVt,ZCt    vortex and collocation points on the wing (translatingsystem)
        %NC         unit normal of the wing at the collocation points (global)
        %ZW,ZWt     wake vortex in the global and translational systems
        %           ZW in istep=1 is assigned zero (or null) by initialization
        %           ZW=ZF for istep >=2 (see the last command of the time marching loop)
        [NC,ZV,ZC,ZVt,ZCt,ZWt] = igwing2global(istep,t,a,alp,l,h,xv,yv,xc,yc,dfc,ZW);
        
        %Normal Velocity on the airfoil due to the bound vortex
        [VN] = igairfoilV(ZC,ZCt,NC,t,dl,dh,dalp);
        
 %%%%%%%%%%iGAMAw=2*(istep-1)%%%%%%%%%%       
        %Normal velocity on the airfoil due to the wake vortex
        [VNW] = ignVelocityw2(m,ZC,NC,ZF,GAMAw,iGAMAw); %produces zero VNW for step 1
        
        %Solve the system of equations
         %MVN (Coefficient matrix) has m-1 components so far; need to add mth components
        [GAMA]=igsolution(m,VN,VNW,istep,sGAMAw);
        
        
        %Plot locations, ZW, of the wake vortices for the current step
        %in the space-fixed system
        igplotVortexw(iGAMAw,ZV,ZW,istep);
        
        %Calculate the linear and angular impiulses on the airfoil (after shedding)
        %Use the translating system (this is airframe inertia system)
        %Include all of the bound vortices and wake vortices.
        %For istep=1, there is no wake vortices.
        igimpulses(istep,ZVt,ZWt,a, GAMA,m,GAMAw,iGAMAw);
        
        
        if vfplot ==1
        %Plot velocity field
        igplotVelocity(istep,ZV,ZW,a,GAMA,m,GAMAw,iGAMAw,alp,l,h);
        end

        
 %%%%%%%%%%iGAMAf=2*istep%%%%%%%%%%
 
        
        %Calculate the velocity at the free and wake vortices to be shed or convected
        iGAMAf=2*istep;
        ZF(2*istep-1)=ZV(1); %append the coordinate of the leading edge
        ZF(2*istep  )=ZV(m); %append the coordinate of the trainling edge
        [VELF]=igvelocity(ZF,iGAMAf,GAMA,m,ZV,GAMAw,iGAMAw);
        
        %Convect GAMAf from ZF to ZW
        [ZW]=igconvect(ZF,VELF,dt,iGAMAf);
        
        %Increment the number of wake vortices
        iGAMAw=iGAMAw+2;
        GAMAw(2*istep-1)=GAMA(1);
        GAMAw(2*istep  )=GAMA(m);
        %Add the new wake vortices from the current step
        sGAMAw=sGAMAw+GAMA(1)+GAMA(m);
        
%%%%%%%%%%iGAMAw=2*istep%%%%%%%%%%          
    
        %All the convected vortices become wake vortices
        %Set these wake vortex to be the free vortices in the next step
        %,where two more free vortices (leading and trailing edge vortices)
        %will be added before convection
        ZF=ZW;
    end
   
    %Calculate the dimensional force and moment on the airfoil
    %The force and moment are per unit length (cm) in out-of-plane
    %direction
    igforceMoment(rho_,v_,d_, nstep,dt,U,V);
    
    %Print and plot the magnitudes of the dimensional wake vortex
    igplotMVortexw(v_,d_,GAMAw,nstep);
   
%close opened files
    fclose('all');
end

