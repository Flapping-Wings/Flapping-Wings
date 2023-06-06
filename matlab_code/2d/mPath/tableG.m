function [ y ] = tableG(t,p,rtOff)
%Table function for an arbitrary time
global tau

tB=rem(t,2);
[y]=tableB(tB+tau,p,rtOff);

end

