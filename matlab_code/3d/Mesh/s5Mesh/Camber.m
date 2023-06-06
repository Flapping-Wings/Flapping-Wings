function [ z ] = Camber( x,y)
%Calculate z values of the wing, given (x,y)
%INPUT ALL LENGTHS DIMENSIONAL
% x(j),y(j) x, y coordinates of the node j


global icamber acamber l_ c_
% l_,c_       span, chord lengths
% icamber   camber option
% acamber   camber amplitude

switch icamber
    case 0       
        z=zeros(size(x));
    case 1       
        z=acamber*(-(x/(0.5*c_)).^2+1);
    case 2        
        z=acamber*(-(y/l_).^2+1);
    case 3
        z=acamber*(-(x/(0.5*c_)).^2+1).*(-(y/l_).^2+1);%This option is not used
    otherwise
        display('Use icamber 1, 2, or 3');
end

end


