function [n1,n2,limp] = limpulsew(Xa,gama,beta,phi,theta,a)
%Calculate the linear impulses due to the bound or wake vortices in wing-translating system

%INPUT
% Xa(j,4,i)
% gama(i)
% beta, phi,theta, a
%OUTPUT
% n1(j,i),n2(j,i)   2 unit normal vectorsfor two triangles
% limp(j)           linear impulse column vector

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
[n1,limp1] = slimpulse_tr(X,gama,beta,phi,theta,a);

%For triangle 1 3 4
X=zeros(3,3,s(3));
tindex=[1 3 4];
X=Xa(:,tindex,:);
[n2,limp2] = slimpulse_tr(X,gama,beta,phi,theta,a);

%Add linear impulses from the two triangles
limp=limp1+limp2;
%Transform to column vector
limp=limp';
end

