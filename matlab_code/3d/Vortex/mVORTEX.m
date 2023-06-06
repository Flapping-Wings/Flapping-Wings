function [u,v,w] = mVORTEX(x,y,z,X1,Y1,Z1,X2,Y2,Z2,GAMA)
%   CALCULATES THE INDUCED VELOCITY (u,v,w) AT A POINT
%   (x,y,z) DUE TO MULTIPLE LINE SEGMENTS WITH THE SAME SIDE
%   BELONNGING TO MULTIPLE VORTEX ELEMENT WITH STRENGTH GAMA PER UNIT LENGTH
%   POINTING TO THE DIRECTION (X2,Y2,Z2)-(X1,Y1,Z1).
%INPUT
% x,y,z     observation point (single) coordinates
% X1,Y1,Z1  = are (m, 1) raw vectors, where m is the # of vortex elements.
%             Ends 1 of the lines for all vortex element with the common side
% X2,Y2,Z2  = same for ends 2
%OUTPUT
% u,v,w     velocity components at  the observation point (x,y,z) due to all lines
%           with the common sides, belonging to all vortex elements.
%Set the torelance limt for closeness of the observation point from the line
global RCUT LCUT
%   CALCULATION OF R1 X R2
    R1R2X=(y-Y1).*(z-Z2)-(z-Z1).*(y-Y2);
    R1R2Y=(z-Z1).*(x-X2)-(x-X1).*(z-Z2);
    R1R2Z=(x-X1).*(y-Y2)-(y-Y1).*(x-X2);
    
%   CALCULATION OF (R1 X R2 )**2
    SQUARE=R1R2X.*R1R2X+R1R2Y.*R1R2Y+R1R2Z.*R1R2Z;
    
%   CALCULATION OF R0(R1/R(R1)-R2/R(R2))
    R1=sqrt((x-X1).*(x-X1)+(y-Y1).*(y-Y1)+(z-Z1).*(z-Z1));
    R2=sqrt((x-X2).*(x-X2)+(y-Y2).*(y-Y2)+(z-Z2).*(z-Z2));    
    ROR1=(X2-X1).*(x-X1)+(Y2-Y1).*(y-Y1)+(Z2-Z1).*(z-Z1);
    ROR2=(X2-X1).*(x-X2)+(Y2-Y1).*(y-Y2)+(Z2-Z1).*(z-Z2);
%Preallocate so that the finals has the full size with zeros where
%the criterion to get i is not satisfied.
    zsize=zeros(size(X1));
    COEF=zsize; U=zsize; V=zsize; W=zsize;
    
%Find all line segments not located on the observation point 
    i=logical((R1 > RCUT).*(R2 > RCUT).*(sqrt(SQUARE) > LCUT));
    %i = (R1.*R2.*SQUARE > RCUT)
    %i = find(R1.*R2.*SQUARE > RCUT);
    %SQUARE=0 when (X,Y,Z) lies in the middle of the line
    %   warning: =0 also (X,Y,Z) lies on the extension of the line
    %R1 or R2=0 when (X,Y,Z) is at the end point
    %WHEN POINT (X,Y,Z) LIES ON VORTEX ELEMENT: ITS INDUCED VELOCITY IS
    %U=0., V=0., W=0.
    %Contributions from the line segments on the observation points are excluded 
    %and assigned 0 values for each of the following vector outputs.
    %This way, their contributions are effectively set to zero.
    COEF(i)=GAMA(i)./(4.0*pi*SQUARE(i)).*(ROR1(i)./R1(i)-ROR2(i)./R2(i));
    U(i)=R1R2X(i).*COEF(i);
    V(i)=R1R2Y(i).*COEF(i);
    W(i)=R1R2Z(i).*COEF(i);
%For each velocity components, sum contributions from all line segments 
%into a single scalar
%Only non-zero components (indicated by index i) are summed (zero
%components are skipped, but they have no contribution to the sum, anyway.)
%(No need to pre-allocate these, but done anyway as a good practice.)
    u=sum(U(i));
    v=sum(V(i));
    w=sum(W(i));
    clear W V U COEF i ROR2 ROR2 R2 R1 SQUARE R1R2z R1r2y R1R2x
end

