function [ y ] = tableSTailB(td,nhp,t,rt,tau, p,rtOff )
%Table function with tail for gamma for nhp/2 periods 0<= t <= nhp
%EXtend the definition up to 2*nhp to accomodate phase shift tau up to nhp
switch td
    case 1
        switch nhp
            case 8
                f0 =1.0./(1.0+exp(-2.0*p*(t*rt+tau-(0.0 +rtOff))));
                f1 =2.0./(1.0+exp(-2.0*p*(t*rt+tau-(1.0 +rtOff))));
                f2 =2.0./(1.0+exp(-2.0*p*(t*rt+tau-(2.0 +rtOff))));
                f3 =2.0./(1.0+exp(-2.0*p*(t*rt+tau-(3.0 +rtOff))));
                f4 =1.0./(1.0+exp(-2.0*p*(t*rt+tau-(4.0 +rtOff))));
                f8 =1.0./(1.0+exp(-2.0*p*(t*rt+tau-(8.0 +rtOff))));
                f9 =2.0./(1.0+exp(-2.0*p*(t*rt+tau-(9.0 +rtOff))));
                f10=2.0./(1.0+exp(-2.0*p*(t*rt+tau-(10.0+rtOff))));
                f11=2.0./(1.0+exp(-2.0*p*(t*rt+tau-(11.0+rtOff))));
                f12=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(12.0+rtOff))));
                f16=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(16.0+rtOff))));
                y=-f0+f1-f2+f3-f4-f8+f9-f10+f11-f12-f16;
            case 4
                f0=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(0.0+rtOff))));
                f1=2.0./(1.0+exp(-2.0*p*(t*rt+tau-(1.0+rtOff))));
                f2=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(2.0+rtOff))));
                f4=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(4.0+rtOff))));
                f5=2.0./(1.0+exp(-2.0*p*(t*rt+tau-(5.0+rtOff))));
                f6=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(6.0+rtOff))));
                f8=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(8.0+rtOff))));
                y=-f0+f1-f2-f4+f5-f6-f8;
        end
    case 2
        switch nhp
            case 8
                f0=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(0.0+rtOff))));
                f1=2.0./(1.0+exp(-2.0*p*(t*rt+tau-(1.0+rtOff))));
                f2=2.0./(1.0+exp(-2.0*p*(t*rt+tau-(2.0+rtOff))));
                f3=2.0./(1.0+exp(-2.0*p*(t*rt+tau-(3.0+rtOff))));
                f4=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(4.0+rtOff))));
                f8=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(8.0+rtOff))));
                f9 =2.0./(1.0+exp(-2.0*p*(t*rt+tau-(9.0 +rtOff))));
                f10=2.0./(1.0+exp(-2.0*p*(t*rt+tau-(10.0+rtOff))));
                f11=2.0./(1.0+exp(-2.0*p*(t*rt+tau-(11.0+rtOff))));
                f12=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(12.0+rtOff))));
                f16=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(16.0+rtOff))));               
                y=f0-f1+f2-f3+f4+f8-f9+f10-f11+f12+f16; 
            case 4
                f0=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(0.0+rtOff))));
                f1=2.0./(1.0+exp(-2.0*p*(t*rt+tau-(1.0+rtOff))));
                f2=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(2.0+rtOff))));
                f4=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(4.0+rtOff))));
                f5=2.0./(1.0+exp(-2.0*p*(t*rt+tau-(5.0+rtOff))));
                f6=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(6.0+rtOff))));
                f8=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(8.0+rtOff))));
                y=-f0+f1-f2-f4+f5-f6-f8;
                y=-y;               
        end
end

end

