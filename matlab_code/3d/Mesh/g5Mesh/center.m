function [ n,w] = center( z,h )
%Center region geometry
%INPUT
%z  corner nodes
%h  border height

%OUTPUT
%n(k)   # of border elements in each edge
%w(k)   width of middle border elements
%wi(k)  width of first border element
%wf(k)  width of last border element

global wfactor
%Edge length
for n=1:5
    L(n)=abs(z(n+1)-z(n));
end
L(6)=abs(z(5)-z(2));
%Comparison of facing edge pair length
%L(1)&L(5), L(2)&L(4), L(3),L(6)
%to identify longer edge in each pair
LL(1)=max(L(1),L(5)); %along the tapered (sort of) ends
LL(2)=max(L(2),L(4)); %horizontal (sort of) ends
LL(3)=max(L(3),L(6)); %verical (sort of) ends

%Use the longer edge in each pair to determine the number of border
%elements


%Elongate h by a factor wfactor
wh=wfactor*h;
%border strip pair 1: L(1) & L(5)
Lt=LL(1)+eps;
nt=floor(Lt/wh);    %# of rectangles in the strip
if nt == 0
    nt=1;
end

%border strip pair 2: L(2) & L(4)
Lr=LL(2)+eps;
nr=floor(Lr/wh);
if nr == 0
    nr=1;
end

%border strip pair 3: L(3) & L(6)
C=LL(3)+eps; %add the small number eps  to avoid truncation
nc=floor(C/wh);
if nc == 0
    nc=1;
end

%assigh border element number for each edge
n(1)=nt;
n(2)=nr;
n(3)=nc;
n(4)=nr;
n(5)=nt;
n(6)=nc;

%Determine the border edge element width
for k=1:6
    w(k)=L(k)/n(k);
end

%Determine the first & last corner element length
%{
for k=1:5
    wi(k)=h*cot(delta(k)); %width of the first rec element
    wf(k)=h*cot(delta(k+1)); %width of the last rec element
end
%delta corner angle parameter
%}
    


end

