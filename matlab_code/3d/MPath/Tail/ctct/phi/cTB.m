function [ y ] = cTB(nhp,t,rt,tau)
%cos tail function 0<=t<=nhp
%cos (nhp/4; half-period), -1 (nhp/4),cos (nhp/4), +1 (nhp/4)

%INPUT
% t(i)  vector
%OUTPUT
% y(i)  vector

st=size(t);

for i=1:st(2)
    time=t(i)*rt+tau;
    if      time <= nhp/4
        y(i)=cos(pi*(time));       
    elseif time <= nhp/2
        y(i)=-1;
    elseif time <= 3*nhp/4
        y(i)=cos(pi*(time-1));
    elseif time <= nhp    
        y(i)=+1;
    elseif time <= 5*nhp/4      %double the time to axccomodate 0<tau<nhp
        y(i)=cos(pi*(time));
    elseif time <= 3*nhp/2      %double the time to axccomodate 0<tau<nhp
        y(i)=-1;
    elseif time <= 7*nhp/4      %double the time to axccomodate 0<tau<nhp
        y(i)=cos(pi*(time-1));
    elseif time <= 2*nhp        %double the time to axccomodate 0<tau<nhp  
        y(i)=+1;
    end
end


end

