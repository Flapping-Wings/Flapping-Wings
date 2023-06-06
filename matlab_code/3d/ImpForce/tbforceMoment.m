function [ ] = tbforceMoment(rho_,v_,d_1,nstep,dt ,U )
%Calculate the force and moment on the airfoil
%INPUT
% rho_      reference density
% v_        reference velocity
% d_        eference length
% nstep     # of step
% dt        time increment
% U(j)      air velocity
global limpa_f aimpa_f limpw_f aimpw_f limpa_r aimpa_r limpw_r aimpw_r
%global limpa aimpa limpw aimpw %size(3,nstep,nwing/2)
global folder nwing

%Reference values of force and moment   
    f_=rho_*(v_*d_1)^2;
    m_=f_*d_1;

%Translational velocity of the moving inertia system    
    U0 =-U; 

%Combine impulses
%Front wings
limps_f=limpa_f+limpw_f;
aimps_f=aimpa_f+aimpw_f;
%Rear wings
limps_r=limpa_r+limpw_r;
aimps_r=aimpa_r+aimpw_r;

%Add contributions from nwing/2 wings
%Front wings
limp_f=limps_f(:,:,1)+limps_f(:,:,2);
aimp_f=aimps_f(:,:,1)+aimps_f(:,:,2);
%Rear wings
limp_r=limps_r(:,:,1)+limps_r(:,:,2);
aimp_r=aimps_r(:,:,1)+aimps_r(:,:,2);

%Add contributions from front and rear wings
limp=limp_f+limp_r;
aimp=aimp_f+aimp_r;
%Get the splines and their derivatives for the impulses
for i=1:nwing
    time=dt*(1:nstep);
     impLx=spline(time,limp(1,:));
     impLy=spline(time,limp(2,:));
     impLz=spline(time,limp(3,:));
    dimpLx=fnder(impLx,1);
    dimpLy=fnder(impLy,1);
    dimpLz=fnder(impLz,1);
    
     impAx=spline(time,aimp(1,:));
     impAy=spline(time,aimp(2,:));
     impAz=spline(time,aimp(3,:));
    dimpAx=fnder(impAx,1);
    dimpAy=fnder(impAy,1);
    dimpAz=fnder(impAz,1);
end
   
%Evaluate force and moments at sample times
    times=0:(01*dt):(dt*nstep); %incluse time=0

    forcex=ppval(dimpLx,times);
    forcey=ppval(dimpLy,times);
    forcez=ppval(dimpLz,times);
    limpx =ppval(impLx, times);
    limpy =ppval(impLy, times);
    limpz =ppval(impLz, times);
    momx  =ppval(dimpAx,times);
    momy  =ppval(dimpAy,times);
    momz  =ppval(dimpAz,times);
    
    momentx=momx+U0(2)*limpz-U0(3)*limpy;
    momenty=momy+U0(3)*limpx-U0(1)*limpz;
    momentz=momz+U0(1)*limpy-U0(2)*limpx;
    
%Reverse the sign to get forces/moments acting on the wing (11/13/14)
    forcex=-f_*forcex;
    forcey=-f_*forcey;
    forcez=-f_*forcez;
    
    momentx=-m_*momentx;
    momenty=-m_*momenty;
    momentz=-m_*momentz;    
%Plot forces and moments
    fm=figure();
    plot(times,forcex,'x-k');
    grid on;
    saveas(fm,[folder 'f&m/fx.fig']);
    close;
    fm=figure();
    plot(times,forcey,'+-k');
    grid on;
    saveas(fm,[folder 'f&m/fy.fig']);
    close;
    fm=figure();
    plot(times,forcez,'x-k');
    grid on;
    saveas(fm,[folder 'f&m/fz.fig']);
    close;
    fm=figure();
    plot(times,momentx,'o-r');
    grid on;
    saveas(fm,[folder 'f&m/m1.fig']);
    close;
    fm=figure();
    plot(times,momenty,'o-r');
    grid on;
    saveas(fm,[folder 'f&m/m2.fig']);
    close;
    fm=figure();
    plot(times,momentz,'o-r');
    grid on;
    saveas(fm,[folder 'f&m/m3.fig']);
    close;
end

