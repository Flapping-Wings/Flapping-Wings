function [ n,w,wi,wf,Lt,Lr,C ] = BStripElongated( lt,lr,c,delta,h )
%Width of the rectangular elements in the border strips 
%# of rectangular elements on them is fixed to be determined by the # for the tip border
%
%INPUT
%lt     length of the tapered section
%lr     length of the rectangular section
%c      chord length of the lectangular section
%delta  half taper angle (radian)
%h      height of the border strip
%OUTPUT
%n(I)   # of rectangles in the strips  
%w(I)   width of the multiple middle rectangular elements
%wi(I)  width of the first rec element
%wf(I)  width of the last rec element, where I=1:5
%Lt
%Lr
%C


altha=0.5*(pi-delta);
Lt=lt-h*(cot(delta)+cot(altha));
Lr=lr-h*(cot(altha)+1);
C=c-2.0*h;
%border strip 3
tmp=C/h+eps; %add the smallest number eps (machine epsilon) to avoid truncation
n(3)=floor(tmp);
r=rem(C,h);
w(3)=h+r/n(3);     
wi(3)=h;    
wf(3)=h;
%border strip 1
n(1)=n(3);
w(1)=Lt/n(1);   %width of the multiple middle rectangular elements
wi(1)=h*cot(delta); %width of the first rec element
wf(1)=h*cot(altha); %width of the last rec element

%border strip 2
n(2)=n(3);
w(2)=Lr/n(2);
wi(2)=h*cot(altha);
wf(2)=h;

%border strip 4
n(4)=n(3);
w(4)=w(2);
wi(4)=wf(2);
wf(4)=wi(2);

%border strip 5
n(5)=n(3);
w(5)=w(1);
wi(5)=wf(1);
wf(5)=wi(1);
end

