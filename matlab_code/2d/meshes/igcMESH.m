function [ ZETA] = igcMESH(c_,d_ )
%Generate a mesh surrounding a flat airfoil using the Cartesian
%coordinates

%INPUT
% c_    chord length (with dimention)
% d_    stroke length
%LOCAL VARIABLES:
    %Definition of the mesh in the first quadrant
    %eosX   x-offset from zero
    %epsY   y-offset from zero
    %dX     x-increment
    %dY     y-increment
    %maxX   x-max
    %maxY   y-max
    %c_ = 1.0;
    
    epsX=0.15*c_;
    epsY=0.15*c_;
    dX  =0.30*c_;
    dY  =0.30*c_;
    maxX=1.0*d_;
    maxY=1.0*d_;
%define the renge in the quadrant
    rX=epsX:dX:maxX;
    rY=epsY:dY:maxY;
%total range
    Xrange=[-fliplr(rX), rX];
    Yrange=[-fliplr(rY), rY];
%mesh points
[xi,eta]=meshgrid(Xrange,Yrange);
ZETA=complex(xi,eta);
%nondimentionalize the mesh
    ZETA=ZETA/d_;

end

