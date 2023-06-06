function [ y ] = DtableG(t,p,rtOff)
%Table function for an arbitrary time
global tau

tB=rem(t,2);
[y]=DtableB(tB+tau,p,rtOff);

end

