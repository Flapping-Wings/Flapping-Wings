function [alp,l,h,dalp,dl,dh] = igairfoilM(t,e,beta,gMax,p,rtOff,U,V)
%Calculate airfoil translational and rotational parameters
%INPUT (all nondimentional)
% t         time
% e         stroke difference
% beta      stroke plane angle
% gMax      Max rotation angle
% p         Rotation parameter
% rtOff     Rotatio timing offset
% U         x air velocity
% V         y air velocity
%OUTPUT
% alp       pitch angle     
% dl,dh     lunge(x) and heap(y) velocity
% dalp      pitch angle rate
global tau mpath

switch mpath
    case 0
    %Translational Motion
    l =-U*t+0.5*(   cos(pi*(t+tau))+e)*cos(beta);
    h =-V*t+0.5*(   cos(pi*(t+tau))+e)*sin(beta);
    dl=-U  -0.5* pi*sin(pi*(t+tau))   *cos(beta);
    dh=-V  -0.5* pi*sin(pi*(t+tau))   *sin(beta);
    
    %Rotational Motion 
    [gam]=tableG(t,p,rtOff);
    gam=gMax*gam;
    alp=0.5*pi-beta+gam;    
    [ dgam ] = DtableG(t,p,rtOff);
    dalp=gMax*dgam;
    
    case 1
    %Translational Motion
    dl=-U+0.5*DcosTailG_2(t+tau)*cos(beta);
    dh=-V+0.5*DcosTailG_2(t+tau)*sin(beta);
    l=-U*t+0.5*cosTailG_2(t+tau, e)*cos(beta);
    h=-V*t+0.5*cosTailG_2(t+tau, e)*sin(beta);  
    
    %Rotational Motion 
    [gam]=tableSTailG_2(t,p,rtOff);
    gam=gMax*gam;
    alp=0.5*pi-beta+gam;    
    [ dgam ] = DtableSTailG_2(t,p,rtOff);
    dalp=gMax*dgam; 
    
    case 2
    %Translational Motion
    dl=-U+0.5*DcosUpTailG_2(t+tau)*cos(beta);
    dh=-V+0.5*DcosUpTailG_2(t+tau)*sin(beta);
    l=-U*t+0.5*cosUpTailG_2(t+tau, e)*cos(beta);
    h=-V*t+0.5*cosUpTailG_2(t+tau, e)*sin(beta);  
    
    %Rotational Motion 
    [gam]=tableUpSTailG_2(t,p,rtOff);
    gam=gMax*gam;
    alp=0.5*pi-beta+gam; 
    [ dgam ] = DtableUpSTailG_2(t,p,rtOff);
    dalp=gMax*dgam; 
    
    case 3
    %Translational Motion
    dl=-U+0.5*DcosTailG(t+tau)*cos(beta);
    dh=-V+0.5*DcosTailG(t+tau)*sin(beta);
    l=-U*t+0.5*cosTailG(t+tau, e)*cos(beta);
    h=-V*t+0.5*cosTailG(t+tau, e)*sin(beta);
    
    %Rotational Motion 
    [gam]=tableSTailG(t,p,rtOff);
    gam=gMax*gam;
    alp=0.5*pi-beta+gam;    
    [ dgam ] = DtableSTailG(t,p,rtOff);
    dalp=gMax*dgam; 
    
    case 4
    %Translational Motion
    dl=-U+0.5*DcosUpTailG(t+tau)*cos(beta);
    dh=-V+0.5*DcosUpTailG(t+tau)*sin(beta);
    l=-U*t+0.5*cosUpTailG(t+tau, e)*cos(beta);
    h=-V*t+0.5*cosUpTailG(t+tau, e)*sin(beta);
    
    %Rotational Motion 
    [gam]=tableUpSTailG(t,p,rtOff);
    gam=gMax*gam;
    alp=0.5*pi-beta+gam;    
    [ dgam ] = DtableUpSTailG(t,p,rtOff);
    dalp=gMax*dgam;     
    otherwise
    %None    
end

end

