function [Z12,Z23,Z34,Z45,Z56,Z61 ] = borderSN_g6(h,alpha,zeta,z12,z23,z34,z45,z56,z61 )
%Borde edge sub nodes
%INPUT
%h
%alpha  slope of the outside contour edges
%zeta   outer contour nodes
%zij    subnodes along offst contour ij
%OUTPUT
%Zij    subnodes along the outer contour
global nplot
%For border strip 12
s=size(z12);
Z12(1)=zeta(1);
for k=2:(s(2)-1)
    Z12(k)=z12(k)+h*exp(1i*(alpha(1)+0.5*pi));
end
Z12(s(2))=zeta(2);
if nplot ==1
    plot(real(Z12),imag(Z12),'x');
    hold on;
end

%For border strip 23
s=size(z23);
Z23(1)=zeta(2);
for k=2:(s(2)-1)
    Z23(k)=z23(k)+h*exp(1i*(alpha(2)+0.5*pi));
end
Z23(s(2))=zeta(3);
if nplot ==1
    plot(real(Z23),imag(Z23),'x');
    hold on;
end

%For border strip 34
s=size(z34);
Z34(1)=zeta(3);
for k=2:(s(2)-1)
    Z34(k)=z34(k)+h*exp(1i*(alpha(3)+0.5*pi));
end
Z34(s(2))=zeta(4);
if nplot ==1
    plot(real(Z34),imag(Z34),'x');
    hold on;
end

%For border strip 45
s=size(z45);
Z45(1)=zeta(4);
for k=2:(s(2)-1)
    Z45(k)=z45(k)+h*exp(1i*(alpha(4)+0.5*pi));
end
Z45(s(2))=zeta(5);
if nplot ==1
    plot(real(Z45),imag(Z45),'x');
    hold on;
end

%For border strip 56
s=size(z56);
Z56(1)=zeta(5);
for k=2:(s(2)-1)
    Z56(k)=z56(k)+h*exp(1i*(alpha(5)+0.5*pi));
end
Z56(s(2))=zeta(6);
if nplot ==1
    plot(real(Z56),imag(Z56),'x');
    hold on;
end

%For border strip 61
s=size(z61);
Z61(1)=zeta(6);
for k=2:(s(2)-1)
    Z61(k)=z61(k)+h*exp(1i*(alpha(6)+0.5*pi));
end
Z61(s(2))=zeta(1);
if nplot ==1
    plot(real(Z61),imag(Z61),'x');
    hold on;
end

end

