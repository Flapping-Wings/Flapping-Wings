function [  ] = chordPath_d(t,e,c,a,beta,gMax,p,rtOff, U, V)
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
global tau iplot folder
%LOCAL Variables

    %Translational Motion
    x0=-U*t+0.5*(cos(pi*(t+tau))+e)*cos(beta);
    z0=-V*t+0.5*(cos(pi*(t+tau))+e)*sin(beta);
    
    %Rotational Motion 
    [y]=tableG(t,p,rtOff);
    gam=gMax*y;
    
    %Edge positions for the composite motion
    xle=x0+(a-0.5*c)*sin(beta-gam);
    zle=z0-(a-0.5*c)*cos(beta-gam);
    xte=x0+(a+0.5*c)*sin(beta-gam);
    zte=z0-(a+0.5*c)*cos(beta-gam);
   
    switch iplot
        case 0
        case 1 
            f=figure();
            plot([xle; xte],[zle; zte]);
            hold on
            plot(x0,z0,'-','LineWidth',2)
            hold off;   
            axis equal;
            saveas(f,'fig/chordPass.tif');
        case  2
            f=figure();
            plot(xle,zle,'r',xte,zte,'b');
            hold on
            plot(x0,z0,'k','LineWidth',2)
            hold off   
            axis equal
            saveas(f,'fig/chordPass.tif');
        otherwise
            
    end
end

