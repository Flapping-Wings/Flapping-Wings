function [ h,lR,lL,S,xi,eta,xH ] = Triangle( X )
%Geometry of a triangle element
%INPUT
% X(j,n,i) j=1:3, n=1:3, i=1,nelm

%OUTPUT
% h(i)
% lR(i)
% lL(i)
% S(i)
% xi(j,i);
% eta(j,i)
% xH(j,i)
s=size(X);
x21=zeros(3,s(3)); x23=zeros(3,s(3));
for j=1:3
    x21(j,:)=X(j,1,:)-X(j,2,:);
    x23(j,:)=X(j,3,:)-X(j,2,:);
end
nx21=sqrt(x21(1,:).^2+x21(2,:).^2+x21(3,:).^2);
nx23=sqrt(x23(1,:).^2+x23(2,:).^2+x23(3,:).^2);
l=nx21;
xi=zeros(3,s(3));
for j=1:3
    xi(j,:)=x21(j,:)./l;
end
lL=x23(1,:).*xi(1,:)+x23(2,:).*xi(2,:)+x23(3,:).*xi(3,:);
lR=l-lL;
xj2=zeros(3,s(3)); xj3=zeros(3,s(3)); x2H=zeros(3,s(3)); xH=zeros(3,s(3)); xH3=zeros(3,s(3));
for j=1:3
    xj2(j,:)=X(j,2,:); %%%%%%%
    xj3(j,:)=X(j,3,:);
    x2H(j,:)=x21(j,:).*lL./l;
    xH(j,:) =xj2(j,:)+x2H(j,:); %modification was requires as 3 lines above
    xH3(j,:)=xj3(j,:)-xH(j,:);
end
h=sqrt(xH3(1,:).^2+xH3(2,:).^2+xH3(3,:).^2);
eta=zeros(3,s(3));
for j=1:3
    eta(j,:)=xH3(j,:)./h;
end
S=0.5*l.*h;



end

