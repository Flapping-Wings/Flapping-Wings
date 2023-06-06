function [ ] = igforceMoment(rho_,v_,d_,nstep,dt ,U,V )
%Calculate the force and moment on the airfoil
%INPUT
% nstep     # of step
% dt        time increment
global impulseLb impulseAb impulseLw impulseAw
global LDOT HDOT folder fid


%Initialize force and moment array
    tmp=zeros(1,nstep);
    forceb =complex(tmp,tmp);
    forcew =complex(tmp,tmp);
    force  =complex(tmp,tmp);
    momentb=tmp;   
    momentw=tmp;    
    moment =tmp;
%Reference values of force and moment   
    f_=rho_*(v_^2)*d_;
    m_=f_*d_;
    
    for IT=1:nstep 
        %U0 =complex(LDOT(IT), HDOT(IT)); %Translational velocity of the moving system (no ambient air velocity)
        U0 =complex(LDOT(IT)-U, HDOT(IT)-V); %Translational velocity of the moving system 4/6/16
            if IT == 1 
                 forceb(1) = (impulseLb(2)-impulseLb(1))/dt;
                 forcew(1) = (impulseLw(2)-impulseLw(1))/dt;
                momentb(1) = (impulseAb(2)-impulseAb(1))/dt;
                momentw(1) = (impulseAw(2)-impulseAw(1))/dt;
               %{ 
                impulseLb0=complex(0,0);
                impulseLw0=complex(0,0);
                impulseAb0=0.0;
                impulseAw0=0.0;
                 forceb(1) = 0.5*(impulseLb(2)-impulseLb0)/dt;
                 forcew(1) = 0.5*(impulseLw(2)-impulseLw0)/dt;
                momentb(1) = 0.5*(impulseAb(2)-impulseAb0)/dt;
                momentw(1) = 0.5*(impulseAw(2)-impulseAw0)/dt;
                % forceb(1) = (impulseLb(1)-impulseLb0)/dt;
                % forcew(1) = (impulseLw(1)-impulseLw0)/dt;
                %momentb(1) = (impulseAb(1)-impulseAb0)/dt;
                %momentw(1) = (impulseAw(1)-impulseAw0)/dt;
                %}
            elseif IT == nstep
                 forceb(IT) = 0.5*( 3.0*impulseLb(IT)-4.0*impulseLb(IT-1)+impulseLb(IT-2) )/dt;
                momentb(IT) = 0.5*( 3.0*impulseAb(IT)-4.0*impulseAb(IT-1)+impulseAb(IT-2) )/dt;
                 forcew(IT) = 0.5*( 3.0*impulseLw(IT)-4.0*impulseLw(IT-1)+impulseLw(IT-2) )/dt;
                momentw(IT) = 0.5*( 3.0*impulseAw(IT)-4.0*impulseAw(IT-1)+impulseAw(IT-2) )/dt;
            else
                 forceb(IT) = 0.5*(impulseLb(IT+1)-impulseLb(IT-1))/dt;
                momentb(IT) = 0.5*(impulseAb(IT+1)-impulseAb(IT-1))/dt;
                 forcew(IT) = 0.5*(impulseLw(IT+1)-impulseLw(IT-1))/dt;
                momentw(IT) = 0.5*(impulseAw(IT+1)-impulseAw(IT-1))/dt;
            end   
       
       
            momentb(IT) = momentb(IT)+imag( conj(U0)*impulseLb(IT) );
            momentw(IT) = momentw(IT)+imag( conj(U0)*impulseLw(IT) );
       
    
        %Total Force and Moment (these are on the fluid)
        force(IT)  =  forceb(IT)+ forcew(IT);
        moment(IT) = momentb(IT)+momentw(IT);
        %The dimensional force & moment on the wing are obtained by reversing the sign
        %and multiplying thr reference quantities
        force(IT)  = -f_*force(IT);
        moment(IT) = -m_*moment(IT);
    end 
 
    ITa=linspace(1,nstep,nstep);
    fm=figure();
    plot(ITa,real(force),'x-k');
    grid on;
    saveas(fm,[folder 'fx.tif']);
    close;
    fm=figure();
    plot(ITa,imag(force),'+-k');
    grid on;
    saveas(fm,[folder 'fy.tif']);
    close;
    fm=figure();
    plot(ITa,moment,'o-r');
    grid on;
    saveas(fm,[folder 'm.tif']);
    close;
    
    %Calculate the average forces and moment
    Fx=real(force);
    Fy=imag(force);
    Mz=moment;
    Fx_avr=sum(Fx)/nstep;
    Fy_avr=sum(Fy)/nstep;
    Mz_avr=sum(Mz)/nstep;
    fprintf(fid, 'Fx_avr = %6.3e Fy_avr = %6.3e Mz_avr = %6.3e\n', Fx_avr,Fy_avr, Mz_avr);


end

