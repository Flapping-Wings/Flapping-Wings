function [limpa,aimpa,limpw,aimpw] = tbsimpulseWT(istep,U,t,Xt,Xw,GAM,GAMAw,beta,phi,theta,a)
%Calculate linear and angular impulses due to the bound and wake vortices 
%in the body-translating system
%INPUT
% U(j)
% t
% Xt(j,n,i,w)   coordinates of the nodes for total elements on the wing
% Xw(j,n,i,w)   wake vortex location
% GAM(w,i)      bound vortices
% GAMAw(w,i)    wake vortices
% beta(w)
% phi(w)
% theta(w)
% a(w)

%OUTPUT
% limpa(j,w)
% aimpa
% limpw
% aimpw

global nwing

tmp=zeros(3,nwing);
limpa=tmp;
aimpa=tmp;
limpw=tmp;
aimpw=tmp;

%From Global to Translating Inertia
s=size(Xt);
Xt_T=zeros(s(1),s(2),s(3),s(4));
s=size(Xw);
Xw_T=zeros(s(1),s(2),s(3),s(4));
for i=1:nwing
    Xt_T(1,:,:,i)= U(1)*t+Xt(1,:,:,i);
    Xt_T(2,:,:,i)= U(2)*t+Xt(2,:,:,i);
    Xt_T(3,:,:,i)= U(3)*t+Xt(3,:,:,i);
    if istep >1
    Xw_T(1,:,:,i)= U(1)*t+Xw(1,:,:,i);
    Xw_T(2,:,:,i)= U(2)*t+Xw(2,:,:,i);
    Xw_T(3,:,:,i)= U(3)*t+Xw(3,:,:,i);
    end
end

for i=1:nwing
    %Bound vortex--------------------------------------------------------------
    %Linear inpulse
    [n1,n2,limp] = limpulse(Xt_T(:,:,:,i),      GAM(i,:),beta(i),phi(i),theta(i),a(i));
    %n1(j,nXt), n2(j,nXt)=unit normal for 2 triangulr iXt_th element
    limpa(:,i)=limp; 

    %Angular impulse
    [ aimp ] =     aimpulse(Xt_T(:,:,:,i),n1,n2,GAM(i,:),beta(i),phi(i),theta(i),a(i));
    aimpa(:,i)=aimp; 
    if istep >1
    %Wake vortex---------------------------------------------------------------
    %Linear impulse
    [n1,n2,limp] = limpulse(Xw_T(:,:,:,i),      GAMAw(i,:),beta(i),phi(i),theta(i),a(i));
    limpw(:,i)=limp; %limpw(i,:,istep)+limp;

    %Angulr impulse
    [ aimp ] =     aimpulse(Xw_T(:,:,:,i),n1,n2,GAMAw(i,:),beta(i),phi(i),theta(i),a(i));
    aimpw(:,i)=aimp; %aimpw(:,istep)+aimp;
    end
end
end

