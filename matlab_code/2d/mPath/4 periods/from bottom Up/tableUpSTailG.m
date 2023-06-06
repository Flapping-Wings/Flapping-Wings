function [ y] =  tableUpSTailG(t, p,rtOff)
%Table function with a tail for an arbitrary time
global tau

tB=rem(t,8);
[y]=tableUpSTailB(tB+tau,p,rtOff);

end

