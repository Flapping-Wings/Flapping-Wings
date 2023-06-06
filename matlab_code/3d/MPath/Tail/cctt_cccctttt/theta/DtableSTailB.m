function [ y ] = DtableSTailB(td,nhp,t,rt,tau, p,rtOff )
%Table function with a tail for gamma fot nhp periods 0<= t <= nhp
%EXtend the definition up to 2*nhp to accomodate phase shift tau up to nhp
switch td
    case 1
        switch nhp
            case 8
                e0=exp(-2.0*p*(t*rt+tau-(0.0+rtOff)));    
                e1=exp(-2.0*p*(t*rt+tau-(1.0+rtOff)));    
                e2=exp(-2.0*p*(t*rt+tau-(2.0+rtOff)));   
                e3=exp(-2.0*p*(t*rt+tau-(3.0+rtOff)));
                e4=exp(-2.0*p*(t*rt+tau-(4.0+rtOff)));   
                e8=exp(-2.0*p*(t*rt+tau-(8.0+rtOff)));
                e9=exp(-2.0*p*(t*rt+tau-(9.0+rtOff)));    
                e10=exp(-2.0*p*(t*rt+tau-(10.0+rtOff)));   
                e11=exp(-2.0*p*(t*rt+tau-(11.0+rtOff)));
                e12=exp(-2.0*p*(t*rt+tau-(12.0+rtOff)));   
                e16=exp(-2.0*p*(t*rt+tau-(16.0+rtOff)));
                f0=2.0*p*e0./(1.0+e0).^2;
                f1=4.0*p*e1./(1.0+e1).^2;
                f2=4.0*p*e2./(1.0+e2).^2;
                f3=4.0*p*e3./(1.0+e3).^2;
                f4=2.0*p*e4./(1.0+e4).^2;
                f8=2.0*p*e8./(1.0+e8).^2;
                f9=4.0*p*e9./(1.0+e9).^2;
                f10=4.0*p*e10./(1.0+e10).^2;
                f11=4.0*p*e11./(1.0+e11).^2;
                f12=2.0*p*e12./(1.0+e12).^2;
                f16=2.0*p*e16./(1.0+e16).^2;
                y=-f0+f1-f2+f3-f4-f8+f9-f10+f11-f12-f16;
            case 4
                e0=exp(-2.0*p*(t*rt+tau-(0.0+rtOff)));    
                e1=exp(-2.0*p*(t*rt+tau-(1.0+rtOff)));    
                e2=exp(-2.0*p*(t*rt+tau-(2.0+rtOff)));   
                e4=exp(-2.0*p*(t*rt+tau-(4.0+rtOff)));   
                e5=exp(-2.0*p*(t*rt+tau-(5.0+rtOff)));    
                e6=exp(-2.0*p*(t*rt+tau-(6.0+rtOff)));   
                e8=exp(-2.0*p*(t*rt+tau-(8.0+rtOff)));   
  
                f0=2.0*p*e0./(1.0+e0).^2;
                f1=4.0*p*e1./(1.0+e1).^2;
                f2=2.0*p*e2./(1.0+e2).^2;
                f4=2.0*p*e4./(1.0+e4).^2;
                f5=4.0*p*e5./(1.0+e5).^2;
                f6=2.0*p*e6./(1.0+e6).^2;
                f8=2.0*p*e8./(1.0+e8).^2;
                y=-f0+f1-f2-f4+f5-f6-f8;
        end
    case 2
        switch nhp
            case 8
                 e0=exp(-2.0*p*(t*rt+tau-(0.0+rtOff)));    
                e1=exp(-2.0*p*(t*rt+tau-(1.0+rtOff)));    
                e2=exp(-2.0*p*(t*rt+tau-(2.0+rtOff)));   
                e3=exp(-2.0*p*(t*rt+tau-(3.0+rtOff)));
                e4=exp(-2.0*p*(t*rt+tau-(4.0+rtOff)));   
                e8=exp(-2.0*p*(t*rt+tau-(8.0+rtOff)));
                e9=exp(-2.0*p*(t*rt+tau-(9.0+rtOff)));    
                e10=exp(-2.0*p*(t*rt+tau-(10.0+rtOff)));   
                e11=exp(-2.0*p*(t*rt+tau-(11.0+rtOff)));
                e12=exp(-2.0*p*(t*rt+tau-(12.0+rtOff)));   
                e16=exp(-2.0*p*(t*rt+tau-(16.0+rtOff)));
                f0=2.0*p*e0./(1.0+e0).^2;
                f1=4.0*p*e1./(1.0+e1).^2;
                f2=4.0*p*e2./(1.0+e2).^2;
                f3=4.0*p*e3./(1.0+e3).^2;
                f4=2.0*p*e4./(1.0+e4).^2;
                f8=2.0*p*e8./(1.0+e8).^2;
                f9=4.0*p*e9./(1.0+e9).^2;
                f10=4.0*p*e10./(1.0+e10).^2;
                f11=4.0*p*e11./(1.0+e11).^2;
                f12=2.0*p*e12./(1.0+e12).^2;
                f16=2.0*p*e16./(1.0+e16).^2;
                y=-f0+f1-f2+f3-f4-f8+f9-f10+f11-f12-f16;
                y=-y;
            case 4
                e0=exp(-2.0*p*(t*rt+tau-(0.0+rtOff)));    
                e1=exp(-2.0*p*(t*rt+tau-(1.0+rtOff)));    
                e2=exp(-2.0*p*(t*rt+tau-(2.0+rtOff)));   
                e4=exp(-2.0*p*(t*rt+tau-(4.0+rtOff)));   
                e5=exp(-2.0*p*(t*rt+tau-(5.0+rtOff)));    
                e6=exp(-2.0*p*(t*rt+tau-(6.0+rtOff)));   
                e8=exp(-2.0*p*(t*rt+tau-(8.0+rtOff)));   
  
                f0=2.0*p*e0./(1.0+e0).^2;
                f1=4.0*p*e1./(1.0+e1).^2;
                f2=2.0*p*e2./(1.0+e2).^2;
                f4=2.0*p*e4./(1.0+e4).^2;
                f5=4.0*p*e5./(1.0+e5).^2;
                f6=2.0*p*e6./(1.0+e6).^2;
                f8=2.0*p*e8./(1.0+e8).^2;
                y=-f0+f1-f2-f4+f5-f6-f8;
                y=-y;  
        end
end
                
                
end

