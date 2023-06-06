function [z  ] = offset(h, l,alpha,zeta )
%Inside offset contour

%INPUT
%h  offst amount

%OUTPUT
%z  node points coordinat
global cplot


alpha(6)=alpha(1);

for n=1:5
    dalpha=alpha(n)-alpha(n+1);
    if dalpha ~= 0
        r=l(n)-h*(1.0-cos(dalpha))/sin(dalpha);
    else
        r=l(n);
    end
    z(n)=zeta(n)-1i*h*exp(1i*alpha(n))+r*exp(1i*alpha(n));
end

%rearrange z
ind=[5 1 2 3 4];
z=z(ind);
z(6)=z(1);
if cplot ==1
    x=real(z);
    y=imag(z);
    plot(x,y,'-or');
    hold on;
end

end

