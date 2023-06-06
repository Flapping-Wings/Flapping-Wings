function [ y ] = tableSTailB(td,nhp,t,rt,tau, p,rtOff )
%Table function with tail for gamma fot 4 periods 0<= t <= 8
switch td
    case 1
        switch nhp
            case 8
                f0=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(0.0+rtOff))));
                f1=2.0./(1.0+exp(-2.0*p*(t*rt+tau-(1.0+rtOff))));
                f2=2.0./(1.0+exp(-2.0*p*(t*rt+tau-(2.0+rtOff))));
                f3=2.0./(1.0+exp(-2.0*p*(t*rt+tau-(3.0+rtOff))));
                f4=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(4.0+rtOff))));
                f8=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(8.0+rtOff))));
                y=-f0+f1-f2+f3-f4-f8;
            case 4
                f0=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(0.0+rtOff))));
                f1=2.0./(1.0+exp(-2.0*p*(t*rt+tau-(1.0+rtOff))));
                f2=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(2.0+rtOff))));
                f4=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(4.0+rtOff))));
                y=-f0+f1-f2-f4;
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
                y=f0-f1+f2-f3+f4+f8; 
            case 4
                f0=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(0.0+rtOff))));
                f1=2.0./(1.0+exp(-2.0*p*(t*rt+tau-(1.0+rtOff))));
                f2=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(2.0+rtOff))));
                f4=1.0./(1.0+exp(-2.0*p*(t*rt+tau-(4.0+rtOff))));
                y=-f0+f1-f2-f4;
                y=-y;               
        end
end

end

