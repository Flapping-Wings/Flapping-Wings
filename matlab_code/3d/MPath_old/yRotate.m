function [X,Z,Y  ] = yRotate( sb,cb,x,z,y )
%INPUT
% sb,cb         sin and cos beta
% x,z,y         position for beta=pi/2
    X= sb*x+cb*z;
    Z=-cb*x+sb*z;
    Y=y;

end

