
function [ y ] = dpDtableG(t,rt,tau,p,rtOff)
%Table function for an arbitrary time


tB=rem(t,2.0/rt);
[y]=dpDtableB(tB,rt,tau,p,rtOff);

end

