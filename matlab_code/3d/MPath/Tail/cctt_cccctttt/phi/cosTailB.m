function [ y ] = cosTailB(td,nhp,t,rt,tau)
%Basic cos function (0<=t<=nhp/2) with a tail (nhp/2<=t<=nhp)
%EXtend the definition up to 2*nhp to accomodate phase shift tau up to nhp
%INPUT
% t(i)  vector
%OUTPUT
% y(i)  vector

st=size(t);
switch td
    case 1       
        for i=1:st(2)
            time=t(i)*rt+tau;
            if time <= nhp/2
                y(i)=cos(pi*time);       
            elseif time <= nhp
                y(i)=+1;% cos(pi*tau );
            elseif time <= 3*nhp/2
                y(i)=cos(pi*time);
            elseif time <= 2*nhp
                y(i)=+1; %cos(pi*tau );
            end
        end
    case 2
        for i=1:st(2)
            time=t(i)*rt+tau;
            if time <= nhp/2
                y(i)=-cos(pi*time);       
            elseif time <= nhp
                y(i)=-1;%-cos(pi*tau );
            elseif time <= 3*nhp/2
                y(i)=-cos(pi*time);
            elseif time <= 2*nhp
                y(i)=-1;%-cos(pi*tau );
            end
        end        
end

end

