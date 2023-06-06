function [y ] = cosTailG(td,nhp,t,rt,tau, e)
%cos tail function for an arbitrary time
%cos for nhp/4 period and constant for nhp/4 period 
%td=1 motion starts from the top , (wing stays still at the top)
%td=2 motion starts from the bottom , (wing stays still at the bottom)
tB=rem(t,nhp/rt);

    [y]=cosTailB(td,nhp,tB,rt,tau);

y=y+e;

end

