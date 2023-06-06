function [ Xc,Xb,Xt,nXt,XC,NC ] = WingTotal( Xb,nXb,Nb,Xc,nXc,Nc )
%Combine wing border & center elements
%INPUT
%Xb,nXb,Nb  Border element data
%Xc,nXc,Nc  Center element data
%OUTPUT
%Xc
%Xb(j,n,i)  reduced Xb (centroid removed; n=1:4
%Xt(j,n,i)  coordinates of the nodes for total elements on the wing
%nXt        # of total elements on the wing
%XC(j,i)    coordinates of the total collocation points on the wing
%NC(j,i)    unit normal at the total collocation points on the wing


%Initialization
    nXt=nXb+nXc;        %# of total rectangular elements on the wing
    XC=zeros(3,nXt);
    NC=zeros(3,nXt);
    Xt=zeros(3,4,nXt);

%Node points (excluding the collocation points)
    Xt(:,:,1:nXb      )=Xb(:,1:4,:);
    Xt(:,:,(nXb+1):nXt)=Xc(:,1:4,:);
%Collocation points
    XC(:,1:nXb      )  =Xb(:,5,  :);
    XC(:,(nXb+1):nXt)  =Xc(:,5,  :);
%Unit normal
    NC(:,1:nXb      )  =Nb;
    NC(:,(nXb+1):nXt)  =Nc;
%Redefine Xb & Xc
    tmp=Xb(:,1:4,:);
    Xb=zeros(3,4,nXb);
    Xb=tmp;
    tmp=Xc(:,1:4,:);
    Xc=zeros(3,4,nXc);
    Xc=tmp;
end

