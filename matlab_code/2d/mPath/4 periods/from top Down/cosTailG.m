function [y ] = cosTailG(t, e)
%cos tail function for an arbitrary time
%cos for 2 period and constant for 2 period (wing stays still at the top)
%motion starts from the top (no other options)

tB=rem(t,8);

    [y]=cosTailB(tB);

y=y+e;
%plot(t,y);
%axis([-0.1 tf+0.1 -1 1+e+0.1]);
%grid on



end

