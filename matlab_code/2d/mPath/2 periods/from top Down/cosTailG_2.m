function [y ] = cosTailG_2(t, e)
%cos tail function for an arbitrary time
%cos for 1 period and constant for 1 period (wing stays still at the top)
%motion starts from the top (no other options)

tB=rem(t,4);

    [y]=cosTailB_2(tB);

y=y+e;

end

