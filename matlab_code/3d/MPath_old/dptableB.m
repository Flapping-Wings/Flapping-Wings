
function [ y ] = dptableB( t,rt,tau,p,rtOff )
%Basic Table function for gamma fot two periods 0<= t <= 4

%INPUT VARIABLES
% rtOff     rotation timing offset
% rt        period ratio T_(1)/T_(i)
% tau       phase shift
% p         rotatio parameter

    f0=2.0./(1.0+exp(-2.0*p*(t*rt+tau-(0.0+rtOff))));
    f1=2.0./(1.0+exp(-2.0*p*(t*rt+tau-(1.0+rtOff))));
    f2=2.0./(1.0+exp(-2.0*p*(t*rt+tau-(2.0+rtOff))));
    f3=2.0./(1.0+exp(-2.0*p*(t*rt+tau-(3.0+rtOff))));
    f4=2.0./(1.0+exp(-2.0*p*(t*rt+tau-(4.0+rtOff))));
    y=1.0-f0+f1-f2+f3-f4;
end

