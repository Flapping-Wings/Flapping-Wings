function [  ] = wingPath(t,e,c,a,beta,gMax,p,rtOff, U, V,W,phiT,phiB,l,AZ,EL)
%Wing motion path for cambered wing
%INPUT Variables (all nondimentional)
% t         time
% e         stroke difference
% c         chord length
% a         rotation distance offset 
% beta      stroke angle
% gMax      maximum rotation
% p         rotation velocity parameter 
% rtOff     rotation timing offset 
% U, V,W      ambient velocity
% phiT,phiB top and bottom stroke angles
% l         wing span
% AZ,EL     3dplot view
%==========================================================================
global tau iplot folder 
%LOCAL Variables
    sump=phiT-phiB;

    %Rolling Motion
    
    phi=0.5*sump*(cos(pi*(t+tau))+e);
    
    %Rotational Motion 
    [f]=tableG(t,p,rtOff);
    theta=gMax*f;
    %Edge positions of the tip code for the composite motion
    x0L=-0.5*c; x0T=+0.5*c; x0C=0.0;
    y0L=l;      y0T=l;      y0C=l;
    [z0L]=Camber2(x0L,y0L,c,l);
    [z0T]=Camber2(x0T,y0T,c,l);
    [z0C]=Camber2(x0C,y0C,c,l);
    [ XL,YL,ZL,XT,YT,ZT,XC,YC,ZC ] = wingMotion(a, x0L,x0T,x0C,y0L,y0T,y0C,z0L,z0T,z0C,theta,phi,beta );
    
    %Edge positions of the base code for the composite motion
    x0L=-0.5*c; x0T=+0.5*c; x0C=0.0;
    y0L=0;      y0T=0;      y0C=0;
    [z0L]=Camber2(x0L,y0L,c,l);
    [z0T]=Camber2(x0T,y0T,c,l);
    [z0C]=Camber2(x0C,y0C,c,l);
    [ XLB,YLB,ZLB,XTB,YTB,ZTB,XCB,YCB,ZCB ] = wingMotion(a, x0L,x0T,x0C,y0L,y0T,y0C,z0L,z0T,z0C,theta,phi,beta );
    
    %Add effect of the ambient air velocity
    [XL,ZL,YL] = translate(XL,ZL,YL,t,U,V,W);
    [XT,ZT,YT] = translate(XT,ZT,YT,t,U,V,W);
    [XC,ZC,YC] = translate(XC,ZC,YC,t,U,V,W);
    [XLB,ZLB,YLB] = translate(XLB,ZLB,YLB,t,U,V,W);
    [XTB,ZTB,YTB] = translate(XTB,ZTB,YTB,t,U,V,W);
    [XCB,ZCB,YCB] = translate(XCB,ZCB,YCB,t,U,V,W);
    
    
   
    if iplot == 1
        f=figure();
        plot3([XL; XT;XTB;XLB;XL],[YL; YT;YTB;YLB;YL],[ZL; ZT;ZTB;ZLB;ZL]);
        hold on;
        plot3(XC, YC, ZC, '-','LineWidth',2);
        plot3(XCB,YCB,ZCB,'r-','LineWidth',2);
        view(AZ,EL);
        hold on;   
        axis equal;  
        grid on;
        saveas(f,[folder,'pass/chordPassR.fig']);
        close;
    end
end

