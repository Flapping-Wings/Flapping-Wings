function [ GAMAb] = tbdivideGAM( GAM,nxb )
%Sort GAMA into shed and bound groups
%INPUT
%GAM(w,nxt)     for the whole elements
%nxb            # of border elements
%nxt            # of total elements on the wing
%OUTPUT
%GAMAb(w,nxb)   border elements (to be shed)
%GAMAc(w,nxc)   center elements (bound)
global nwing

GAMAb=zeros(nwing,     nxb );
%GAMAc=zeros(nwing,(nxt-nxb));

for i=1:nwing
    GAMAb(i,1:     nxb ) =GAM(i,1      :nxb);
    %GAMAc(i,1:(nxt-nxb)) =GAM(i,(nxb+1):nxt);
end

end