function [ Xw ] = tbconvW( dt,VWT, VWW,Xw)
%Convect  wake elements
%{
INPUT:
    Xw(j,inode,iXw,w)   coordinates of the wake elements before convecting
   VWT(j,inode,iXw,w)   velocity at wake elem nodes due to total wing elem
   VWW(j,inode,iXw,w)   velocity at wake elem nodes due to wake elem
OUTPUT:
    Xw(j,inode,iXw,w)   coordinate of the wake element after convecting 
INDEX:
   inode                1:4     index of velocity calculation sites for each element
   iXw                  1:nXw   indexof wake vortice elements
   j                    1:3     (x,y,z)
   w                    1(right), 2(left) wing
%}

Xw=Xw+dt*(VWT+VWW); 

end

