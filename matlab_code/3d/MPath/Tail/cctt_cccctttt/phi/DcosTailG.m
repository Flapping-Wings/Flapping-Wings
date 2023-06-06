function [y ] = DcosTailG(td,nhp,t,rt,tau)
%cos tail function derivative for an arbitrary time
%cos for nhp/4 period and constant for nhp/4 period 
%td=1 motion starts from the top , (wing stays still at the top)
%td=2 motion starts from the bottom , (wing stays still at the bottom)
tB=rem(t,nhp/rt);

[y]=DcosTailB(td,nhp,tB,rt,tau);

end

