
function [ z ] = Camber2( x,y,c,l)
%Calculate z values of the wing, given (x,y)
%INPUT (can be all dimensional or all nondimensional)
% x(j),y(j) x, y coordinates of the node j
% l,c       span, chord lengths

global icamber acamber

% icamber   camber option
% acamber   camber amplitude

switch icamber
    case 0       
        z=zeros(size(x));
    case 1       
        z=acamber*(-(x/(0.5*c)).^2+1);
    case 2        
        z=acamber*(-(y/l).^2+1);
    case 3
        z=acamber*(-(x/(0.5*c)).^2+1).*(-(y/l).^2+1);%This option is not used
    otherwise
        display('Use icamber 1, 2, or 3');
end

end


