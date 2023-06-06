function [ xeE] = BRelemLoc(m,wi,w,wf,h)
%Node coordinates of local rectangular edge elements over a border strip
%For each element, the node start at left bottom and rotate clock-wise
% 2   3
%   5 
% 1   4
%x=horizontal, y=vertical directions

%INPUT
%m         # of middle elements 
%wi,w,wf    size of intial, middle and final elements (in y-direction)
%h          height of the all elements (in x-direction)
%OUTPUT
%xeE(j,n,i) j coordinates of the n-th node of i-th edge square elements
%           j=1:2; n=1:5 (5=center poiint); i=1:(m+2)



%Element width array
ww(1)=wi;
ww(2:(m+1))=w;
ww(m+2)=wf;
%y-coordinates array of the center points
y(1)=0.5*wi;
for i=2:(m+1)
    y(i)=wi+(i-1.5)*w;
end
y(m+2)=wi+m*w+0.5*wf;
%coordinates of 5 nodes of elements
xeE=zeros(2,5,(m+2));
%{
for i=1:(m+2)
    xeE(1,1,i)=0.0;
    xeE(1,2,i)=0.0;
    xeE(1,3,i)=h;
    xeE(1,4,i)=h;
    xeE(1,5,i)=0.5*h;
    xeE(2,1,i)=y(i)-0.5*ww(i);
    xeE(2,2,i)=y(i)+0.5*ww(i);
    xeE(2,3,i)=y(i)+0.5*ww(i);   
    xeE(2,4,i)=y(i)-0.5*ww(i);
    xeE(2,5,i)=y(i);    
end
%}

xeE(1,1:2,:)=0.0;
xeE(1,3:4,:)=    h;
xeE(1,5,  :)=0.5*h;
xeE(2,1,  :)=y(:)-0.5*ww(:);
xeE(2,2,  :)=y(:)+0.5*ww(:);
xeE(2,3,  :)=y(:)+0.5*ww(:);   
xeE(2,4,  :)=y(:)-0.5*ww(:);
xeE(2,5,  :)=y(:); 

end

