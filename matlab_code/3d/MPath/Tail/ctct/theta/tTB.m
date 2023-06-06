function [ y ] = tTB(t,rt,tau, p,rtOff )
%Table function with tail for gamma fo4 2 periods 0<= t <= 4

    f0=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(0+rtOff))));
	f1=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(1+rtOff))));
	f2=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(2+rtOff))));
    f3=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(3+rtOff))));
	f4=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(4+rtOff))));
    f5=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(5+rtOff)))); %expand to accomodate phase shit =1
	f6=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(6+rtOff)))); %expand to accomodate phase shit =2
    f7=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(7+rtOff)))); %expand to accomodate phase shit =3
	f8=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(8+rtOff)))); %expand to accomodate phase shit =4
	y=-f0+f1+f2-f3-f4+f5+f6-f7-f8;


end

