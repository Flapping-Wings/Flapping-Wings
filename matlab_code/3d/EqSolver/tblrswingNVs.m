function [ Vnc ] = tblrswingNVs(m,iwing,xC,XC,NC,t,theta,phi,dph,dth,a,beta,U)
%Get the normal velocity of the wing in the space-fixed system
%The normal velocity at the wing collocation points XC(j,i)
%==========================================================================
%INPUT VARIABLES
% m             1 (front), 2(rear) wing
% iwing          1(right wing), 2(left)
% xC(j,i)        collocation points (wing-fixed)
% XC(j,i)        collocation points (space-fixed)
% NC(j,i)        unit normals at collocation points(space-fixed)
% t                 time
% theta             pitch angle (Notice that the rolling angle phi is absent)
% phi
% dph,dth           rate of olling and pitch angless
% a                 offset distance of the translational and body-fixed systems
% beta              stgroke angle
% U(j)              air velocity
%OUTPIT
% Vnc(1,nXc)        normal velocity (space-fixed)

global vplot folder

%Airfoil velocity components in space-fixed system
    sbt=sin(beta ); cbt=cos(beta );
    sth=sin(theta); cth=cos(theta);
    sph=sin(phi)  ; cph=cos(phi)  ;
        
    ab=-sth*(xC(1,:)+a)+cth*xC(3,:);
    xb= cth*(xC(1,:)+a)+sth*xC(3,:);
    vxb=     dth*ab;
    vyb= sph*dth*xb-cph*dph*ab-sph*dph*xC(2,:);
    vzb=-cph*dth*xb-sph*dph*ab+cph*dph*xC(2,:);
    
    if iwing ==2 %do nothing for right wing
        %Transform from LHS to RHS
        vyb=-vyb;
    end
    
    vx=-U(1)+sbt*vxb +cbt*vzb;
    vy=-U(2)+    vyb;
    vz=-U(3)-cbt*vxb +sbt*vzb;
    
%Normal velocity component of the airfoil
    Vnc=vx.*NC(1,:)+vy.*NC(2,:)+vz.*NC(3,:);
    clear vx vy vz;
    if vplot == 1
        %End points for the normal velocity vector
        sf=0.1; %scale factor for the velocity plot
        xaif=XC(1,:);
        yaif=XC(2,:);
        zaif=XC(3,:);
       
        xtip=xaif+sf*Vnc.*NC(1,:);
        ytip=yaif+sf*Vnc.*NC(2,:);
        ztip=zaif+sf*Vnc.*NC(3,:);
        
        %Plot normal velocity vectors at collocation points     
        f=figure();
        plot3([xaif; xtip],[yaif; ytip], [zaif; ztip]);
        hold on;
        plot3(XC(1,:),XC(2,:),XC(3,:),'o');
        hold off;   
        axis equal;  
        title('normal velocity vectors at collocation points');
        if m ==1
            if iwing ==1
                saveas(f,[folder 'debug/Vairfoil_fr_' num2str(t) '.fig']); 
            else
                saveas(f,[folder 'debug/Vairfoil_fl_' num2str(t) '.fig']);
            end
        else
            if iwing ==1
                saveas(f,[folder 'debug/Vairfoil_rr_' num2str(t) '.fig']); 
            else
                saveas(f,[folder 'debug/Vairfoil_rl_' num2str(t) '.fig']);
            end 
        end
            
        close;
        clear xaif yaif zaif xtip ytip ztip sf;
    end

end

