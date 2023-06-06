function [GAMAw,nXw,Xw]=tbaddWake(nXb,GAMAb,Xs,GAMAw,Xw)
%{
INPUT:
   nXb                  # of border elements
   GAMAb(w,iXb)         shed vortex (=border vortex)
   Xs(j,n,iXb,w)        location of shed vortex (after convection)
   GAMAw(w,iXw)         wake vortex
   Xw(j,n,iXw,w)        current location of wake vortwx (after convection)

OUTPUT:
   GANAw (w,iXw)        wake vortex for next step
   nXw                  updated #of wake vortices for next step
   Xw(j,n,iXw,w)        wake vortex location for next step (in the current wing-fixed system)
%}
global nwing
%Add the wake vortex vector
%Add the newly shed vortices to the wake vortices
GAMAw=[GAMAw,GAMAb]; %increment in each step
s=size(GAMAw);
nXw=s(2);

%Add the location of the newly shed vorties to existing wake vortex locations
%Xw=Xw;
s=size(Xw);
for i=1:nwing
    Xw(1:3,1:4,(s(3)+1):nXw,i)=Xs(1:3,1:4,1:nXb,i); %increment in each step rather than allocation the whole spece at the beginning
end

end

