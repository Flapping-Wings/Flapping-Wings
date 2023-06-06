function [  ] = tbwingPathNCL(iwing,t,rt,e,c,a,b,beta,delta,gMax,p,rtOff,tau, U, V,W,phiT,phiB,l,AZ,EL)
%Wing path For left wing
%INPUT Variables (all nondimentional)
% iwing     wing numbering (2 or 4)
% t         time
% rt        period ratio
% e         stroke difference
% c         chord length
% a         rotation distance offset 
% b         wing offset
% beta      stroke angle
% delta     body angle
% gMax      maximum rotation
% p         rotation velocity parameter 
% rtOff     rotation timing offset 
% tau       phase shift
% U, V,W      ambient velocity
% phiT,phiB top and bottom stroke angles
% l         wing span
% AZ,EL     3dplot view  
%==========================================================================
global iplot folder gid
%LOCAL Variables
    sump=phiT-phiB;

    %Rolling Motion
    
    phi=0.5*sump*(cos(pi*(t*rt+tau))+e);

    
    %Rotational Motion 
    [ f ] = dpDtableG(t,rt,tau,p,rtOff);
    theta=gMax*f;

    %Effective flap plane angle considering the body angle
    beta=beta-delta;
    
    %Edge positions of the tip code for the composite motion
    x0L=-0.5*c;
    x0T=+0.5*c;
    x0C=0.0;
    y0L=l;
    y0T=l;
    y0C=l;
    [ XL,YL,ZL,XT,YT,ZT,XC,YC,ZC ] = wingMotionNC(a, x0L,x0T,x0C,y0L,y0T,y0C,theta,phi,beta );
    %Change the sign of y-components
    YL=-YL;
    YT=-YT;
    YC=-YC;
    
    %Edge positions of the base code for the composite motion
    x0L=-0.5*c;
    x0T=+0.5*c;
    x0C=0.0;
    y0L=0;
    y0T=0;
    y0C=0;
    [ XLB,YLB,ZLB,XTB,YTB,ZTB,XCB,YCB,ZCB ] = wingMotionNC(a, x0L,x0T,x0C,y0L,y0T,y0C,theta,phi,beta );
    %Change the sign of y-components
    YLB=-YLB;
    YTB=-YTB;
    YCB=-YCB;
    
    %Add effect of the ambient air velocity
    [XL,ZL,YL] = tbtranslate(XL,ZL,YL,t,U,V,W,b,delta);
    [XT,ZT,YT] = tbtranslate(XT,ZT,YT,t,U,V,W,b,delta);
    [XC,ZC,YC] = tbtranslate(XC,ZC,YC,t,U,V,W,b,delta);
    [XLB,ZLB,YLB] = tbtranslate(XLB,ZLB,YLB,t,U,V,W,b,delta);
    [XTB,ZTB,YTB] = tbtranslate(XTB,ZTB,YTB,t,U,V,W,b,delta);
    [XCB,ZCB,YCB] = tbtranslate(XCB,ZCB,YCB,t,U,V,W,b,delta);
    
    
   
    if iplot == 1
        %gid=figure();
        plot3([XL; XT;XTB;XLB;XL],[YL; YT;YTB;YLB;YL],[ZL; ZT;ZTB;ZLB;ZL]);
        hold on;
        plot3(XC, YC, ZC, '-','LineWidth',2);
        plot3(XCB,YCB,ZCB,'r-','LineWidth',2);
        view(AZ,EL);
        hold on;   
        axis equal;  
        grid on;
        if iwing == 4
        saveas(gid,[folder,'pass/wingPass.fig']);
        end
        %close;
    end
end

