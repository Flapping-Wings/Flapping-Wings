function [ n,w,wi,wf,Lt,Lr,C ] = BStrip( lt,lr,c,delta,h )
%Width of the rectangular elements in the border strips # of rectangular elements on them

%INPUT
%lt     length of the tapered section
%lr     length of the rectangular section
%c      chord length of the lectangular section
%delta  half taper angle (radian)
%h      height of the border strip
%OUTPUT
%n(I)   # of rectangles in the strip  
%w(I)   width of the multiple middle rectangular elements
%wi(I)  width of the first rec element
%wf(I)  width of the last rec element, where I=1:5
%Lt
%Lr
%C
global wfactor
alpha=0.5*(pi-delta);
%Reduced outline length for the center region
Lt   =lt-h*(cot(delta)+cot(alpha));
Lr   =lr-h*(cot(alpha)+1);
C    =c-2.0*h;
%epsilon=1.0E-03; %a small number but gigger than the machine epsilon

%Elongate h by a factor wfactor
wh=wfactor*h;
%border strip 1
%tmp=Lt/wh+epsilon
Lt=Lt+eps;
n(1)=floor(Lt/wh);    %# of rectangles in the strip
r(1)=rem(Lt,wh);
if n(1) ~= 0
    w(1)=wh+r(1)/n(1);   %width of the multiple middle rectangular elements
else
    n(1)=1;
    w(1)=Lt;
end
wi(1)=h*cot(delta); %width of the first rec element
wf(1)=h*cot(alpha); %width of the last rec element

%border strip 2
Lr=Lr+eps;
n(2)=floor(Lr/wh);
r(2)=rem(Lr,wh);
if n(2) ~=0    
    w(2)=wh+r(2)/n(2);
else
    n(2)=1;
    w(2)=Lr;
end
wi(2)=h*cot(alpha);
wf(2)=h;

%border strip 3
C=C+eps; %add the small number eps  to avoid truncation
n(3)=floor(C/wh);
r(3)=rem(C,wh);
if n(3) ~=0    
    w(3)=wh+r(3)/n(3); 
else
    n(3)=1;
    w(3)=C;
end    
wi(3)=h;    
wf(3)=h;

%border strip 4
n(4)=n(2);
w(4)=w(2);
wi(4)=wf(2);
wf(4)=wi(2);

%border strip 5
n(5)=n(1);
w(5)=w(1);
wi(5)=wf(1);
wf(5)=wi(1);
end

