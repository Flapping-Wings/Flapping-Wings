function [y ] = cosUpTailG(t)
%cos tail function for an arbitrary time
%cos for 2 period and constant for 2 period (wing stays still at the top)
%motion starts from the top (no other options)
%INPUT
% t     time

tB=rem(t,8);
[y]=DcosUpTailB(tB);

end

