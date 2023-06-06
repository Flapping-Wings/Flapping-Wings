function [l ,c ,h ,               phiT ,phiB ,a ,beta ,delta, gMax ,U ,Xb_f,Xc_f,Xb_r,Xc_r,b_f,b_r,e,d] = ...
 tbndData(l_f,c_f,h_f,l_r,c_r,h_r,phiT_,phiB_,a_,beta_,delta_,gMax_,U_,Xb_f,Xc_f,Xb_r,Xc_r,b_f,b_r) 
%==========================================================================
%INPUT (dimensional)
% l_f           front wing span
% c_f           front wing chord
% h_f           front wing border height
% l_r           rear wing span
% c_r           rear wing chord
% h_r           rear wing border height
% phiT_(tw)     top stroke angle (>0)
% phiB_(tw)     bottom stroke angle (<0)
% a_(tw)        rotation distance offset (length)
% beta_(tw)     stroke plane angle
% delta_        body angle
% gMax_(tw)     maximum rotation
% U_(j)         ambient velocity
% Xb_f(j,n,i)   forward border elements
% Xc_f(j,n,i)   forward center elements
% Xb_r(j,n,i)   rear border elements
% Xc_r(j,n,i)   rear center elements
% b_f           forward wing offset from the body center
% b_r           rear wing offset from the body center

%OUTPUT (nondimensional) 
% l(tw)         span length
% c(tw)         chord length 
% h(tw)         border height
% phiT(tw)      top stroke angle (>0)
% phiB(tw)      bottom stroke angle (<0)
% a(tw)         rotation distance offset (length)
% beta(tw)      stroke plane angle
% delta         body angle
% gMax(tw)      maximum rotation
% U(j)          ambient velocity
% Xb_f(j,n,i)   forward border elements
% Xc_f(j,n,i)   forward center elements
% Xb_r(j,n,i)   rear border elements
% Xc_r(j,n,i)   rear center elements
% b_f           forward wing offset from the body center
% b_r           rear wing offset from the body center
% e(tw)         flap excentricity
% d(tw)         stroke plane length

%GLOBAL
% d_(tw)    stroke length (dimentional)
% d(tw)     stroke length (nd); d(1)=1 but d(2)~=1
% f_(tw)    flap frequency
% rt(tw)    ratio of two periods (w=1/w=1:4)
% v_        reference velocity
% t_        reference time

global fid 
global d_ f_ rt   
global v_ t_        %reference speed and time

%Introduce 4 index quantities
    l_(1)=l_f;     c_(1)=c_f;     h_(1)=h_f; %right front
    l_(2)=l_f;     c_(2)=c_f;     h_(2)=h_f; %left  front
    l_(3)=l_r;     c_(3)=c_r;     h_(3)=h_r; %right rear
    l_(4)=l_r;     c_(4)=c_r;     h_(4)=h_r; %left  rear 
    
%Period
    T_=1.0./f_;
    rt=T_(1)./T_;
    fprintf(fid,'T_(w=1:4), rt(w=1:4) = %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f\n',T_,rt);

%Covert angles to radian
    fac=pi/180.0;
    phiT =fac*phiT_;
    phiB =fac*phiB_;
    beta =fac*beta_;
    delta=fac*delta_;
    gMax =fac*gMax_;

% Get nondimentional quantities 
% based on the given flight data of actual insect
    dT_=l_.*( phiT);
    dB_=l_.*(-phiB);
    d_=dT_+dB_;    %total stroke length
    fprintf(fid,'d_(m=1:4) = %6.3f %6.3f %6.3f %6.3f\n',d_);
    e_=dT_-dB_;    %stroke difference
    d=d_/d_(1);    %d_(1) is the reference length       

    a=a_/d_(1);
    c=c_/d_(1);
    l=l_/d_(1);
    h=h_/d_(1);
    fprintf(fid,'c = %6.3f %6.3f %6.3f %6.3f, l = %6.3f %6.3f %6.3f %6.3f\n',c,l);
     b_f= b_f/d_(1);     b_r= b_r/d_(1);
    Xb_f=Xb_f/d_(1);    Xb_r=Xb_r/d_(1);
    Xc_f=Xc_f/d_(1);    Xc_r=Xc_r/d_(1);
    
    e=e_./d_;     %e(i)=e_(i)/d_(i) for i=1:4
    


%t_ = reference time  (Use the time for the right front wing) 
    t_ = T_(1)/2.0;
%v_ = reference velocity (use the right front wing flapping velocity)
    v_=d_(1)/t_;
    fprintf(fid,'v_ = %6.3f\n',v_);
%ambient velocity (nondimentional)
    U=U_/v_;
    fprintf(fid,'U(1) = %6.3f, U(2) = %6.3f, U(3) = %6.3f\n',U);   
    
end

