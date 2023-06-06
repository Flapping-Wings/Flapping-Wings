function [xv, yv, xc, yc, dfc,mNew] = igmeshR(c,x,y,n,m)
global mplot folder
%==========================================================================
%Refined mesh: vortex points near the end point are refined
%Given an airfoil, identify n+1 points (including the end points)
%that divide the airfoil at an equal n interval
%INPUT VARIABLES
% x,y   data points on the airfoil
% c     chord length (nondimentionalized by d=stroke length)

% n     # of data points to define the airfoil shape (n > m)
% m     # of vortex points (# of collocation points = m-1)
%OUTPUT VAIABLES
% xv, yv    coordinates of the vortex points
% xc, yc    coordinates of the collocation points
% dfc       slope at the collocation points  
% mNew      use m+4 for the number of refined vortex points
%==========================================================================

    a=0.5*c;  %half chord length
    

    %Splines for the curve and its slope
    f=spline(x,y);
    df=fnder(f,1);

    %Calculate the curve length as the function of x
    s(1)=0;
    for i=1:n-1
        ds=quad(@(z)sqrt(1+ppval(df,z).^2),x(i),x(i+1));
        s(i+1)=s(i)+ds;
    end
    %Spline for (curve length) - x relation
    g=spline(s,x);
    dS=s(n)/(m-1);    %Curve length = s(n+1)

    %Identify X & Y coordinates that equally divide the curve
    %add 4 more points, 2 each near the end; at 1/4 and 1/2 distances
    xv=zeros(1,m+4);
    xv(1)  =-a;
    xv(2)=ppval(g,dS*0.25);
    xv(3)=ppval(g,dS*0.5 );
    
    for i=2:m-1
        xv(i+2)=ppval(g,dS*(i-1));
    end
    xv(m+2)=ppval(g,dS*(m-1-0.5));
    xv(m+3)=ppval(g,dS*(m-1-0.25));
    xv(m+4)= a;  
    yv=ppval(f,xv);

    %Mid poits of (X,Y) to be used for collocation
    xc=zeros(1,m+3);
    xc(1)=ppval(g,dS*0.125);
    xc(2)=ppval(g,dS*0.375);
    xc(3)=ppval(g,dS*0.75 );
    for i=2:m-2
        xc(i+2)=ppval(g,dS*(i-0.5));
    end
    xc(m+1)=ppval(g,dS*(m-1-0.75 ));
    xc(m+2)=ppval(g,dS*(m-1-0.375));
    xc(m+3)=ppval(g,dS*(m-1-0.125));
    yc=ppval(f,xc);

    %Slope at the Collocation Points
    dfc=ppval(df,xc);

    %PLOTS=================================================================
    switch mplot
        case 1
            g=figure();
            xx=linspace(-a,a, 101);
            %Plot Vortex and Collocation points
            plot(xv,yv,'ro',xc,yc,'x',xx,ppval(f,xx),'-')
            %axis([-1.1*a,1.1*a,-0.1*h,1.1*h])
            legend('Vortex Points','Collocation Points')
            axis equal
            grid on
            saveas(g,[folder 'mesh.tif']);
        case 2
            %Compare equal arc and equal abscissa mesh points
            plot(xv,yv,'rs',x,y,'o',xx,ppval(f,xx),'-')
            axis([-a,a,-0.1,h+0.1])
            legend('Equal arc length','Equal abscissa')
        otherwise
           
    end
    
    %Update the numer of vortex points
    mNew=m+4;

end



