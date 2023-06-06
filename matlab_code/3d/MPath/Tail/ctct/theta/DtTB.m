function [ y ] = DtTB(t,rt,tau, p,rtOff )
%Table function with tail for gamma fo4 2 periods 0<= t <= 4
    e0=exp(-2.0*p*(t*rt+tau-(0.0+rtOff)));    
    e1=exp(-2.0*p*(t*rt+tau-(1.0+rtOff)));    
    e2=exp(-2.0*p*(t*rt+tau-(2.0+rtOff)));   
    e3=exp(-2.0*p*(t*rt+tau-(3.0+rtOff)));
    e4=exp(-2.0*p*(t*rt+tau-(4.0+rtOff)));   
    e5=exp(-2.0*p*(t*rt+tau-(5.0+rtOff)));
    e6=exp(-2.0*p*(t*rt+tau-(6.0+rtOff)));    
    e7=exp(-2.0*p*(t*rt+tau-(7.0+rtOff)));   
    e8=exp(-2.0*p*(t*rt+tau-(8.0+rtOff)));
    f0=2.0*p*e0./(1.0+e0).^2;
	f1=2.0*p*e1./(1.0+e1).^2;
	f2=2.0*p*e2./(1.0+e2).^2;
	f3=2.0*p*e3./(1.0+e3).^2;
	f4=2.0*p*e4./(1.0+e4).^2;
	f5=2.0*p*e5./(1.0+e5).^2;
	f6=2.0*p*e6./(1.0+e6).^2;
	f7=2.0*p*e7./(1.0+e7).^2;    
	f8=2.0*p*e8./(1.0+e8).^2;

	y=-f0+f1+f2-f3-f4+f5+f6-f7-f8;


end

