function [  ] = plot2Elm( Xn,nXn,npoly,color,lw )
%Plot a group of polygonal elements in x-y plane
%INPUT
%Xn(j,n,i)  polynomial element array
%nXn        # of elements
%nploy      order of polygon
%color      color in the plot
%lw         line width

%f=figure();
for i=1:nXn
    for ipoly=1:npoly
        x(ipoly)=Xn(1,ipoly,i);
        y(ipoly)=Xn(2,ipoly,i);
    end
    x(npoly+1)=Xn(1,1,i);
    y(npoly+1)=Xn(2,1,i);
    cx=Xn(1,npoly+1,i);
    cy=Xn(2,npoly+1,i);
    plot(x,y,color,'LineWidth',lw);
    hold on;
    plot(cx,cy,'o')
    axis equal;
    hold on;
end
%saveas(f,['2dmesh.fig']);
%close;
end


