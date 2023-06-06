function [X,Z,Y] = tbtranslate(X,Z,Y,t,U,V,W,b,delta)
%translation of the loction
%INPUT
% X,Z,Y     position
% U,V,W     air speed (constant)
% t         time
% b         wing offset
% delta     body angle

X=X-U*t+b*cos(delta);
Y=Y-V*t;
Z=Z-W*t-b*sin(delta);



end

