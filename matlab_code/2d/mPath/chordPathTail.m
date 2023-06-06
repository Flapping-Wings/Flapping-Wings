function [  ] = chordPathTail(t,e,c,a,beta,gMax,p,rtOff, U, V)
%INPUT Variables (all nondimentional)
% t         time
% e         stroke difference
% c         chord length
% a         rotation distance offset 
% beta      stroke angle
% gMax      maximum rotation
% p         rotation velocity parameter 
% rtOff     rotation timing offset 
% U, V      ambient velocity
%==========================================================================
global tau iplot 
%LOCAL Variables

    
    
    %Translational Motion
    [y]=cosTailG(t,e);
    x0=-U*t+0.5*y*cos(beta);
    z0=-V*t+0.5*y*sin(beta);
    
    %Rotational Motion 
    [y]=tableTailG(t,p,rtOff);
    gam=gMax*y;
    
    %Edge positions for the composite motion
    xle=x0+(a-0.5*c)*sin(beta-gam);
    zle=z0-(a-0.5*c)*cos(beta-gam);
    xte=x0+(a+0.5*c)*sin(beta-gam);
    zte=z0-(a+0.5*c)*cos(beta-gam);
   
    if iplot == 1
        f=figure();
        plot([xle; xte],[zle; zte])
        hold on
        plot(x0,z0,'-','LineWidth',2)
        hold off   
        axis equal
        saveas(f,'dVortex/fig/chordPass.tif');
    else if iplot == 2
        plot(t,x0, t,gam);
        grid on
    end
end

