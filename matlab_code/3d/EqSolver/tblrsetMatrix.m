function [VN ] = tblrsetMatrix(iwing,Xt,nXt,XC,NC)
%Set up a self-coefficient matrix for the nonpenetration condition on the 
%airfoil surface: coefficient matrix of normal vel by itself
%INPUT 
%iwing      1 (right wing), 2(left wing)
%Xt(j,n,i)  coordinates of the nodes for total elements on the wing 
%nXt        # of total elements on the wing [i=1:nXt]
%XC(j,i)    coordinates of all collocation points
%NC(j,i)    unit normal to all elements at the collocation points
%OUTPUT
% VN        matrix for the nonpenetration condition (nXt, nXt)

if iwing == 2  %do nothing for right wing
    %The left wing geometry is obtained by reversing the sign of y-coordinate of the right wing
    Xt(2,:,:)=-Xt(2,:,:);
    XC(2,:)  =-XC(2,:);
    NC(2,:)  =-NC(2,:);
end

%Pre allocate the space for VN
VN=zeros(nXt,nXt);
s=size(XC);
r=[1,s(2)]; %Raw vector of length s(2)=nXt

for i=1:nXt
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

