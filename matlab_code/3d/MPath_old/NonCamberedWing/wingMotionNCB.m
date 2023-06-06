function [ x,y,z] = wingMotionNCB( a,x0,y0,theta,phi )
%Motion of a single point on a non-cambered wing
% a         rotation offfset
% xo,yo     coordinates of the wing point
% theta     pitch
% phi       roll
    x=(a+x0)*cos(theta);
    y=y0*cos(phi)+(a+x0)*sin(theta).*sin(phi);
    z=y0*sin(phi)-(a+x0)*sin(theta).*cos(phi);

end

