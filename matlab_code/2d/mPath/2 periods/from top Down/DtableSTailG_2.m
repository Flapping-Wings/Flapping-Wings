function [y ] = DtableSTailG_2(t, p,rtOff)
%Table function with a tail for an arbitrary time
global tau

tB=rem(t,4);
[y]=DtableSTailB_2(tB+tau,p,rtOff);

end

