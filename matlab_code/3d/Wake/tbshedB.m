function [ Xs ] = tbshedB( dt,VBT, VBW,Xb,nXb)
%Shed border elements for nwing wings
%{
INPUT:
    Xb(j,inode,iXb,w)   coordinates for the border element
   VBT(j,inode,iXb,w)   border elem nodes velocity due to total wing elem
   VBW(j,inode,iXb,w)   border elem nodes velocity due to wake elem
   nXb                  # of border elements
OUTPUT:
    Xs(j,inode,iXb,w)   border element coordinates after shedding 
INDEX
   inode                1:4     index of velocity calculation sites for each element
   iXb                  1:nXb   indexof shed vortice elements
   j                    1:3     (x,y,z)
   w                    1:2     right and left wings
%}
global nwing

Xs=zeros(3,4,nXb,nwing);
Xs=Xb+dt*(VBT+VBW); 


end

