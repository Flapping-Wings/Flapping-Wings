function [ VVspace] = igVELOCITYF(Z,ZV,ZW, GAMA,m,GAMAw,iGAMAw)    
%--------------------------------------------------------------------------
%Calculation of the velocity fields VVspace (wing)=[u v] using the wing-fixed mesh ZETA
%INPUT
% Z         observation points
% ZV     bound vortex location
% ZW        wake vortex location
% a         rotation axis offset
% GAMA      bound vortex
% m         # of bound vortex
% GAMAw     wake vortex
% iGAMAw    # of wake vortices
% U,V       free stream velocity
% alp       airfoil rotation
% dalp,dl,dh    airfoil velocity components
%OUTPUT:
% VVspace   complex velocity in the space-fixed system
% VVwing    complex velocity in the wing-fixed system
%--------------------------------------------------------------------------



% calculate velocity at ZETA mesh points
%    [ii jj]=size(ZETA);
%    for i=1:iGAMAf
%        vel(i)=complex(0.0,0.0);
%        for j=1:m           
%            [velf]=velVortex(GAMA(j),zf(i),zv(j));
%            vel(i)=vel(i)+velf;
%        end
%        for j=1:iGAMAw %skips if iGAMw=0
%            [velf]=velVortex(GAMAw(j),zf(i),zf(j));
%            vel(i)=vel(i)+velf;
%        end
%    end
    
%Initialize the Complex velocity at 
    sz=size(Z);
    VV=complex(0,0)*ones(sz); 
    
%Contribution from the bound vortices       
    for J=1:m
        VV=VV-(0.5*1i/pi)*GAMA(J) ./(Z-ZV(J)); %assume (or HOPE) the denominator is nonzero
    end

%Contribution from the wake vortex  
    for J=1:iGAMAw           
        VV=VV-(0.5*1i/pi)*GAMAw(J)./(Z-ZW(J));           
    end
%Convert the complex velocity to ordinary velocity
    VV=conj(VV);
    VVspace=VV;
    
%{
%Contribution from the free stream (velocity of the airfoil-fixed system is
%NOT included)
    VVspace=VV+exp(1i*alp)*complex(U, V)*ones(sz); 
   
%Contribution from the free stream (velocity of the airfoil-fixed system is
%included)
    VVwing =VV+exp(1i*alp)*complex(U-dl, V-dh)*ones(sz) +1i*(ZETA+a)*dalp;
%}    
end

