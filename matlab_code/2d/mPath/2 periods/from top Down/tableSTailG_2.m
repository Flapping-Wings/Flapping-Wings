function [ y] = tableSTailG_2(t, p,rtOff)
%Table function for an arbitrary time
global tau

tB=rem(t,4);
[y]=tableSTailB_2(tB+tau,p,rtOff);

end

