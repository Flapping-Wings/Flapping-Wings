function [VN] = tbcrossMatrix(XC,NC,nxT,Xt,nxS)
%Set up a sub-matrix for target wing due to bound vortices on the source
%wing


%INPUT  
% target====
% XC(j,i)    coordinates of the total collocation points on the target wing
% NC(j,i)    unit normal at the total collocation points on the target wing
% nxT        # of total elements on the target wing
% source====
% Xt(j,n,i)  coordinates of the nodes for total elements on the source wing
% nxS        # of total elements on the source wing
%OUTPUT
% VN(nxT, nxS)  sub-matrix for the nonpenetration condition 

%Set up a coefficient matrix for the nonpenetration condition on the airfoil surface
%Use collocation point vector XC(j,i) and the unit normal vector NC(j,i) for the all collocation points
%Pre allocate the space for VN
VN=zeros(nxT,nxS);
s=size(XC);
r=[1,s(2)]; %Raw vector of length s(2)=nXt

for i=1:nxS
    U=zeros(r); V=zeros(r); W=zeros(r);    
    [dU,dV,dW]= VORTEXm(XC(1,:),XC(2,:),XC(3,:),Xt(1,1,i),Xt(2,1,i),Xt(3,1,i),Xt(1,2,i),Xt(2,2,i),Xt(3,2,i),1.0);
    U=U+dU; V=V+dV; W=W+dW;
    [dU,dV,dW]= VORTEXm(XC(1,:),XC(2,:),XC(3,:),Xt(1,2,i),Xt(2,2,i),Xt(3,2,i),Xt(1,3,i),Xt(2,3,i),Xt(3,3,i),1.0);
    U=U+dU; V=V+dV; W=W+dW;
    [dU,dV,dW]= VORTEXm(XC(1,:),XC(2,:),XC(3,:),Xt(1,3,i),Xt(2,3,i),Xt(3,3,i),Xt(1,4,i),Xt(2,4,i),Xt(3,4,i),1.0);
    U=U+dU; V=V+dV; W=W+dW;
    [dU,dV,dW]= VORTEXm(XC(1,:),XC(2,:),XC(3,:),Xt(1,4,i),Xt(2,4,i),Xt(3,4,i),Xt(1,1,i),Xt(2,1,i),Xt(3,1,i),1.0);
    U=U+dU; V=V+dV; W=W+dW;
    %Normal velocity
    VN(:,i)=(U.*NC(1,:)+V.*NC(2,:)+W.*NC(3,:))'; %Column i of VN
end 

end

