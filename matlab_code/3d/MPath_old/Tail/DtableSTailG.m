function [ ] = DtableSTailG(td,nhp,t,rt,tau, p,rtOff)
%Table function with a tail for an arbitrary time


tB=rem(t,nhp/rt);
[y]=DtableSTailB(td,nhp,tB,rt,tau,p,rtOff);

end

