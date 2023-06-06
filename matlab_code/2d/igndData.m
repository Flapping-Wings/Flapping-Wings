function [v_, t_,d_,e,c,x,y,a, U, V] = igndData(l_,phiT,phiB,c_,x_,y_,a_,U_,V_,T_ )
global fid 
%Convert the insect flight input length parameters (dimensional) into
% non-dimensional parameters
%INPUT VARIABLES
% l_        span length (length)
% c_        chord length (length)
% x_, y_    airfoil data points
% phiT      top stroke angle (>0)
% phiB      bottom stroke angle (<0)
% a_        rotation distance offset (length)
% U_,V_     air speed (cm/sec)
% T_        period (sec)

%OUTPUT
% d_        stroke length (dimentional)
% v_
% t_

% Get nondimentional quantities 
% based on the given flight data of actual insect
    dT_=l_*sin( phiT);
    dB_=l_*sin(-phiB);
    d_=dT_+dB_;    %total stroke length
    fprintf(fid,'d_ = %6.3f\n',d_);
    e_=dT_-dB_;    %stroke difference
    %d=d_/d_=1.0;   %d_ is the reference length       
    e=e_/d_;
    c=c_/d_;
    fprintf(fid,'c  = %6.3f\n',c);
    a=a_/d_;
    x=x_/d_;
    y=y_/d_;
%t_ = reference time   
    t_ = T_/2.0;
%v_ = reference velocity
    v_=d_/t_;
    fprintf(fid,'v_ = %6.3f\n',v_);
%ambient velocity (nondimentional)
    U=U_/v_;
    V=V_/v_;
    fprintf(fid,'U = %6.3f\n',U);

end

