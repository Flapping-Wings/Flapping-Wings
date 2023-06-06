function [ aimp] =saimpulse_tr(X,n,gama,beta,phi,theta,a)

%Moment of inertia for the triangular element in the wing-translating (inertia) system
%INPUT
% X(j,3,i)
% n(j,i)
% gama(i)


% h(i)
% lR(i)
% lL(i)
% S(i)
% xi(j,i);
% eta(j,i)
% xH(j,i)

[ h,lR,lL,S,xi,eta,xH ] = Triangle( X );

A=[a 0 0];

for j=1:3
    Int(j,:)=S.*(A(j)+xH(j,:))+(1/6)*h.*(lR+lL).*(xi(j,:).*(lR-lL)+eta(j,:).*h);
end

%Cross of Int and n

IN(1,:)=Int(2,:).*n(3,:)-Int(3,:).*n(2,:);
IN(2,:)=Int(3,:).*n(1,:)-Int(1,:).*n(3,:);
IN(3,:)=Int(1,:).*n(2,:)-Int(2,:).*n(1,:);

for j=1:3
    impulseA(j,:)=-gama.*IN(j,:);
end
for j=1:3
    aimp(j)=sum(impulseA(j,:)); 
end
%Transform from local to translating system
%[ aimp] = L2T( aimp,beta,phi,theta,a );    




end



