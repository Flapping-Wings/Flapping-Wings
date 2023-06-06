function [ y ] = cosTailB(td,nhp,t,rt,tau)
%Basic cos function (0<=t<=4) with a tail (4<=t<=8)
%INPUT
% t(i)  vector
%OUTPUT
% y(i)  vector

st=size(t);
switch td
    case 1
        for i=1:st(2)
            if t(i) <= nhp/2
                y(i)=cos(pi*(t(i)*rt+tau));       
            else
                y(i)=1;
            end
        end
    case 2
        for i=1:st(2)
            if t(i) <= nhp/2
                y(i)=-cos(pi*(t(i)*rt+tau));       
            else
                y(i)=-1;
            end
        end        
end

end

