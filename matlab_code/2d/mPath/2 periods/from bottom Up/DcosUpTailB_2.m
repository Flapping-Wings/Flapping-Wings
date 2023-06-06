function [ y ] = DcosUpTailB_2(t)
%Basic cos function (0<=t<=2) with a tail (2<=t<=4)

    if t <= 2.0
        y=pi*sin(pi*t);
    else
        y=0;
    end
end

