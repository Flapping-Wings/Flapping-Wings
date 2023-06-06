function [] = igplotVortexw(iGAMAw,ZV,ZW,istep)
%Plot wake vortices in the space-fixed system
%INPUT
% iGAMAw                # of wake vortices after shedding the free vortices
% ZV                    vortex points on the airfoil
% ZW   (1,2*istep)       complex valued location in the space-fixed system

global folder wplot

%Airfoil
    XPLTF  =real(ZV);
    YPLTF  =imag(ZV);
    
%Wake
if istep ~= 1 %No wake for istep=1
    XPLTW  =real(ZW);
    YPLTW  =imag(ZW);    
end

%Plot and save to a  file
if wplot == 1
    %fig=figure();%deleted 3/26/2018 with Alex
    
    if istep == 1
        %No wake vortex in istep=1.
        plot(XPLTF, YPLTF, '-k');    
        saveas(gcf,[folder 'wake/' 'wake_' num2str(istep) '.tif']);%fig--->gcf (3/26/2018)
    else   
        iodd=1:2:iGAMAw-1;
        ieven=2:2:iGAMAw;
        XPLTWo=XPLTW(iodd);
        YPLTWo=YPLTW(iodd);
        XPLTWe=XPLTW(ieven);
        YPLTWe=YPLTW(ieven);
        %Plot wake vortices from the leading edge black, and from the trailing edge red circles.
        plot(XPLTF, YPLTF, '-k', XPLTWo,YPLTWo, 'ok',XPLTWe,YPLTWe, 'or' );
        %axis([-2,2,-2,2]);%fixes the size of the frame for all plots
        saveas(gcf,[folder 'wake/' 'wake_' num2str(istep-1) '.tif']);%fig--->gcf (3/26/2018)
        %print(gcf,'-dbmp',['fig/wake/' 'wake_' num2str(t) '.bmp']);
    end
    pause(0.01);
end
end

