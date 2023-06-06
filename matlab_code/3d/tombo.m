function [  ] = tombo()
%{
===========================================================================
-Thin 3D airfoil by the discrete vortex method. All elements rectangular
-Four wings, forward and rear, right and left, flapping independeltly
-Motion path consists of the flapping and rotation, which is specified 
   based on the tombo (dragonfly in Japanese) morphology and flight data.
-Formulate in the space-fixed coordinate system based on diptera.m 
Version 1, Completed 9:00 am on Jan 1, 2015 (Started on December, 30, 2014)
  impulses forces and moment are calculated in the body-translating system
Version 2, Jan 1, 2015
    Add wing motion path plotter (stime=1)
    Plot front and rear wakes together
    remove GAMAc_m (m=f,r)
Version 3, Jan 2, 2014
    General clean-up
    Add tail wing motion option mPath=3 for path plotter
        td = 1(TOPDOWN), 2(DOWNUP)
        nhp= 4, 8 (# of half-periods for sinusoidal+tail)
        w = 1(right), 2(left) wing
Version 4, Jan 4, 2014
    Remove mPath=2 option of stime=1
    Added motion path options 1-5
===========================================================================
%}
%{
===========================================================================
MATRIX DIMENSION EXTENSION STRATEGY FROM ONE TO MULTIPLE WINGS:
For n-D (n>=3) array, add the nwing dimension as the the end of the matrices
used for single wing
    Ex: Xb_f = zeros(3,4,nxb,nwing), but not Xb_f = zeros(nwing,3,4,nxb)
This will allow to reuse the original codes for the single wing
    Ex: Xb_f(3,4,nxb,1) compatible Xb_f(3,4,nxb), but
        Xb_f(1,3,4,nxb) not compat Xb_(3,4,nxb)
For 2D array introduce nwing dimension in front
    Ex: GAMAw_f=zeros(nwing,nxb)  
This will allow to retain the raw vextor structure for the single wing 
    Ex: GAMAw_f(1,:)=raw vector, but GAMAw_f(:,1)=column vector
===========================================================================
%}
%{
===========================================================================
Select from 3D airfoil mesh generator functions
smesh 1 (tapered symmetric): Tapered rectangulr and rectangular wings
         Cambered tapered rectangular wings. Camber can be in 2 directions
      2 (5 sided: tapered general, no camber) 
      3 (6 sided: two four sided regions, no camber)

Elemnt structure
    Edge elements (Occupying the border strips)
         Located along the outer boundary & to be shed
    Center elements 
Element function
    Shed elements       Edge elements (Outer elements)
    Bound elements      Center elements
Wing indexing
    forward and rear    _f ,  _r,           _m [both]
    four wings          (1), (2), (3), (4), (tw)[all]
    two wings           (1), (2),           (w) [all)
Element count
    nxb_m     # of shed edge elements
    nxc_m     # of center elements
    nxt_m     # of total elements

===========================================================================
%}
%{
===========================================================================
Difference between 2D and 3D
3D: The translating sys has its origin at the wing base whose translational 
velocity consists only of -U (opposite of the wind velocity).
2D: The translating system has its origin at the middle of the wing span
and its trnslatiobal velocity has components (l,h) from flapping & pitching 
and the negative wing velocity -U.
===========================================================================
%}

%GLOBAL VARIABLES
global v_ t_ f_  d_  tau rt 
global istep nwing nstep 
global iplot mplot vplot wplot mpath idebg solver
global fid  folder
global RCUT LCUT
global limpa_f aimpa_f limpw_f aimpw_f limpa_r aimpa_r limpw_r aimpw_r

%==========================================================================
%Time specification: 1(multiple times) 2(time marching)
    stime = 2;
%Time increment and # of time steps
    dt = 0.1; %For higher values of p, use smaller value of dt 
    nstep = 4;
%DEBUGGING PARAMETERS======================================================
%How to specify the file path:
    folder = '_fig/'; 
%Linear equation solver: 0 (forward elim/backward sub), 1(backslash)
    solver = 0;
%System of equations debug (print VN,Vnc,GAMA): 0(no print), 1(print)
    idebg = 1;
%Chord path plot: 0(no plot), 1(chord path plot)
    iplot = 1;
%Airfoil Mesh plot: mesh plot 0 (no), 1(yes)
    mplot = 1; 
%Airfoil normal velocity plot: vplot 0(no), 1(yes)
    vplot = 1;
%Plot gamma
    gplot = 1;

%Wake Vortex plot: 0(n0), 1(yes)
    wplot = 1;   

%Open an Output File:    
fid=fopen([folder 'output.txt'],'w');
    
%===========BODY GEOMETRY==================================================
%# of wings
    twing=4; 
    nwing=twing/2;
%Body angle (degree)
    delta_=0;
%Wing location (cm): _f (fore wing), _r (rear wing)
    b_f= -1.5; b_r=1.5; %Make sure b_f<=0, b_r>=0 
    
    fprintf(fid, 'delta_ = %6.3f, b_f = %6.3f, b_r = %6.3f\n', delta_,b_f,b_r);
%===========WING GEOMETRY:=================================================WING-FIXED DESCRIPTION OF THE WING
%right & left wings have the same geometry 
    %{
    The right wing is introduced, first in the wing-fixed system
    Then, the space-fixed description of the right wing is obtained
    Finally, the left wing is introduced as the mirror image of the right 
    wing in the space-fixed description
    %}
%Front and Rear wings have different geometry
    % FRONT WING: with subscriot _r
    % xb_f(j,n,i)   Border element coordinates
    % nxb_f         # of border elements
    % nb_f(j,i)     Unit normal to the border elements
    % xc_f(j,n,i)   Center element coordinates
    % nxc_f         # of center elements
    % nc_f(j,i)     Unit normal to the center elements
    % l_f           span
    % c_f           chord
    % h_f           border height
    
    % REAR WING: with subscriot _r 
    % xb_r(j,n,i)   Border element coordinates
    % nxb_r         # of border elements
    % nb_r(j,i)     Unit normal to the border elements
    % xc_r(j,n,i)   Center element coordinates
    % nxc_r         # of center elements
    % nc_r(j,i)     Unit normal to the center elements
    % l_r           span
    % c_r           chord
    % h_r           border height
    
    [xb_f,nxb_f,nb_f,xc_f,nxc_f,nc_f,l_f,c_f,h_f,...
     xb_r,nxb_r,nb_r,xc_r,nxc_r,nc_r,l_r,c_r,h_r] = Wing(  ); 
    fprintf(fid,'nxb_f = %3d, nxc_f = %3d, nxb_r = %3d, nxc_r = %3d\n',...
            nxb_f,nxc_f,nxb_r,nxc_r);
%Wing clearance check
    if(b_r-b_f >= 0.5*(c_r+c_f))
        fprintf(fid,'Wing clearance checked\n');
    else
        fprintf(fid,'Rear and forward wings interfare\n');
    end

    
%======WING MOTION PARAMETERS: different between 
%front-right(1), front-left(2), rear-right(3), rear-left(4),wings==========
% stroke angles (degrees)
    phiT_(1) =  80; phiT_(2) =  80; phiT_(3) =  80; phiT_(4) =  80;
    phiB_(1) = -45; phiB_(2) = -45; phiB_(3) = -45; phiB_(4) = -45;
% a_ rotation axis offset (cm)
    a_(1)    =   0; a_(2)    =   0; a_(3)    =   0; a_(4)    =   0;
% beta = stroke plane angle (degrees) wrt the body axis
    beta_(1) =  90; beta_(2) =  90; beta_(3) =  90; beta_(4) =  90;
% f_ = flapping frequency (1/sec)
    f_(1)    =  30;  f_(2)   =  30; f_(3)    =  30;  f_(4)   =  30;
% gMax = max rotation (degrees) amplitude: actual rotation is 2*gMax
    gMax_(1) =  30;  gMax_(2) = 30; gMax_(3) =  30;  gMax_(4) = 30; 
%{    
p = rotation speed parameter (nondimentional): p>=4
    Non-dimensional parameters are given; 
    Dimensional parameters, p_(i) are calculated by 0.5*T_(i)*p(i).
    DEF: p(i)=p_(i)/(0.5*T_(i)), nondimensionalized by its own period; 
         p(1)  =           p_(1)/t_ref, but 
         p(2) ~=(not equal)p_(2)/t_ref,
         p(3) ~=(not equal)p_(3)/t_ref,
         p(4) ~=(not equal)p_(4)/t_ref,
         wheret_ref is the rference time
%}
    p(1)     =   5;   p(2)    =   5; p(3)    =   5;   p(4)    =   5;
    for i=1:twing
        if p(i)<4
            disp(['p(',num2str(i),') must be bigger than 4'])
        end
    end
%{
rtOff=rotation timing offset (nondim): 
rtOff<0(advanced), rtOff=0 (symmetric), rtOff>0(delayed), -0.5<rtOff<0.5
    Non-dimensional parameters are given; 
    Dimensional parameters, rtOff_(i) are calculated by 0.5*T_(i)*rtOff(i).
    DEF: rtOff(i) =rtOff_(i)/(0.5*T_(i)), nondim by its own period; 
         rtOff(1) =rtOff_(1)/t_ref, but 
         rtOff(2)~=rtOff_(2)/t_ref,
         rtOff(3)~=rtOff_(3)/t_ref,
         rtOff(4)~=rtOff_(4)/t_ref,
         wheret_ref is the rference time   
%}
    rtOff(1) = 0.0; rtOff(2) = 0.0; rtOff(3) = 0.0; rtOff(4) = 0.0;
    for i=1:twing
        if abs(rtOff(i))>0.5
            disp(['-0.5<=rtOff(',num2str(i),')<=0.5 is not satisfied'])
        end    
    end
%{
tau = phase shift for the time (nondim): 0 <= tau < 2
0(start from TOP and DOWN), 0<tau<1(in between, start with DOWN STROKE)
1(BOTTOM and UP), 1<tau<2(in between, start with UP STROKE), 2(TOP) 
    Non-dimensional parameters are given; 
    Dimensional parameters, rtOff_(i) are calculated by 0.5*T_(i)*rtOff(i).
    DEF: tau(i) =tau_(i)/(0.5*T_(i)), nondim by its own period; 
         tau(1) =tau_(1)/t_ref, but 
         tau(2)~=tau_(2)/t_ref,
         tau(3)~=tau_(3)/t_ref,
         tau(4)~=tau_(4)/t_ref,
         wheret_ref is the rference time     
    
%}
    tau(1)  = 0.0;     tau(2)  = 0.0; tau(3)  = 0.0;     tau(4)  = 0.0;
    for i=1:twing
        if  tau(i) < 0 || tau(i) >2
            disp(['0<= tau(',num2str(i),') < 2 is not satisfied'])
        end
    end
%Motion path parameter: mpath
    %{
    0: noTail Standard flapping(sinusoidal) & rotation (smoothed step func)
    1: td=1(DUTail),   nhp=4(2periods)     
    2: td=2(UDTail),   nhp=4(2periods) 
    3: td=1(DUDUTail), nhp=8(4periods) 
    4: td=2(UDUDTail), nhp=8(4periods) 
    5: ctct(UDTailUTail, nhp=4
    %}
    mpath(1) = 0    ; mpath(2) = 0; mpath(3) = 0    ; mpath(4) = 0;
    fprintf(fid,'mpath(1:4) = %3d %3d %3d %3d\n',mpath);
%==========FLUID PARAMETERS
%Air density
    rho_=0.001225; %g/cm^3
%Ambient velocity (cm/sec, assume constant)
%Can be interpreted as the flight velocity when the wind is calm
    U_(1)=  100.0;
    U_(2)=  0.0;
    U_(3)=  0.0;

%Distance between source and observation points to be judged as zero
    RCUT=1.0e-10; 
 
%PRINT INPUT DATA==========================================================
for i=1:twing
    fprintf(fid, ['phiT_(',num2str(i),')= %6.3f, phiB_(',num2str(i),...
                  ') = %6.3f\n'], phiT_(i),phiB_(i));
    fprintf(fid, ['   a_(',num2str(i),') = %6.3f, beta_(',num2str(i),...
                  ') = %6.3f, f_(',num2str(i),') = %6.3f\n'], ...
            a_(i),beta_(i),f_(i));
    fprintf(fid, ['   gMax_(',num2str(i),')= %6.3f, p(',num2str(i),...
                  ')= %6.3f, rtOff(',num2str(i),') = %6.3f, tau(',num2str(i),...
                  ')= %6.3f\n'],gMax_(i),p(i),rtOff(i),tau(i));
end
fprintf(fid, 'U(1)_   = %6.3f, U(2)_   = %6.3f, U(3)_   = %6.3f,\n',U_);
fprintf(fid,'nstep = %4d dt = %6.3f\n',nstep,dt);
%==========================================================================

%Nondimentionalize the input variables
    %Non-dimensionaized by d_(1) [stroke plane length of the r-front wing]
    % c,h,a,d
    %Non-dimensinalized by its own motion 
    % e (p, rtOff, tau: given non-dimentionally as inputs)
     [ l,c ,h ,                       phiT ,phiB ,a ,beta ,delta, gMax ,U ,xb_f,xc_f,xb_r,xc_r,b_f,b_r,e,d] = ...
     tbndData(l_f,c_f,h_f,l_r,c_r,h_r,phiT_,phiB_,a_,beta_,delta_,gMax_,U_,xb_f,xc_f,xb_r,xc_r,b_f,b_r);
    %{
    input  xb_f,xc_f,xb_r,xc_r are dimentional
    output xb_f,xc_f,xb_r,xc_r are nondimentional; xb_m(j,1:5,i), xc_m(j,1:5,i)
    ALL quanties below are nondimensional
    l,c,h,phiT,phiB,a,beta,gMax,e: 4 index quantities
    %}
%Cut off distance off the extension of a vortex line
    %Velocity evaluation points within this distance from the vortex line
    %and/or its extension is set to zero. See mVORTEX.m for its application
    LCUT=0.1*h(1); 
   
%Comparison of flapping, pitching and air speeds 
    air=sqrt(U_(1)^2+U_(2)^2+U_(3)^2);
    fprintf(fid, 'air speed = %6.3e\n',air);
    if air > 1.0E-03
        %Flapping/Air Seed Ratio
        fk=2*f_.*d_/air;
        fprintf(fid, 'flapping/air: speed ratio   = %6.3e %6.3e %6.3e %6.3e\n', fk);
        %Pitch/Flapping Speed Ratio
        r=0.5*((0.5*c+a)./d).*(p/t_).*(gMax./f_);
        fprintf(fid, 'pitch/flapping: speed ratio = %6.3e %6.3e %6.3e %6.3e\n', r);
        %Pitch/Air Speed Ratio
        k=fk.*r;
        fprintf(fid, 'pitch/air: speed ratio      = %6.3e %6.3e %6.3e %6.3e\n', k);
    else
        %Pitch/Flapping Speed Ratio
        r=0.5*((0.5*c+a)./d).*(p/t_).*(gMax./f_);
        fprintf(fid, 'pitch/flapping: speed ratio = %6.3e %6.3e %6.3e %6.3e\n', r);        
    end    

    
%{
Elements on the total wing surface [all nondimensional]
index C for Collocation, c for center region; _m for front anfd rear wings
    xC_m(j,i)    coordinates of the total collocation points on the wing
    nC_m(j,i)    unit normal at the total collocation points on the wing
    xt_m(j,n,i)  coordinates of the nodes for total elements on the wing 
    nxt_m        # of total elements on the wing [i=1:nxt]
    xb_m(j,n,i)  Reduced xb (no center point; n=1:4)
    xc_m(j,n,i)  Reduced xc (no center point; n=1:4)
%} 
    %Front right wing
    [ xc_f,xb_f,xt_f,nxt_f,xC_f,nC_f ] = WingTotal( xb_f,nxb_f,nb_f,xc_f,nxc_f,nc_f ); 
    %Rear right wing
    [ xc_r,xb_r,xt_r,nxt_r,xC_r,nC_r ] = WingTotal( xb_r,nxb_r,nb_r,xc_r,nxc_r,nc_r );
    

%{                                                                            %WING-FIXED DESCRIPTION OF THE WING CONTINUES
%INITIALIZATION  
    %Initialize the wake vortex magnitude array
    %Start with the size at istep=1 (will be incremented by nxb_m each step)
    GAMw_f=zeros(nwing,nxb_f); GAMw_r=zeros(nwing,nxb_r); 
    %Initialize the total wake vortex number
    nxw_f = 0; nxw_r = 0;
    %Initialize the wake vortex location array (after convection)
    %Start with the size at istep=1 (will be incremented by nxb_m each step)
    Xw_f = zeros(3,4,nxb_f,nwing); Xw_r = zeros(3,4,nxb_r,nwing); 
    %Initialize the shed vortex location array 
    Xs_f = zeros(3,4,nxb_f,nwing); Xs_r = zeros(3,4,nxb_r,nwing);
    
  if nstep >3
    %Initialize the linear and angular impuse array
    tmp=zeros(3,nstep,nwing);
    limpa_f=tmp;    limpa_r=tmp;
    aimpa_f=tmp;    aimpa_r=tmp;
    limpw_f=tmp;    limpw_r=tmp;
    aimpw_f=tmp;    aimpw_r=tmp; 
  end
    
    %Normal velocity on the wing due to the wing motion & wake vortices
    Vnc_f =zeros(nwing,nxt_f); Vnc_r =zeros(nwing,nxt_r);
    Vncw_f=zeros(nwing,nxt_r); Vncw_r=zeros(nwing,nxt_f);
    %sub-matrix for the non-penetration condition (self-terms)
    MVNs_f=zeros(nxt_f,nxt_f,nwing);   MVNs_r=zeros(nxt_r,nxt_r,nwing); 
    
    %Initialize velocity value matrices
    VBW_f=zeros(3,4,nxb_f,nwing); VBW_r=zeros(3,4,nxb_r,nwing);  
    
    %{
    Get the space-fixed system coordinates of the points on the wing
    Xb_m(j,n,i,w)   coordinates of the nodes for border elements on the wing
    Xt_m(j,n,i,w)   coordinates of the nodes for total elements on the wing
    XC_m(j,i,w)     coordinates of the total collocation points on the wing 
    Get the translating system coordinates on the body
    NC_m(j,i,w)     unit normal at the total collocation points on the wing
                  NC_m=NC_T_m inside tblrmassL2DT.m
    %}                                                                          
    Xc_f=zeros(3,4,nxc_f,2);    Xc_r=zeros(3,4,nxc_r,2);
    Xb_f=zeros(3,4,nxb_f,2);    Xb_r=zeros(3,4,nxb_r,2);
    Xt_f=zeros(3,4,nxt_f,2);    Xt_r=zeros(3,4,nxt_r,2);
    XC_f=zeros(3,  nxt_f,2);    XC_r=zeros(3,  nxt_r,2);
    NC_f=zeros(3,  nxt_f,2);    NC_r=zeros(3,  nxt_r,2); 
   
%END INITIALIZATION 

%Time variable to be considered
switch stime

case 1 %Multiple times (FOR PLOTTING THE CHORD PATH)
    %Plot Chord Path (and time history of flapping & rotation)
    tmax=dt*50;
    t=0:dt:tmax;
    %Use only mPath=0 and 3
    mPath=3;
    u=U(1); v=U(2); w=U(3);
    switch mPath
        case 0 %sinusoidal (no tail, no camber)
            %FRONT RIGHT wing
            AZ=-120; %horizontal rotation (from y-axis)
            EL=30;   %vertical elevation (from horizontal)         
            tbwingPathNC(1,t,rt(1),e(1),c(1),a(1),b_f, beta(1),delta,gMax(1),...
                p(1),rtOff(1),tau(1),u,v,w,phiT(1),phiB(1),l(1),AZ,EL);
            %FRONT LEFT wing
            AZ=-60;
            EL=30;
            tbwingPathNCL(2,t,rt(2),e(2),c(2),a(2),b_f,beta(2),delta,gMax(2),...
                p(2),rtOff(2),tau(2),u,v,w,phiT(2),phiB(2),l(2),AZ,EL);
            %REAR RIGHT wing
            AZ=-120; %horizontal rotation (from y-axis)
            EL=30;   %vertical elevation (from horizontal)         
            tbwingPathNC(3,t,rt(3),e(3),c(3),a(3),b_r, beta(3),delta,gMax(3),...
                p(3),rtOff(3),tau(3),u,v,w,phiT(3),phiB(3),l(3),AZ,EL);
            %REAR LEFT wing
            AZ=-60;
            EL=30;
            tbwingPathNCL(4,t,rt(4),e(4),c(4),a(4),b_r,beta(4),delta,gMax(4),...
                p(4),rtOff(4),tau(4),u,v,w,phiT(4),phiB(4),l(4),AZ,EL);
        case 1 %sinusoidal (no tail, cambered)
            %{
            AZ=-120; %horizontal rotation (from y-axis)
            EL=30;   %vertical elevation (from horizontal)
            wingPath(t,e,c,a,beta,gMax,p,rtOff,u,v,w,phiT,phiB,l,AZ,EL);
            AZ=-60;
            EL=30;
            wingPathL(t,e,c,a,beta,gMax,p,rtOff,u,v,w,phiT,phiB,l,AZ,EL);
            %}
  
       case 3 %sinusoidal + tail 
            td=1;    %TOPDOWN
            %td=2;    %DOWNUP
            nhp=8;   %8 half periods=2 periods sinusoital+2 periods tail 
            %nhp=4;   %4 half periods=1 period  sinusoital+  period  tail
            %FRONT RIGHT wing
            AZ=-120; %horizontal rotation (from y-axis)
            EL=30;   %vertical elevation (from horizontal)         
            tbwingPathTail(td,nhp,1,1,t,rt(1),e(1),c(1),a(1),b_f, beta(1),delta,gMax(1),...
                p(1),rtOff(1),tau(1),u,v,w,phiT(1),phiB(1),l(1),AZ,EL);        
            %FRONT LEFT wing
            AZ=-60;
            EL=30;
            tbwingPathTail(td,nhp,2,2,t,rt(2),e(2),c(2),a(2),b_f,beta(2),delta,gMax(2),...
                p(2),rtOff(2),tau(2),u,v,w,phiT(2),phiB(2),l(2),AZ,EL);
            %REAR RIGHT wing
            AZ=-120; %horizontal rotation (from y-axis)
            EL=30;   %vertical elevation (from horizontal)         
            tbwingPathTail(td,nhp,1,3,t,rt(3),e(3),c(3),a(3),b_r, beta(3),delta,gMax(3),...
                p(3),rtOff(3),tau(3),u,v,w,phiT(3),phiB(3),l(3),AZ,EL);
            %REAR LEFT wing
            AZ=-60;
            EL=30;
            tbwingPathTail(td,nhp,2,4,t,rt(4),e(4),c(4),a(4),b_r,beta(4),delta,gMax(4),...
                p(4),rtOff(4),tau(4),u,v,w,phiT(4),phiB(4),l(4),AZ,EL);                
        otherwise
    end

case 2 %Time marching (MAIN FEATURE OF THIS PROGRAM) 
    %{
    Vortex convection time history (for each wing; indice, _m & w, omitted)
    -----------------------------------------------------------------------
    step 1: nxw_1=    0, nxf_1=  nxb
     GAMw_1          = [0              ];   no wake vortex
     GAMAf_1(1:  nxb) = [        GAMAb_1];   vortex to be shed
     Xf_1   (1:  nxb) = [        Xb_1   ];   border elements
     Xw_1   (1:  nxb)                    ;   Convect Xf_1 
        
    step 2: nxw_2=  nxb, nxf_2=2*nxb
     GAMw_2(1:  nxb) = [GAMAf_1        ];   wake vortex
     GAMAf_2(1:2*nxb) = [GAMw_2,GAMAb_2];   vortex to be convected or shed
     Xf_2   (1:2*nxb) = [Xw_1   ,Xb_2   ];   wake & border elements
     Xw_2   (1:2*nxb)                    ;   Convect Xf_2 
        
    step 3: nxw_3=2*nxb, nxf_3=3*nxb
     GAMw_3(1:2*nxb) = [GAMAf_2        ];   wake vortex
     GAMAf_3(1:3:nxb) = [GAMw_3,GAMAb_3];   vortex to be convected or shed
     Xf_3   (1:3*nxb) = [Xw_2   ,Xb_3   ];   wake & border elements
     Xw_3   (1:3*nxb)                    ;   Convect Xf_3 
    -----------------------------------------------------------------------
      
    Alternative time history (for each wing; index twing is omitted)
    Xf(free=border elements+wake elements), Xs(shed), Xw (wake);
    C=convected
    -----------------------------------------------------------------------
    step 1: nxw_1=0, nxf_1=nxb
     GAMw_1=[( )]                               No wake vortex
     GAMAf_1=[GAMAb_1]                           Vortex to be conv/shed
     Xf_1   =[Xb_1 ]                             Border elements
     Xw_1   =[Xs_1 ]                             Convect Xb_1  
        
    step 2: nxw_2=nxb, nxf_2=2*nxb
     GAMw_2=[GAMAb_1]                           Wake vortex
     GAMAf_2=[GAMAb_1, GAMAb_2]                  Vortex to be conv/shed
     Xf_2   =[Xw_1  , Xb_2 ]                     Wake and Border elements
     Xw_2   =[XwC_1 , Xs_2 ]                     Convect Xf_2  
        
    step 3: nxw_3=2*nxb, nxf_3=3*nxb
     GAMw_3=[GAMAb_1, GAMAb_2]                  Wake vortex
     GAMAf_3=[GAMAb_1, GAMAb_2, GAMAb_3]         Vortex to be conv/shed
     Xf_3   =[Xw_2  , Xb_3 ]=[XwC_1 ,Xs_2 ,Xb_3] Wake and Border elements
     Xw_3   =[XwC_2 , Xs_3 ]=[XwCC_1,XsC_2,Xs_3] Convect Xf_3
    -----------------------------------------------------------------------
    %}
      
    %{  
    Setup the matrix MVN for the nonpenetration condition
    MVN=| MVNs_11, MVNs_12, MVNs_13, MVNs_14 | 
        | MVNs_21, MVNs_22, MVNs_23, MVNs_24 |
        | MVNs_31, MVNs_32, MVNs_33, MVNs_34 |, where MVNs_ij are 
        | MVNs_41, MVNs_42, MVNs_43, MVNs_44 |  (nxt_m,nxt_m) submatrices.
    MVNs_ii (i=1:4)(time independent); calculated once and stored
     Use the wing-fixed coordinate system. 
     Use of the space-fixed system gives the same results
    MVNs_ij (i~=j) (time dependent); calculated at each time
    %}
    %FRONT WING: MVNs_f(:,:,1)=MVNs_11, MVNs_f(:,:,2)=MVNs_22
    for w=1:nwing
        [MVNs_f(:,:,w) ] = tblrsetMatrix(w,xt_f,nxt_f,xC_f,nC_f);
        if idebg ==1
            fprintf(fid,'MVNs_f  :\n');
            fprintf(fid,'w=  %3d\n',w);
            for i=1:nxt_f      
                fprintf(fid,'i = %3d\n',i);
                fprintf(fid,'%7.3f ',MVNs_f(i,:,w));
                fprintf(fid,'\n');  
            end
        end               
    end 
    
    %REAR WING: MVNs_r(:,:,1)=MVNs_33, MVNs_r(:,:,2)=MVNs_44
    for w=1:nwing
        [MVNs_r(:,:,w) ] = tblrsetMatrix(w,xt_r,nxt_r,xC_r,nC_r);
        if idebg ==1
            fprintf(fid,'MVNs_r  :\n');
            fprintf(fid,'w=  %3d\n',w);
            for i=1:nxt_r      
                fprintf(fid,'i = %3d\n',i);
                fprintf(fid,'%7.3f ',MVNs_r(i,:,w));
                fprintf(fid,'\n');  
            end
        end               
    end     
  %Start time marching
  for istep =1:nstep
    if idebg == 1
        fprintf(fid,'ISTEP = %3d\n',istep);
    end
    t=(istep-1)*dt; %Use (istep-1) to start with time=0 
    %Get wing motion parameters
    for i=1:twing 
        [phi(i),theta(i),dph(i),dth(i)]=tbwingM(mpath(i),t,rt(i),tau(i),...
                               e(i),gMax(i),p(i),rtOff(i),phiT(i),phiB(i));
    end
                                                                           %FROM WING-FIXED TO SPACE-FIXED 
    %{
    Get the space-fixed system coordinates of the points on the wing
    Xb_m(j,n,i,w)   coordinates of the nodes for border elements on the wing
    Xt_m(j,n,i,w)   coordinates of the nodes for total elements on the wing
    XC_m(j,i,w)     coordinates of the total collocation points on the wing 
    Get the translating system coordinates on the body
    NC_m(j,i,w)     unit normal at the total collocation points on the wing
                  NC_m=NC_T_m inside dplrmassL2DT.m
    %}
    %FRONT WING                                                                       
    for i=1:nwing
        [Xc_f(:,:,:,i),Xb_f(:,:,:,i),Xt_f(:,:,:,i),XC_f(:,:,i),NC_f(:,:,i)]...
        = tblrmassL2GT(i,beta(i),delta,phi(i),theta(i),a(i),U,t,b_f,...
                       xc_f,xb_f,xt_f,xC_f,nC_f); 
    end  
    %REAR WING                                                                       
    for i=1:nwing
        [Xc_r(:,:,:,i),Xb_r(:,:,:,i),Xt_r(:,:,:,i),XC_r(:,:,i),NC_r(:,:,i)]...
        = tblrmassL2GT(i,beta(i+2),delta,phi(i+2),theta(i+2),a(i+2),U,t,b_r,...
                       xc_r,xb_r,xt_r,xC_r,nC_r); 
    end 

    %Velocity of the wing 
    %FRONT WING
    %xC_f=xC_f(j,i)  coord of the total collocation points on the w-f sys
    %XC_f(j,i)       coord of the total collocation points in the s-f sys
    for i=1:nwing
        [Vnc_f(i,:)]=tblrswingNVs(1,i,xC_f,XC_f(:,:,i),NC_f(:,:,i),t,theta(i),...
                                  phi(i),dph(i),dth(i),a(i),beta(i),U); 
        if idebg == 1
            fprintf(fid,'Vnc_f :\n');
            fprintf(fid,'i = %3d\n',i);
            fprintf(fid,'%7.3f ', Vnc_f(i,:));
            fprintf(fid,'\n');          
        end                                   
    end
    %REAR WING
    %xC_r=xC_r(j,i)  coord of the total collocation points on the w-f sys
    %XC_r(j,i)       coord of the total collocation points in the s-f sys
    for i=1:nwing
        [Vnc_r(i,:)]=tblrswingNVs(2,i,xC_r,XC_r(:,:,i),NC_r(:,:,i),t,theta(i+2),...
                                  phi(i+2),dph(i+2),dth(i+2),a(i+2),beta(i+2),U); 
        if idebg == 1
            fprintf(fid,'Vnc_r :\n');
            fprintf(fid,'i = %3d\n',i);
            fprintf(fid,'%7.3f ', Vnc_r(i,:));
            fprintf(fid,'\n');          
        end                                   
    end
                                                                           %nxw=nxb*(istep-1) 
    %Normal vel on each airfoil by front & rear, right & left wake vortices
    %For each wing, there are 4 wake vortex contributions
    %Produces zero Vncw_m for step 1
    %FRONT WING
    for i=1:nwing   
        [Vncw_f(i,:)]=tbnvelTbyW(istep,nxt_f,XC_f(:,:,i),NC_f(:,:,i),...
                                 Xw_f,GAMw_f,nxw_f,Xw_r,GAMw_r,nxw_r);   
    end
    %REAR WING
    for i=1:nwing   
        [Vncw_r(i,:)]=tbnvelTbyW(istep,nxt_r,XC_r(:,:,i),NC_r(:,:,i),...
                                 Xw_f,GAMw_f,nxw_f,Xw_r,GAMw_r,nxw_r);   
    end
 
    %Calculation of the time-dependent sub-matrices MVNs_ij (i~=j)
    %target wing=1, source wing=2
    [MVNs_12]=tbcrossMatrix(XC_f(:,:,1),NC_f(:,:,1),nxt_f,Xt_f(:,:,:,2),nxt_f);
    %target wing=1, source wing=3
    [MVNs_13]=tbcrossMatrix(XC_f(:,:,1),NC_f(:,:,1),nxt_f,Xt_r(:,:,:,1),nxt_r); 
    %target wing=1, source wing=4
    [MVNs_14]=tbcrossMatrix(XC_f(:,:,1),NC_f(:,:,1),nxt_f,Xt_r(:,:,:,2),nxt_r); 
    %target wing=1, source wing=2
    [MVNs_21]=tbcrossMatrix(XC_f(:,:,2),NC_f(:,:,2),nxt_f,Xt_f(:,:,:,1),nxt_f);
    %target wing=1, source wing=3
    [MVNs_23]=tbcrossMatrix(XC_f(:,:,2),NC_f(:,:,2),nxt_f,Xt_r(:,:,:,1),nxt_r); 
    %target wing=1, source wing=4
    [MVNs_24]=tbcrossMatrix(XC_f(:,:,2),NC_f(:,:,2),nxt_f,Xt_r(:,:,:,2),nxt_r);     
    %target wing=1, source wing=2
    [MVNs_31]=tbcrossMatrix(XC_r(:,:,1),NC_r(:,:,1),nxt_r,Xt_f(:,:,:,1),nxt_f);
    %target wing=1, source wing=3
    [MVNs_32]=tbcrossMatrix(XC_r(:,:,1),NC_r(:,:,1),nxt_r,Xt_f(:,:,:,2),nxt_f); 
    %target wing=1, source wing=4
    [MVNs_34]=tbcrossMatrix(XC_r(:,:,1),NC_r(:,:,1),nxt_r,Xt_r(:,:,:,2),nxt_r); 
    %target wing=1, source wing=2
    [MVNs_41]=tbcrossMatrix(XC_r(:,:,2),NC_r(:,:,2),nxt_r,Xt_f(:,:,:,1),nxt_f);
    %target wing=1, source wing=3
    [MVNs_42]=tbcrossMatrix(XC_r(:,:,2),NC_r(:,:,2),nxt_r,Xt_f(:,:,:,2),nxt_f); 
    %target wing=1, source wing=4
    [MVNs_43]=tbcrossMatrix(XC_r(:,:,2),NC_r(:,:,2),nxt_r,Xt_r(:,:,:,1),nxt_r); 
    
    %Assemble the total matrix using MVNs_f(:,:,2),MVNs_r(:,:,2),MVNs_ij(:,:)
    [ MVN ] = tbassembleMatrix( nxt_f,nxt_r,MVNs_f,MVNs_r,MVNs_12,MVNs_13,MVNs_14,...
    MVNs_21,MVNs_23,MVNs_24,MVNs_31,MVNs_32,MVNs_34,MVNs_41,MVNs_42,MVNs_43 );
    
    %Solve the system of equations
   
    [ GAMA ] = tbsolution(nxt_f,nxt_r,MVN,Vnc_f,Vncw_f,Vnc_r,Vncw_r);
    
    %Split GAMA into 4 parts
    GAM_f(1,1:nxt_f)=GAMA(               1 :  nxt_f        ); %Front Right wing
    GAM_f(2,1:nxt_f)=GAMA((  nxt_f      +1):2*nxt_f        ); %Front Left  wing 
    GAM_r(1,1:nxt_r)=GAMA((2*nxt_f      +1):2*nxt_f+  nxt_r); %Rear Right wing
    GAM_r(2,1:nxt_r)=GAMA((2*nxt_f+nxt_r+1):2*nxt_f+2*nxt_r); %Rear Left  wing 
    if idebg == 1
        fprintf(fid,'GAM:\n');
        %FRONT WING
        for i=1:nwing
            fprintf(fid,'i = %3d\n',i);
            fprintf(fid,'%7.3f ',GAM_f(i,:));
            fprintf(fid,'\n');           
        end
        %REAR WING
        for i=1:nwing
            fprintf(fid,'i = %3d\n',i);
            fprintf(fid,'%7.3f ',GAM_r(i,:));
            fprintf(fid,'\n');           
        end
    end 
 
    %Plot GAMA at the collocation points of the elements
    %using the unit normal direction: positive up and negative down
    if gplot ==1
        %FRONT WING
        for i=1:nwing
            tbplotGAM(1,i,t,GAM_f(i,:), XC_f(:,:,i),NC_f(:,:,i) );
        end
        %REAR WING
        for i=1:nwing
            tbplotGAM(2,i,t,GAM_r(i,:), XC_r(:,:,i),NC_r(:,:,i) );
        end       
    end
       
    %Plot locations, Xb & Xw, of border & wake vortices (space-fixed sys)
    %FRONT WING
    tbplotWB(1,istep,nxb_f,nxw_f,Xb_f,Xw_f);
    %REAR WING
    tbplotWB(2,istep,nxb_r,nxw_r,Xb_r,Xw_r);
    
  if nstep > 3 %Need at least 4 steps to calculate the forces & moments
    %Calculate impiulses in the body-translating system
    %Include all of the bound vortices and wake vortices.
    %For istep=1, there are no wake vortices. 
    %FRONT WING
    [limpa,aimpa,limpw,aimpw]=tbsimpulseWT(istep,U,t,Xt_f,Xw_f,GAM_f,GAMw_f,...
                                     beta(1:2),phi(1:2),theta(1:2),a(1:2));
    for j=1:3
        for w=1:nwing
            limpa_f(j,istep,w)=limpa(j,w);
            aimpa_f(j,istep,w)=aimpa(j,w);
            limpw_f(j,istep,w)=limpw(j,w);
            aimpw_f(j,istep,w)=aimpw(j,w);
        end
    end
    %REAR WING
    [limpa,aimpa,limpw,aimpw]=tbsimpulseWT(istep,U,t,Xt_r,Xw_r,GAM_r,GAMw_r,...
                                     beta(3:4),phi(3:4),theta(3:4),a(3:4)); 
    for j=1:3
        for w=1:nwing
            limpa_r(j,istep,w)=limpa(j,w);
            aimpa_r(j,istep,w)=aimpa(j,w);
            limpw_r(j,istep,w)=limpw(j,w);
            aimpw_r(j,istep,w)=aimpw(j,w);
        end
    end                                                                                                                                                  
  end
   
         
    %Extract GAMAb (border & shed ) from GAM
    %FRONT WING
        [GAMAb_f] = tbdivideGAM( GAM_f,nxb_f);
    %REAR WING
        [GAMAb_r] = tbdivideGAM( GAM_r,nxb_r);
            
    %VELOCITY OF THE BORDER AND WAKE VORTICES TO BE SHED OR CONVECTED======  
    %{
    Influence coeff for the border elem vel due to the total wing elem
    Self-influence coeff for each wing; calculated at each time step
    %}
    %FRONT WING
        [cVBT_f]=tbvelBbyTMatrix( nxb_f,nxt_f,Xb_f,Xt_f );
    %REAR WING
        [cVBT_r]=tbvelBbyTMatrix( nxb_r,nxt_r,Xb_r,Xt_r );          
    %Border element veocity due to the total wing elements: self-influence
        %VBTs_m(j,n,ixb,w);  vel on wing w due to total elem on wing w
        %FRONT WING
        [VBTs_f] = tbvelBbyT(cVBT_f, GAM_f,nxt_f );
        if idebg ==1         
            fprintf(fid,'VBTs_f :\n');
            for w=1:nwing
                fprintf(fid,'w= %3d\n',w);
                for i=1:nxb_f
                    fprintf(fid,'i= %3d\n',i);
                    for j=1:3
                        fprintf(fid,'%7.3f %7.3f %7.3f %7.3f\n',VBTs_f(j,1:4,i,w));
                    end
                end
            end
            fprintf(fid,'\n');
        end
       %REAR WING
        [VBTs_r] = tbvelBbyT(cVBT_r, GAM_r,nxt_r );
        if idebg ==1         
            fprintf(fid,'VBTs_r :\n');
            for w=1:nwing
                fprintf(fid,'w= %3d\n',w);
                for i=1:nxb_r
                    fprintf(fid,'i= %3d\n',i);
                    for j=1:3
                        fprintf(fid,'%7.3f %7.3f %7.3f %7.3f\n',VBTs_r(j,1:4,i,w));
                    end
                end
            end
            fprintf(fid,'\n');
        end
       
        
    %Border element veocity due to the total wing elements: cross-influence
        %target wing=1, source wing=2
        [VBTs_12]=tbcrossvelBbyT(Xb_f(:,:,:,1),nxb_f,Xt_f(:,:,:,2),GAM_f(2,:),nxt_f);
        %target wing=1, source wing=3
        [VBTs_13]=tbcrossvelBbyT(Xb_f(:,:,:,1),nxb_f,Xt_r(:,:,:,1),GAM_r(1,:),nxt_r);       
        %target wing=1, source wing=4
        [VBTs_14]=tbcrossvelBbyT(Xb_f(:,:,:,1),nxb_f,Xt_r(:,:,:,2),GAM_r(2,:),nxt_r);        
        %target wing=2, source wing=1
        [VBTs_21]=tbcrossvelBbyT(Xb_f(:,:,:,2),nxb_f,Xt_f(:,:,:,1),GAM_f(1,:),nxt_f);
        %target wing=2, source wing=3
        [VBTs_23]=tbcrossvelBbyT(Xb_f(:,:,:,2),nxb_f,Xt_r(:,:,:,1),GAM_r(1,:),nxt_r);       
        %target wing=2, source wing=4
        [VBTs_24]=tbcrossvelBbyT(Xb_f(:,:,:,2),nxb_f,Xt_r(:,:,:,2),GAM_r(2,:),nxt_r);
        %target wing=3, source wing=1
        [VBTs_31]=tbcrossvelBbyT(Xb_r(:,:,:,1),nxb_r,Xt_f(:,:,:,1),GAM_f(1,:),nxt_f);
        %target wing=3, source wing=2
        [VBTs_32]=tbcrossvelBbyT(Xb_r(:,:,:,1),nxb_r,Xt_f(:,:,:,2),GAM_f(2,:),nxt_f);       
        %target wing=3, source wing=4
        [VBTs_34]=tbcrossvelBbyT(Xb_r(:,:,:,1),nxb_r,Xt_r(:,:,:,2),GAM_r(2,:),nxt_r);        
        %target wing=4, source wing=1
        [VBTs_41]=tbcrossvelBbyT(Xb_r(:,:,:,2),nxb_r,Xt_f(:,:,:,1),GAM_f(1,:),nxt_f);
        %target wing=4, source wing=2
        [VBTs_42]=tbcrossvelBbyT(Xb_r(:,:,:,2),nxb_r,Xt_f(:,:,:,2),GAM_f(2,:),nxt_f);       
        %target wing=4, source wing=3
        [VBTs_43]=tbcrossvelBbyT(Xb_r(:,:,:,2),nxb_r,Xt_r(:,:,:,1),GAM_r(1,:),nxt_r);         
                        
    %Assemble the total border element velocity due to two wings using 
    %VBTs_f(j,n,i,w),VBTs_r(j,n,i,w), VBTs_ij(j,n,i)
        %VBT_f(j,n,ixb_f,w);  vel on front wing w due to total elem on 4 wings
        %VBT_r(j,n,ixb_r,w);  vel on rear wing w due to total elem on 4 wings
        [ VBT_f,VBT_r ] = tbassemblevelBbyT( nxb_f,VBTs_f,VBTs_12,VBTs_13,VBTs_14,VBTs_21,VBTs_23,VBTs_24,...
                                             nxb_r,VBTs_r,VBTs_31,VBTs_32,VBTs_34,VBTs_41,VBTs_42,VBTs_43);
        
    %Velocity involving the wake
    
    if istep > 1    
    %Velocity of the border element due to the wake vortices(istep >1)
        %VBW_f(j,n,ixb,w):  vel on front wing w due to 4 wake elements
        %VBW_r(j,n,ixb,w):  vel on rear  wing w due to 4 wake elements
        %VBW_m=0, by initialization, for istep=1
        %FRONT WING
        for i=1:nwing
            [VBW_f(1:3,1:4,1:nxb_f,i)]=tbvelBbyW(istep,Xb_f(:,:,:,i),nxb_f,Xw_f,GAMw_f,nxw_f,Xw_r,GAMw_r,nxw_r);  
        end
       %REAR WING
        for i=1:nwing
            [VBW_r(1:3,1:4,1:nxb_r,i)]=tbvelBbyW(istep,Xb_r(:,:,:,i),nxb_r,Xw_f,GAMw_f,nxw_f,Xw_r,GAMw_r,nxw_r);  
        end
        
    %Velocity of the wake elements due to the total wing vortices(istep >1)
        %VWT_f(j,n,ixw,w):  vel on front wake w due to total wing elements from 4 wings
        %VWT_r(j,n,ixw,w):  vel on rear  wake w due to total wing elements from 4 wings
        %FRONT WINGs
        for i=1:nwing
            [VWT_f(1:3,1:4,1:(istep-1)*nxb_f,i)]=tbvelWbyT(istep,Xw_f(:,:,:,i),nxw_f,Xt_f,GAM_f,nxt_f,Xt_r,GAM_r,nxt_r);  %VWT=0 for istep=1
        end
        %REAR WINGs
        for i=1:nwing
            [VWT_r(1:3,1:4,1:(istep-1)*nxb_r,i)]=tbvelWbyT(istep,Xw_r(:,:,:,i),nxw_r,Xt_f,GAM_f,nxt_f,Xt_r,GAM_r,nxt_r);  %VWT=0 for istep=1
        end             
        
    %Velocity of the wake elements due to the wake elements(istep >1)
        %VWW_f(j,n,ixw,w):  vel on front wake w due to 4 wake elements
        %VWW_r(j,n,ixw,w):  vel on rear  wake w due to 4 wake elements
        %FRONT WINGs
        for i=1:nwing
            [VWW_f(1:3,1:4,1:(istep-1)*nxb_f,i)]=tbvelWbyW(istep,Xw_f(:,:,:,i),nxw_f,Xw_f,GAMw_f,nxw_f,Xw_r,GAMw_r,nxw_r );     %VWW=0 for istep=1
        end 
        %REAR WINGs
        for i=1:nwing
            [VWW_r(1:3,1:4,1:(istep-1)*nxb_r,i)]=tbvelWbyW(istep,Xw_r(:,:,:,i),nxw_r,Xw_f,GAMw_f,nxw_f,Xw_r,GAMw_r,nxw_r );     %VWW=0 for istep=1
        end 
    end
    %END VELOCITY CALCULATION==============================================
        
        
    %Shed the border vortex elements
    %FRONT WINGs
    [ Xs_f ] = tbshedB(dt,VBT_f,VBW_f,Xb_f,nxb_f);
    %REAR WINGs
    [ Xs_r ] = tbshedB(dt,VBT_r,VBW_r,Xb_r,nxb_r);
    if istep > 1
        %Convect wake vortices
        %FRONT WINGs
        [ Xw_f ] = tbconvW(dt,VWT_f,VWW_f,Xw_f);
        %REAR WINGs
        [ Xw_r ] = tbconvW(dt,VWT_r,VWW_r,Xw_r);
    end
    
                                                                            %nxw=nxb*(istep)
    %Add shed vortices to wake vortex
    if istep ==1
        %FRONT WINGs
        GAMw_f=GAMAb_f;
        nxw_f=nxb_f;
        Xw_f=Xs_f;
        %REAR WINGs
        GAMw_r=GAMAb_r;
        nxw_r=nxb_r;
        Xw_r=Xs_r;
    else
        %FRONT WINGs
        [GAMw_f,nxw_f,Xw_f]=tbaddWake(nxb_f,GAMAb_f,Xs_f,GAMw_f,Xw_f);
        %REAR WINGs
        [GAMw_r,nxw_r,Xw_r]=tbaddWake(nxb_r,GAMAb_r,Xs_r,GAMw_r,Xw_r);
    end
        
    
  end %end of time marching

    if nstep > 3
        %Calculate the force and moment on the airfoil
        tbforceMoment(rho_,v_,d_(1),nstep,dt,U)
    end

otherwise
    %do nothing        
end %end of switch stime

    %close opened files
    fclose('all');

end

