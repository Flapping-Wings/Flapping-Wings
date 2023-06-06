function [ZW]=igconvect(ZF,VELF,dt,iGAMAf)
%Convect vortex from ZF to ZW using the velocity VELF*df
%INPUT
% ZF    location of the vortex
% VELF  velocity at the vortex
% dt    time interval
% iGAMAf    # of vortices to be convected
%OUTPUT
% ZW    location of the vortex after convection
    for i=1:iGAMAf
        ZW(i)=ZF(i)+VELF(i)*dt;
    end


end

