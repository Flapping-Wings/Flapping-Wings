function [ uN ] = uNormal( x,y,z )
%Calculte the unit normal to the rectangular element
% 2   3
%
% 1   4
%x horizontal, y vertical
%INPUT
% x(n),y(n),z(n)     coordinates of the n nodes of the element 
%OUTPUT
% uN        unit normal to the rectangular plane
node=zeros(4,3);
for n=1:4
    node(n,:)=[x(n),y(n),z(n)];  %(:)=1:3
end
N=cross(node(3,:)-node(1,:),node(2,:)-node(4,:));
magN=norm(N);
uN=N/magN;
uN=uN'; %column vector
end

