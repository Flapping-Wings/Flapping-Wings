function [ ] = DtableSTailG(t, p,rtOff)
%Table function with a tail for an arbitrary time
global tau

tB=rem(t,8);
[y]=DtableSTailB(tB+tau,p,rtOff);

end

