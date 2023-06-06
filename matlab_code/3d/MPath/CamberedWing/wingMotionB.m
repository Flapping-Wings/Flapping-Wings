function [ x,y,z] = wingMotionB( a,x0,y0,z0,theta,phi )
%Motion of a single point on a cambered wing
% a         rotation offfset
% x0,y0,z0     coordinates of the wing point
% theta     pitch
% phi       roll
    cth=cos(theta);
    sth=sin(theta);
    cph=cos(phi);
    sph=sin(phi);
    x=(a+x0)*cth+z0*sth;
    y=y0*cph+(a+x0)*sth.*sph-z0*cth.*sph;
    z=y0*sph-(a+x0)*sth.*cph+z0*cth.*cph;

end

