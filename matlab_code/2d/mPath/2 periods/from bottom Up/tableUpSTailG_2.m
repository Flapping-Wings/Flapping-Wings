function [ y] =  tableUpSTailG_2(t, p,rtOff)
%Table function with a tail for an arbitrary time
global tau

tB=rem(t,4);
[y]=tableUpSTailB_2(tB+tau,p,rtOff);

end

