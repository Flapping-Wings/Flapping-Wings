function [n,limp] = slimpulse_tr(X,gama,beta,phi,theta,a)
%Calculate the linear impulses due to the triangular bound or wake vortex elements in wing-translating system

%INPUT
% X(j,3,i)
% gama(i)
%OUTPUT
% n(j,i)
% limp(j)

%Initialization
s=size(X);
x1=zeros(3,s(3));
x2=zeros(3,s(3));
n =zeros(3,s(3));

%Linear impulse
for j=1:3
x1(j,:)=X(j,3,:)-X(j,1,:);
x2(j,:)=X(j,2,:)-X(j,1,:);
end
%cross product of x1 and x2
x1x2(1,:)=x1(2,:).*x2(3,:)-x1(3,:).*x2(2,:);
x1x2(2,:)=x1(3,:).*x2(1,:)-x1(1,:).*x2(3,:);
x1x2(3,:)=x1(1,:).*x2(2,:)-x1(2,:).*x2(1,:);
%add contributions from all elements
limp(1)=-0.5*dot(x1x2(1,:),gama);
limp(2)=-0.5*dot(x1x2(2,:),gama);
limp(3)=-0.5*dot(x1x2(3,:),gama);
%Transform from local to translating system
%[ limp] = L2T( limp,beta,phi,theta,a );

%unit normal
nx1x2=sqrt(x1x2(1,:).^2+x1x2(2,:).^2+x1x2(3,:).^2);
 
for j=1:3
    n(j,:)=x1x2(j,:)./nx1x2; %LHS works only if it is pre allocated
end

end

