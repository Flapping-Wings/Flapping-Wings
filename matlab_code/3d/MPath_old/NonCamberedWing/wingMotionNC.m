function [ XL,YL,ZL,XT,YT,ZT,XC,YC,ZC ] = wingMotionNC(a, x0L,x0T,x0C,y0L,y0T,y0C,theta,phi,beta )
%INPUT
% a         rotation offset from the y-axis
% x0L,y0L   leading edge point on the wing-coordinate
% x0C,y0C   center point on the wing-coordinate
% x0T,y0T   trailing edge point on the wing-coordinate
% theta     pitching
% phi       roll
% beta      stroke plane angle
    [ xL,yL,zL] = wingMotionNCB( a,x0L,y0L,theta,phi );
    [ xT,yT,zT] = wingMotionNCB( a,x0T,y0T,theta,phi );
    [ xC,yC,zC] = wingMotionNCB( a,x0C,y0C,theta,phi );
    
    
    sb=sin(beta);
    cb=cos(beta);
    [XL,ZL,YL] = yRotate(sb,cb,xL,zL,yL);
    [XT,ZT,YT] = yRotate(sb,cb,xT,zT,yT);
    [XC,ZC,YC] = yRotate(sb,cb,xC,zC,yC);
    
    

end

