function [ n,w] = center_g6( z,h )
%Center region geometry
%INPUT
%z(1,nside+1)   corner nodes
%h  border      height

%OUTPUT
%n(1,nside+1)   # of border elements in each edge
%w(1,nside+1)   width of middle border elements


global wfactor nside
%Edge length
for n=1:nside
    L(n)=abs(z(n+1)-z(n));
end
L(nside+1)=abs(z(5)-z(2));
%Comparison of facing edge pair length
%L(1)&L(5), L(2)&L(4), L(3)&L(6)&L(7)
%to identify longer edge in each pair
LL(1)=max(L(1),L(5)); %proximal horizontal (sort of) ends
LL(2)=max(L(2),L(4)); %distal horizontal (sort of) ends
LL(3)=max([L(3),L(6),L(7)]); %verical (sort of) ends

%Use the longer edge in each pair to determine the number of border
%elements


%Elongate h by a factor wfactor
wh=wfactor*h;
%border strip pair 1: L(1) & L(5)
Lr1=LL(1)+eps;
nr1=floor(Lr1/wh);    %# of rectangles in the strip
if nr1 == 0
    nr1=1;
end

%border strip pair 2: L(2) & L(4)
Lr2=LL(2)+eps;
nr2=floor(Lr2/wh);
if nr2 == 0
    nr2=1;
end

%border strip pair 3: L(3) & L(6)
C=LL(3)+eps; %add the small number eps  to avoid truncation
nc=floor(C/wh);
if nc == 0
    nc=1;
end

%assigh border element number for each edge
n(1)=nr1;
n(2)=nr2;
n(3)=nc;
n(4)=nr2;
n(5)=nr1;
n(6)=nc;
n(7)=nc;
%Determine the border edge element width
for k=1:nside+1
    w(k)=L(k)/n(k);
end

   
end

