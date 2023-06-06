function [ZETA ] = igcamberMESH(c_, d_, camber)
%--------------------------------------------------------------------------
%Generate a mesh surrounding a cambered airfoil 

%INPUT
% c_    chord length
% d_    stroke length
%OUTPUT:
    %ZETA       mesh points in airfoil fixed system; size(ZETA)=(m,n)
%LOCAL VALUABLES:
    %dX     x-increment
    %dY     y-increment
    %maxX   x-max
    %maxY   y-max
%--------------------------------------------------------------------------

    dX  =0.20*c_;
    dY  =0.20*c_;
    maxX=1.0*d_;
    maxY=1.0*d_;
    x1=-0.5:dX:0.5;
    x2= 0.7:dX:maxX;
    x3=-fliplr(x2);
    x=[x3 x1 x2];
    nx=length(x);
    atmp_=0.5;
    y1=camber*(atmp_^2-x1.^2);
    y2=0.0*x2;
    y=[y2 y1 y2];
    nyh=floor(nx/2);
        
    for i=1:nyh
        xi(i+nyh,:)=x;
        eta(i+nyh,:)=y+(i-0.5)*dY;
        xi(i    ,:)=x;
        eta(i    ,:)=y-(nyh-i+0.5)*dY;
    end
    ZETA=complex(xi,eta);
    %nondimentionalize the mesh
    ZETA=ZETA/d_;  
end

