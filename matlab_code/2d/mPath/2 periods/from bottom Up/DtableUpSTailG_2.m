function [y ] = DtableUpSTailG_2(t, p,rtOff)
%Table function with a tail for an arbitrary time
global tau

tB=rem(t,4);
[y]=DtableUpSTailB_2(tB+tau,p,rtOff);

end

