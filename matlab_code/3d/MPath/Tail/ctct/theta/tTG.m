function [ y] = tTG(nhp,t,rt,tau, p,rtOff)
%Table function for an arbitrary time


tB=rem(t,nhp/rt);
[y]=tTB(tB,rt,tau,p,rtOff);

end

