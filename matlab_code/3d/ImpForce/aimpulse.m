function [ aimp] =aimpulse(Xa,n1,n2,gama,beta,phi,theta,a)

%Moment of inertia in the wing-translating (inertia) system
%INPUT
% Xa(j,4,i)
% n1(j,i), n2(j,i)
% gama(i)

%Divide Xa into 2 triangulr elements
%Rectangular element node numbering (%x-horizontal; y-vertical)
% 2   3
%
% 1   4
%Divide into 2 triangle elements: 123 & 134
% 2   3        3
%        &
% 1        1   4
s=size(Xa);
%For Triangle 1 2 3
X=zeros(3,3,s(3));
X=Xa(:,1:3,:);
[aimp1] = saimpulse_tr(X,n1,gama,beta,phi,theta,a);

%For triangle 1 3 4
X=zeros(3,3,s(3));
tindex=[1 3 4];
X=Xa(:,tindex,:);
[aimp2] = saimpulse_tr(X,n2,gama,beta,phi,theta,a);

%Add angular impulses from the two triangles
aimp=aimp1+aimp2;
%Transform to column vector
aimp=aimp';

   




end

