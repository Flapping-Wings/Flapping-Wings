function [ y ] = DtableSTailB(t, p,rtOff )
%Table function with a tail for gamma fot 4 periods 0<= t <= 8

    e0=exp(-2.0*p*(t-(0.0+rtOff)));    
    e1=exp(-2.0*p*(t-(1.0+rtOff)));    
    e2=exp(-2.0*p*(t-(2.0+rtOff)));   
    e3=exp(-2.0*p*(t-(3.0+rtOff)));
    e4=exp(-2.0*p*(t-(4.0+rtOff)));   
    e8=exp(-2.0*p*(t-(8.0+rtOff)));
    f0=2.0*p*e0./(1.0+e0).^2;
    f1=4.0*p*e1./(1.0+e1).^2;
    f2=4.0*p*e2./(1.0+e2).^2;
    f3=4.0*p*e3./(1.0+e3).^2;
    f4=2.0*p*e4./(1.0+e4).^2;
    f8=2.0*p*e8./(1.0+e8).^2;
    y=-f0+f1-f2+f3-f4-f8;

end

