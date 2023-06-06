function [ xeE ] = BRelem( xeE,Xo,Ang)
%Transform coordinates from local to global border rectangular elements
%INPUT
%xeE(j,n,i) local j coordinates of the n-th node of i-th edge square elements
%           j=1:2; n=1:5 (5=center poiint); i=1:(m+2)

%Xo(j)        global coordinates of the origin of the local system
%Ang          rotation of the local wrt the global system
%OUTPUT
%xeE(j,n,i) global j coordinates of the n-th node of i-th edge square elements
cang=cos(Ang);
sang=sin(Ang);
xeE_1=xeE(1,:,:);
xeE_2=xeE(2,:,:);
XEE_1=cang*xeE_1-sang*xeE_2+Xo(1);
XEE_2=sang*xeE_1+cang*xeE_2+Xo(2);
xeE(1,:,:)=XEE_1;
xeE(2,:,:)=XEE_2;






end

