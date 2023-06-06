function [ y ] = tableUpSTailB(t, p,rtOff )
%Table function with a tail for gamma fot 4 periods 0<= t <= 8

    
    f0=1.0./(1.0+exp(-2.0*p*(t-(0.0+rtOff))));
    f1=2.0./(1.0+exp(-2.0*p*(t-(1.0+rtOff))));
    f2=2.0./(1.0+exp(-2.0*p*(t-(2.0+rtOff))));
    f3=2.0./(1.0+exp(-2.0*p*(t-(3.0+rtOff))));
    f4=1.0./(1.0+exp(-2.0*p*(t-(4.0+rtOff))));
    f8=1.0./(1.0+exp(-2.0*p*(t-(8.0+rtOff))));
    y=f0-f1+f2-f3+f4+f8;

end

