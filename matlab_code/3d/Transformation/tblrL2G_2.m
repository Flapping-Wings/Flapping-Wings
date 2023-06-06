function [ X] = tblrL2G_2(iwing, x,n,beta,delta,phi,theta,a,U,t,b )
%Coordinate transformation from the wing-fixed to global & translating systems
%INPUT
% iwing     1(right wing), 2(left)
% x(j,i)    unit normal vector  in the wing-fixed system
%    j=1:3
%    i=1,...,any number
% beta  flap plane angle
% delta body angle
% phi   flapping angle
% theta  rotation angle (pitch)
% a rotation offset
% U(j)      wing velocity
% t         time
% b         wing offset
%OUTPUT
% X(j,i)    global
% xt(j,i)   translating


xb=zeros(3,n);
xt=zeros(3,n);
X =zeros(3,n);

%Local to flap plane inertia system Xb(j)
cth=cos(theta);
sth=sin(theta);
cph=cos(phi);
sph=sin(phi);

xb(1,:)=     cth*(x(1,:)+a)               +sth*x(3,:);
xb(2,:)= sph*sth*(x(1,:)+a)+cph*x(2,:)-sph*cth*x(3,:);
xb(3,:)=-cph*sth*(x(1,:)+a)+sph*x(2,:)+cph*cth*x(3,:);

if iwing == 2 %do nothing for right wing
    %LHS to RHS
    xb(2,:)=-xb(2,:);
end

%From Flap plane inertia to translating iertia
%Effective flap plane angle
beta=beta-delta;
cb=cos(beta);
sb=sin(beta);

xt(1,:)= sb*xb(1,:)      +cb*xb(3,:);
xt(2,:)=          xb(2,:);
xt(3,:)=-cb*xb(1,:)      +sb*xb(3,:);


%From Translating Inertia to the Global
X(1,:)= -U(1)*t+b*cos(delta)+xt(1,:);
X(2,:)= -U(2)*t             +xt(2,:);
X(3,:)= -U(3)*t-b*sin(delta)+xt(3,:);

clear xt xb cb sb cth sth cph sph;

end

