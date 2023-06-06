function [U,V,W] = VORTEXm(X,Y,Z,x1,y1,z1,x2,y2,z2,GAMA)
%   CALCULATES THE INDUCED VELOCITY (U,V,W) AT MULTIPLE POINTS
%   (X,Y,Z) DUE TO ONE LINE SEGMENT WITH STRENGTH GAMA PER UNIT LENGTH
%   POINTING TO THE DIRECTION (x2,y2,z2)-(x1,y1,z1).
%INPUT
% X,Y,Z     observation point (multiple) coordinates
% x1,y1,z1  = End 1 of the line 
% x2,y2,z2  = End 2 of the line
%OUTPUT
% U,V,W     velocity components at  the observation points (X,Y,Z) due to one line

%Size info
% X,Y,Z,U,V,W have the size (1,imax): raw vectors
global RCUT
%   CALCULATION OF R1 X R2
    R1R2X=(Y-y1).*(Z-z2)-(Z-z1).*(Y-y2);
    R1R2Y=(Z-z1).*(X-x2)-(X-x1).*(Z-z2);
    R1R2Z=(X-x1).*(Y-y2)-(Y-y1).*(X-x2);
    
%   CALCULATION OF (R1 X R2 )**2
    SQUARE=R1R2X.*R1R2X+R1R2Y.*R1R2Y+R1R2Z.*R1R2Z;
    
%   CALCULATION OF R0(R1/R(R1)-R2/R(R2))
    R1=sqrt((X-x1).*(X-x1)+(Y-y1).*(Y-y1)+(Z-z1).*(Z-z1));
    R2=sqrt((X-x2).*(X-x2)+(Y-y2).*(Y-y2)+(Z-z2).*(Z-z2));    
    ROR1=(x2-x1).*(X-x1)+(y2-y1).*(Y-y1)+(z2-z1).*(Z-z1);
    ROR2=(x2-x1).*(X-x2)+(y2-y1).*(Y-y2)+(z2-z1).*(Z-z2);
    %Preallocate so that the finals has the full size with zeros where
    %the criterion to get i is not satisfied.
    zsize=zeros(size(X));
    COEF=zsize; U=zsize; V=zsize; W=zsize;
    
%Find all OBSERVATION POINTS not located on the LINE or its extension    
    %i = ones(1,length(X))
    i=logical((R1 > RCUT).*(R2 > RCUT).*(SQUARE > RCUT));
    %i = find(R1.*R2.*SQUARE > RCUT);
    %SQUARE=0 when (X,Y,Z) lies in the middle of the line
    %   warning: =0 also (X,Y,Z) lies on the extension of the line
    %R1 or R2=0 when (X,Y,Z) is at the end point
    %WHEN POINT (X,Y,Z) LIES ON VORTEX ELEMENT: ITS INDUCED VELOCITY IS
    %U=0., V=0., W=0.
    %Contributions from the line segments on the observation points are excluded 
    %and assigned 0 values for each of the following vector outputs.
    %This way, their contributions are effectively set to zero.
    COEF(i)=GAMA./(4.0*pi*SQUARE(i)).*(ROR1(i)./R1(i)-ROR2(i)./R2(i));
    U(i)=R1R2X(i).*COEF(i);
    V(i)=R1R2Y(i).*COEF(i);
    W(i)=R1R2Z(i).*COEF(i);
end

