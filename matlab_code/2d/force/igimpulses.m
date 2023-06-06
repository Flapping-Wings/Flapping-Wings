function [] = igimpulses(istep,ZVt,ZWt,a,GAMA,m,GAMAw,iGAMAw)
%Calculate the linear and angular impulses on the airfoile
%INPUT
% istep     time step
% ZVt     vortex points on theairfoil in the translating system
% ZWt        wake vortex location in the translating system
% a         rotation axis offset
% alp       chord angle
% GAMA      bound vortices
% m         % of bound vortices
% GAMAw     wake vortices
% iGAMAw    # of wake vortices

global impulseLb impulseAb impulseLw impulseAw

%Bound vortex (free vortices excluded)
%Initialize the impulses before adding up
impulseLb(istep)=complex(0,0);
impulseAb(istep)=complex(0,0);
impulseLw(istep)=complex(0,0);
impulseAw(istep)=complex(0,0);
    for I=1:m
        impulseLb(istep)=impulseLb(istep)-1i* GAMA(I)*ZVt(I);
        impulseAb(istep)=impulseAb(istep)-0.5*GAMA(I)*abs(ZVt(I))^2;
    end
%Wake vortex 
    for I=1:iGAMAw  %skips for istep=1 (iGAMAw=0)
        impulseLw(istep)=impulseLw(istep)-1i* GAMAw(I)*ZWt(I); 
        impulseAw(istep)=impulseAw(istep)-0.5*GAMAw(I)*abs(ZWt(I))^2;
    end

end

