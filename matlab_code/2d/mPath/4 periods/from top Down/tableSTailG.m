function [ y] = tableSTailG(t, p,rtOff)
%Table function for an arbitrary time
global tau

tB=rem(t,8);
[y]=tableSTailB(tB+tau,p,rtOff);

end

