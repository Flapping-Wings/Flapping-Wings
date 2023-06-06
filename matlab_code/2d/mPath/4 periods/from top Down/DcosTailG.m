function [y ] = DcosTailG(t)
%cos tail function for an arbitrary time
%cos for 2 period and constant for 2 period (wing stays still at the top)
%motion starts from the top (no other options)

tB=rem(t,8);
[y]=DcosTailB(tB);

end

