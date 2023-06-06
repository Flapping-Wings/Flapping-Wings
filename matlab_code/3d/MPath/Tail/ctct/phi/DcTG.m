function [y ] = DcTG(nhp,t,rt,tau)
%cos tail function for an arbitrary time
%cos (nhp/4; half-period), -1 (nhp/4),cos (nhp/4), +1 (nhp/4)

tB=rem(t,nhp/rt);

    [y]=DcTB(nhp,tB,rt,tau);

end

