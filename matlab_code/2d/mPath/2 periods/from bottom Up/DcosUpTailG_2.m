function [y ] = cosUpTailG_2(t)
%cos tail function for an arbitrary time
%cos for 1 period and constant for 1 period (wing stays still at the top)
%motion starts from the top (no other options)
%INPUT
% t     time

tB=rem(t,4);
[y]=DcosUpTailB_2(tB);

end

