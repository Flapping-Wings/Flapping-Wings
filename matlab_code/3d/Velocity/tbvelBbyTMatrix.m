function [cVBT  ] = tbvelBbyTMatrix( nXb,nXt,Xb,Xt )
%Velocity coefficients at border element nodes (no offset) due to bound vortices

%INPUT
% nXb               #of border elements
% nXt               #of all elements on the wing
%Xb(j,n,i,nwing)          Border element coordinates j for node n of element i
%Xt(j,n,i,nwing)          coordinates of the nodes for total elements on the wing 


%OUTPUT (into global)
%cVBT

global nwing
%cVBT(j,n,ibelm,itelm)
    % itelm     index of whole elements on the wing
    % ibelm     index of border elements
    % n         4 nodes for each shed element
    % j         1-3 (x,y,z)
cVBT=zeros(3,4,nXb,nXt,nwing);
r=[1,4,nXb];



for w=1:nwing
for i=1:nXt
    U=zeros(r); V=zeros(r); W=zeros(r);    
    [dU,dV,dW]= VORTEXm(Xb(1,:,:,w),Xb(2,:,:,w),Xb(3,:,:,w),Xt(1,1,i,w),Xt(2,1,i,w),Xt(3,1,i,w),Xt(1,2,i,w),Xt(2,2,i,w),Xt(3,2,i,w),1.0);
    U=U+dU; V=V+dV; W=W+dW;
    [dU,dV,dW]= VORTEXm(Xb(1,:,:,w),Xb(2,:,:,w),Xb(3,:,:,w),Xt(1,2,i,w),Xt(2,2,i,w),Xt(3,2,i,w),Xt(1,3,i,w),Xt(2,3,i,w),Xt(3,3,i,w),1.0);
    U=U+dU; V=V+dV; W=W+dW;
    [dU,dV,dW]= VORTEXm(Xb(1,:,:,w),Xb(2,:,:,w),Xb(3,:,:,w),Xt(1,3,i,w),Xt(2,3,i,w),Xt(3,3,i,w),Xt(1,4,i,w),Xt(2,4,i,w),Xt(3,4,i,w),1.0);
    U=U+dU; V=V+dV; W=W+dW;
    [dU,dV,dW]= VORTEXm(Xb(1,:,:,w),Xb(2,:,:,w),Xb(3,:,:,w),Xt(1,4,i,w),Xt(2,4,i,w),Xt(3,4,i,w),Xt(1,1,i,w),Xt(2,1,i,w),Xt(3,1,i,w),1.0);
    U=U+dU; V=V+dV; W=W+dW;
    %Velocity coefficients
    cVBT(1,:,:,i,w)=U;
    cVBT(2,:,:,i,w)=V;
    cVBT(3,:,:,i,w)=W;
end 
end
clear U V W dU dV dW  
%cVBT
end

