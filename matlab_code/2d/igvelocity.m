function [VEL]=igvelocity(ZF,iGAMAf,GAMA,m,ZV,GAMAw,iGAMAw)
%{
Calculates the velocity at free & wake vortex sites in th global system
Note that the ambient air speed is includes, as its negative, in the wing
motion. Thus, the velocity contributions come only from the vortices.
%}
%INPUT
% ZF        sites of vortes to be convected & shed (global suystem)
%iGAMAf     # of vortices to be shed or convected
% GAMA      bound vortex
% m         # of bound vortices
% ZV     location of bound vortices (global)
% GAMAw     wake vortex
% iGAMAw    #of wake vortices
%OUTPUT
% VEL       velocity (not the conjugate) of vortex sites to be convected or shed
    for i=1:iGAMAf
        VEL(i)=complex(0.0,0.0);
        for j=1:m           
            [VELF]=velVortex(GAMA(j),ZF(i),ZV(j));
            VEL(i)=VEL(i)+VELF;
        end
        for j=1:iGAMAw %skips if iGAMw=0
            [VELF]=velVortex(GAMAw(j),ZF(i),ZF(j));
            VEL(i)=VEL(i)+VELF;
        end
        %Air velocity
        %VEL(i)=VEL(i)+complex(U-dl, V-dh);
    end
    


end

