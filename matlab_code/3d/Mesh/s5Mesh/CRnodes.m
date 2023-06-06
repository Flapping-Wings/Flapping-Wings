function [ Xct,Xcr ] = CRnodes( Lt,Lr,C,delta,n )
%Coodinates of the nodes for the rectangular mesh in the center region
%INPUT
%Lt     length of the tapered edge for the center region  
%Lr     length of the horizontal edge for the center region 
%C
%delta  half-base opening angle 
%n(I)   number of border strip elements: I=1:5
%OUTPUT
%Xct    nodes in the tapered region
%Xcr    nodes in the rectangular region

%Angle and length of radial lines
e=Lt*cos(delta);
for i=1:(n(3)+1)
    z=(-0.5+(i-1)/n(3))*C;
    lt(i)=sqrt(z*z+e*e);
    ang(i)=acos(z/lt(i));
end
%Tapered region
for ir=1:(n(3)+1)
    theta=ang(ir);
    dlt=lt(ir)/n(1);
    for ic=1:(n(1)+1)
        r=(ic-1)*dlt;
        Xct(1,ir,ic)=r*cos(theta);
        Xct(2,ir,ic)=r*sin(theta);
    end
end
%Rctangular region
y0=Lt*cos(delta);
dy=Lr/n(2);
for ir=1:(n(3)+1)
    x =lt(ir)*cos(ang(ir));
    for ic=1:(n(2)+1)
        y=y0+(ic-1)*dy;
        Xcr(1,ir,ic)=x;
        Xcr(2,ir,ic)=y;
    end
end
end

