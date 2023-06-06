function [VNW] = ignVelocityw2(m,ZC, NC, ZF, GAMAw, iGAMAw)
%Normal velocity contribution on the airfoil by the wake vortex
%INPUT
% m                         # of vortex points
% ZC    (1,m-1)         collocation points
% NC        (1,m-1)         unit normal complex number
% ZF        (1,iGAMAw)    location of the wake vortices (1:iGAMAw)
% GAMAw     (1,iGAMAw)      wake vortex
% iGAMAw                    # of wake vortices
%OUTPUT
% VNW       (1,m-1)         normal velocity components at the collocation point due to the wake vortices

global eps delta ibios

VNW=zeros(1,m-1);
switch ibios
    case 0
        eps=eps*1000;
        for i=1:m-1
            VNW(i)=0.0;
            for j=1:iGAMAw %skipped for iGAMAw=0 in istep=1          
                r=abs(ZC(i)-ZF(j));
                GF=complex(0.0,0.0);
                if r > eps 
                    GF=1.0/(ZC(i)-ZF(j));
                end
                VNW(i)=VNW(i)+GAMAw(j)*imag(NC(i)*GF)/(2.0*pi);
            end
        end
    case 1
        for i=1:m-1
            VNW(i)=0.0;
            for j=1:iGAMAw %skipped for iGAMAw=0 in istep=1          
                r=abs(ZC(i)-ZF(j));
                if r < eps
                    GF=complex(0.0,0.0);
                else 
                    GF=1.0/(ZC(i)-ZF(j));
                    if r < delta
                        GF=GF*(r/delta)^2;
                    end
                end
                VNW(i)=VNW(i)+GAMAw(j)*imag(NC(i)*GF)/(2.0*pi);
            end
        end

end

end

