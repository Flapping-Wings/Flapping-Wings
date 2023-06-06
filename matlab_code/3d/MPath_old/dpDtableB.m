
function [ y ] = dpDtableB( t,rt,tau,p,rtOff )
%Basic Table function for gamma fot two periods 0<= t <= 4

%INPUT VARIABLES
% rtOff     rotation timing offset

    e0=exp(-2.0*p*(t*rt+tau-(0.0+rtOff)));    
    e1=exp(-2.0*p*(t*rt+tau-(1.0+rtOff)));    
    e2=exp(-2.0*p*(t*rt+tau-(2.0+rtOff)));
    e3=exp(-2.0*p*(t*rt+tau-(3.0+rtOff)));    
    e4=exp(-2.0*p*(t*rt+tau-(4.0+rtOff)));
    
    f0=4.0*p*rt*e0./(1.0+e0).^2;
    f1=4.0*p*rt*e1./(1.0+e1).^2;
    f2=4.0*p*rt*e2./(1.0+e2).^2;
    f3=4.0*p*rt*e3./(1.0+e3).^2;
    f4=4.0*p*rt*e4./(1.0+e4).^2;
    y=-f0+f1-f2+f3-f4;

end


