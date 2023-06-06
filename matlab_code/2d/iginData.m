function [v_,t_, d_,e,c,x,y,a,beta,gMax,U,V ] = iginData(l_,phiT_,phiB_,c_,x_,y_,a_,beta_,f_,gMax_,U_,V_) 
%==========================================================================
%INPUT VARIABLES
% l_        span length (length)
% c_        chord length (length)
% x_,y_     airfoil data points (length)
% phiT_     top stroke angle (>0)
% phiB_     bottom stroke angle (<0)
% a_        rotation distance offset (length)
% f_        flap frequency
% beta_     stroke plane angle
% gMax_     maximum rotation
% p         rotation velocity parameter (nondimentional)
% rtOff     rotation timing offset (nondimensional)
% U_,V_     ambient velocity
%==========================================================================
%OUTPUT
% d_        stroke length (dimentional)
global fid
%Period
    T_=1.0/f_;
    fprintf(fid,'T_ = %6.3f\n',T_);

%Covert angles to radian
    fac=pi/180.0;
    phiT=fac*phiT_;
    phiB=fac*phiB_;
    beta=fac*beta_;
    gMax=fac*gMax_;

%Nondimensional length quantities
    [v_,t_, d_,e,c,x,y,a, U, V] = igndData(l_,phiT,phiB,c_,x_,y_,a_,U_,V_,T_ );
   
end

