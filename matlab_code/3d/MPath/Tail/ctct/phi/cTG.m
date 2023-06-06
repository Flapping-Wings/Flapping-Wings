function [y ] = cTG(nhp,t,rt,tau,e)
%cos tail function for an arbitrary time
%cos (nhp/4; half-period), -1 (nhp/4),cos (nhp/4), +1 (nhp/4)

tB=rem(t,nhp/rt);

    [y]=cTB(nhp,tB,rt,tau);
    y=y+e;
end

