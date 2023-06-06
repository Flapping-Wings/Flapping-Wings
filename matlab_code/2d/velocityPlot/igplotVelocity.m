function [  ] = igplotVelocity( istep,ZV,ZW, a,GAMA,m,GAMAw,iGAMAw,alp,l,h)
%Plot velocity field
% 
%INPUT
% istep     iteration step
% ZV        bound vortex location
% ZW        wake vortex location
% a         rotation axis offset
% GAMA      bound vortex
% m         # of bound vortices
% GAMAw     wake vortices
% iGAMAw    # of wake vortices
% U,V       free flow velocity
% alp       airfoil rotation
% l h       airfoil translation
% dalp, dl, dh  airfoil velocity components
global ZETA  zavoid folder svCont wvCont vpFreq ivCont
% ZETA      mesh points matrix
% zavoid    avoid vortex poits for velocity calculation (slower)
% folder    fig folder path
% svCont, wvCont    speed contour plot velocity range specifier
% vpFreq    frequency of velocity field plot
% ivCont    swich for use of svCpont and wvCont: use them if ivCont ==1

%Airfoil 9/10/2018
    XPLTF  =real(ZV);
    YPLTF  =imag(ZV);

%Plot the velocity field, every vpFreq seps
if rem(istep,vpFreq) == 0
    %Calculate velocity field
    ROT=exp(-1i*alp);
    RZETA=(ZETA+a)*ROT;
    X  =real(RZETA) + l;
    Y  =imag(RZETA) + h;
    Z=complex(X,Y);
    if zavoid == 1 %skip source points that coincides with the observation points (slower)
        [VVspace]=igVELF(Z,ZV,ZW,GAMA,m,GAMAw,iGAMAw);
    else
        [VVspace]=igVELOCITYF(Z,ZV,ZW,GAMA,m,GAMAw,iGAMAw);
    end
    %Plot velocity field in the space-fixed system
  
    
    U  =real(VVspace);
    V  =imag(VVspace);
    S  =sqrt(U.*U+V.*V);
    quiver(X,Y,U,V)
    hold on; %9/10/2018
    plot(XPLTF, YPLTF, '-k'); %9/10/2018
    hold off; %9/10/2018
    print('-dbmp',[folder 'velocity/' 'spaceVelocity_' num2str(istep) '.bmp']);
    close;
    if ivCont == 1
        contourf(X,Y,S,svCont);
    else
        contourf(X,Y,S);
    end
    colorbar;
    hold on; %9/10/2018
    plot(XPLTF, YPLTF, '-k'); %9/10/2018
    hold off; %9/10/2018
    print('-dbmp',[folder 'velocity/' 'spaceSpeed_' num2str(istep) '.bmp']);
    close;
    
    
end
end

