function [ X] = tblrL2T_2(iwing, x,beta,delta,phi,theta)
%Coordinate transformation of the free vector from the wing-fixed to translationg system
%Examples of free vectors: velocity, unit normal to the element
%INPUT
% iwing 1(right wing), 2(left)
% x(j,i)  any vector  in the wing-fixed system
% beta  flap plane angle
% delta     body angle
% phi   flapping angle
% theta rotation angle (pitch)
%OUTPUT
%X(j,i)

%Rotation offset is zero
a=0.0;

%Local to flap plane inertia system xb(j)
cth=cos(theta);
sth=sin(theta);
cph=cos(phi);
sph=sin(phi);

xb(1,:)=     cth*(x(1,:)+a)             +sth*x(3,:);
xb(2,:)= sph*sth*(x(1,:)+a)+cph*x(2,:)-sph*cth*x(3,:);
xb(3,:)=-cph*sth*(x(1,:)+a)+sph*x(2,:)+cph*cth*x(3,:);

if iwing ==2 %do nothing for right wing
    %LHS to RHS
    xb(2,:)=-xb(2,:);
end

%Flap plane inertia to translation iertia
%Effective stroke angle
beta=beta-delta;
cb=cos(beta);
sb=sin(beta);

X(1,:)= sb*xb(1,:)      +cb*xb(3,:);
X(2,:)=          xb(2,:);
X(3,:)=-cb*xb(1,:)      +sb*xb(3,:);

%
clear xb
end

