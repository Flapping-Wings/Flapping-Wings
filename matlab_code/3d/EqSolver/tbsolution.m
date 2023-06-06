function [ GAMA ] = tbsolution(nxt_f,nxt_r,MVN,Vnc_f,Vncw_f,Vnc_r,Vncw_r)
%Solution
%INPUT
% nxt_f           # of bound vortices for front wing
% nxt_r           # of bound vortices for rear wing
% MVN             matrix
% Vnc_f(2,nxt_f)  normal velocity at the collocation points by the bound vortex
% Vncw_f(2,nxt_f) normal velocity at the collocation points by the wake vortex
% Vnc_r(2,nxt_f)  normal velocity at the collocation points by the bound vortex
% Vncw_r(2,nxt)   normal velocity at the collocation points by the wake vortex
%OUTPUT
% GAMA  bound vortices
global solver
%RHS of the equation
%Front wing
%RIGHT WING
    %for the non-peneteration condition: (nxt_f) components 
    GAMA(               1 :   nxt_f         )=Vnc_f(1,1:nxt_f)-Vncw_f(1,1:nxt_f);

%LEFT WING
    %for the non-peneteration condition: (nxt_f) components
    GAMA((  nxt_f+      1): 2*nxt_f         )=Vnc_f(2,1:nxt_f)-Vncw_f(2,1:nxt_f);
%Rear wing
%RIGHT WING
    %for the non-peneteration condition: (nxt_r) components 
    GAMA((2*nxt_f+      1):(2*nxt_f+  nxt_r))=Vnc_r(1,1:nxt_r)-Vncw_r(1,1:nxt_r);

%LEFT WING
    %for the non-peneteration condition: (nxt_r) components
    GAMA((2*nxt_f+nxt_r+1):(2*nxt_f+2*nxt_r))=Vnc_r(2,1:nxt_r)-Vncw_r(2,1:nxt_r);
        
 
    if solver ==1
        GAMA=GAMA';
        GAMA=GAMA\MVN;
        %GAMA=GAMA';
    else
        [ip,MVN]= DECOMP(2*nxt_f+2*nxt_r,MVN);
        [GAMA]= SOLVER(2*nxt_f+2*nxt_r,MVN,GAMA,ip);
    end
end

