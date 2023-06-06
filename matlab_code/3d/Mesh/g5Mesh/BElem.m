function [Xb,nXb ] = BElem(Z12,Z23,Z34,Z45,Z51,z12,z23,z34,z45,z51)
%Border element node coordinates
%INPUT
%Zij    outer contour edge ij subnodes
%zij    inner contour ij subnodes

%OUTPUT
%Xb     Border element coordinates
ii=1;
%For edge 12
s=size(Z12);
for i=1:(s(2)-1)
    Xb(1,1,ii)=real(Z12(i));
    Xb(2,1,ii)=imag(Z12(i));
    Xb(1,2,ii)=real(Z12(i+1));
    Xb(2,2,ii)=imag(Z12(i+1));
    Xb(1,3,ii)=real(z12(i+1));
    Xb(2,3,ii)=imag(z12(i+1));
    Xb(1,4,ii)=real(z12(i));
    Xb(2,4,ii)=imag(z12(i));
    ii=ii+1;
    
end
%For edge 23
s=size(Z23);
for i=1:(s(2)-1)
    Xb(1,1,ii)=real(Z23(i));
    Xb(2,1,ii)=imag(Z23(i));
    Xb(1,2,ii)=real(Z23(i+1));
    Xb(2,2,ii)=imag(Z23(i+1));
    Xb(1,3,ii)=real(z23(i+1));
    Xb(2,3,ii)=imag(z23(i+1));
    Xb(1,4,ii)=real(z23(i));
    Xb(2,4,ii)=imag(z23(i));
    ii=ii+1;
end
%For edge 34
s=size(Z34);
for i=1:(s(2)-1)
    Xb(1,1,ii)=real(Z34(i));
    Xb(2,1,ii)=imag(Z34(i));
    Xb(1,2,ii)=real(Z34(i+1));
    Xb(2,2,ii)=imag(Z34(i+1));
    Xb(1,3,ii)=real(z34(i+1));
    Xb(2,3,ii)=imag(z34(i+1));
    Xb(1,4,ii)=real(z34(i));
    Xb(2,4,ii)=imag(z34(i));
    ii=ii+1;
end
%For edge 45
s=size(Z45);
for i=1:(s(2)-1)
    Xb(1,1,ii)=real(Z45(i));
    Xb(2,1,ii)=imag(Z45(i));
    Xb(1,2,ii)=real(Z45(i+1));
    Xb(2,2,ii)=imag(Z45(i+1));
    Xb(1,3,ii)=real(z45(i+1));
    Xb(2,3,ii)=imag(z45(i+1));
    Xb(1,4,ii)=real(z45(i));
    Xb(2,4,ii)=imag(z45(i));
    ii=ii+1;
end
%For edge 51
s=size(Z51);
for i=1:(s(2)-1)
    Xb(1,1,ii)=real(Z51(i));
    Xb(2,1,ii)=imag(Z51(i));
    Xb(1,2,ii)=real(Z51(i+1));
    Xb(2,2,ii)=imag(Z51(i+1));
    Xb(1,3,ii)=real(z51(i+1));
    Xb(2,3,ii)=imag(z51(i+1));
    Xb(1,4,ii)=real(z51(i));
    Xb(2,4,ii)=imag(z51(i));
    ii=ii+1;
end

Xb(:,5,:)=0.25*(Xb(:,1,:)+Xb(:,2,:)+Xb(:,3,:)+Xb(:,4,:));

s=size(Xb);
nXb=s(3);



end

