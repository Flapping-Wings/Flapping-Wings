function [ VN] = igairfoilV(ZC,ZCt, NC, t,dl,dh,dalp)
%Get the velocity of the airfoil in the global system
%The velocity is needed at the airfoil collocation points (xc, yc)
%==========================================================================
%INPUT VARIABLES
% dl, dh            velocity of the translating system
% dalp         airfoil angle and angular velocity
% ZC    (1,m-1) collocation points (global system)
% ZCt    (1,m-1) collocation points (translational system)
% NC        (1,m-1) unit normal at collocation points ((global/translational)
%OUTPIT
% VN        normal velocity (1,m-1)

global vplot folder
%Airfoil velocity (complex valued) at the colocation points
    V=complex(dl,dh)-1i*dalp*ZCt;

%Normal velocity component of the airfoil (global)
    VN=real(conj(V).*NC);
 
    if vplot == 1
        %End points for the normal velocity vector
        sf=0.025; %scale factor for the velocity plot
        xc=real(ZC);
        yc=imag(ZC);
        nx=real(NC);
        ny=imag(NC);
        xaif=xc;
        yaif=yc;
        xtip=xc+sf*VN.*nx;
        ytip=yc+sf*VN.*ny;
        %Plot normal velocity vectors at collocation points     
        f=figure();
        plot([xaif; xtip],[yaif; ytip])
        hold on
        plot(xc,yc,'o')
        hold off   
        axis equal               
        saveas(f,[folder 'AirfoilVg_' num2str(t) '.tif']);        
    end

end

