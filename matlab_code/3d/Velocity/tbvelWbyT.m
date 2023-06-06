function [ VWT ] = tbvelWbyT(istep,Xw,nXw,  Xt2_f,GAMA2_f,nXt_f,Xt2_r,GAMA2_r,nXt_r)
%Velocity  at wake element nodes  due to total vortices (nXt) on 4 wings
% The velocity is evaluated at the nodes; no offset 

%INPUT
% istep
% target========
% Xw(j,n,iXw)       coordinate j of observation node n of the wake element (destination)
% nXw               #of wake vortices (destination)
% source========
% Xt2_f(j,n,iXt,w)  coordinate j of source node n for the total element iXt on the front wing
% GAMA2_f(w,iXt)    entire bound vortex from the front wings
% nXt_f             # of total elements on the front wing
% Xt2_r(j,n,iXt,w)  coordinate j of source node n for the total element iXt on the rear wing
% GAMA2_r(w,iXt)    entire bound vortex from the rear wings
% nXt_r             # of total elements on the rear wing 

%OUTPUT
%VWT(j,n,iXw)

VWT=zeros(3,4,nXw); % output value for istep=1
if istep > 1
    %Forward wing
    %Contribution from right wing
    GAMA=GAMA2_f(1,:);
    GAMt=reshape(GAMA,1,1,nXt_f); 
    Xt=Xt2_f(:,:,:,1);
    for i=1:nXw
    for n=1:4
        x=Xw(1,n,i);
        y=Xw(2,n,i);
        z=Xw(3,n,i);
        u=0.0; v=0.0; w=0.0;
        [u1,v1,w1]= mVORTEX(x,y,z,Xt(1,1,:),Xt(2,1,:),Xt(3,1,:),Xt(1,2,:),Xt(2,2,:),Xt(3,2,:),GAMt);
        u=u+u1; v=v+v1; w=w+w1;   
        [u2,v2,w2]= mVORTEX(x,y,z,Xt(1,2,:),Xt(2,2,:),Xt(3,2,:),Xt(1,3,:),Xt(2,3,:),Xt(3,3,:),GAMt);
        u=u+u2; v=v+v2; w=w+w2;
        [u3,v3,w3]= mVORTEX(x,y,z,Xt(1,3,:),Xt(2,3,:),Xt(3,3,:),Xt(1,4,:),Xt(2,4,:),Xt(3,4,:),GAMt);    
        u=u+u3; v=v+v3; w=w+w3;
        [u4,v4,w4]= mVORTEX(x,y,z,Xt(1,4,:),Xt(2,4,:),Xt(3,4,:),Xt(1,1,:),Xt(2,1,:),Xt(3,1,:),GAMt);    
        u=u+u4; v=v+v4; w=w+w4;
        VWT(1,n,i)=u;
        VWT(2,n,i)=v;
        VWT(3,n,i)=w;
    end
    end
    %Contribution from left wing
    GAMA=GAMA2_f(2,:);
    GAMt=reshape(GAMA,1,1,nXt_f); 
    Xt=Xt2_f(:,:,:,2);
    for i=1:nXw
    for n=1:4
        x=Xw(1,n,i);
        y=Xw(2,n,i);
        z=Xw(3,n,i);
        u=0.0; v=0.0; w=0.0;
        [u1,v1,w1]= mVORTEX(x,y,z,Xt(1,1,:),Xt(2,1,:),Xt(3,1,:),Xt(1,2,:),Xt(2,2,:),Xt(3,2,:),GAMt);
        u=u+u1; v=v+v1; w=w+w1;   
        [u2,v2,w2]= mVORTEX(x,y,z,Xt(1,2,:),Xt(2,2,:),Xt(3,2,:),Xt(1,3,:),Xt(2,3,:),Xt(3,3,:),GAMt);
        u=u+u2; v=v+v2; w=w+w2;
        [u3,v3,w3]= mVORTEX(x,y,z,Xt(1,3,:),Xt(2,3,:),Xt(3,3,:),Xt(1,4,:),Xt(2,4,:),Xt(3,4,:),GAMt);    
        u=u+u3; v=v+v3; w=w+w3;
        [u4,v4,w4]= mVORTEX(x,y,z,Xt(1,4,:),Xt(2,4,:),Xt(3,4,:),Xt(1,1,:),Xt(2,1,:),Xt(3,1,:),GAMt);    
        u=u+u4; v=v+v4; w=w+w4;
        VWT(1,n,i)=VWT(1,n,i)+u;
        VWT(2,n,i)=VWT(2,n,i)+v;
        VWT(3,n,i)=VWT(3,n,i)+w;
    end
    end

    %Rear wing
    %Contribution from right wing
    GAMA=GAMA2_r(1,:);
    GAMt=reshape(GAMA,1,1,nXt_r); 
    Xt=Xt2_r(:,:,:,1);
    for i=1:nXw
    for n=1:4
        x=Xw(1,n,i);
        y=Xw(2,n,i);
        z=Xw(3,n,i);
        u=0.0; v=0.0; w=0.0;
        [u1,v1,w1]= mVORTEX(x,y,z,Xt(1,1,:),Xt(2,1,:),Xt(3,1,:),Xt(1,2,:),Xt(2,2,:),Xt(3,2,:),GAMt);
        u=u+u1; v=v+v1; w=w+w1;   
        [u2,v2,w2]= mVORTEX(x,y,z,Xt(1,2,:),Xt(2,2,:),Xt(3,2,:),Xt(1,3,:),Xt(2,3,:),Xt(3,3,:),GAMt);
        u=u+u2; v=v+v2; w=w+w2;
        [u3,v3,w3]= mVORTEX(x,y,z,Xt(1,3,:),Xt(2,3,:),Xt(3,3,:),Xt(1,4,:),Xt(2,4,:),Xt(3,4,:),GAMt);    
        u=u+u3; v=v+v3; w=w+w3;
        [u4,v4,w4]= mVORTEX(x,y,z,Xt(1,4,:),Xt(2,4,:),Xt(3,4,:),Xt(1,1,:),Xt(2,1,:),Xt(3,1,:),GAMt);    
        u=u+u4; v=v+v4; w=w+w4;
        VWT(1,n,i)=VWT(1,n,i)+u;
        VWT(2,n,i)=VWT(2,n,i)+v;
        VWT(3,n,i)=VWT(3,n,i)+w;
    end
    end
    %Contribution from left wing
    GAMA=GAMA2_r(2,:);
    GAMt=reshape(GAMA,1,1,nXt_r); 
    Xt=Xt2_r(:,:,:,2);
    for i=1:nXw
    for n=1:4
        x=Xw(1,n,i);
        y=Xw(2,n,i);
        z=Xw(3,n,i);
        u=0.0; v=0.0; w=0.0;
        [u1,v1,w1]= mVORTEX(x,y,z,Xt(1,1,:),Xt(2,1,:),Xt(3,1,:),Xt(1,2,:),Xt(2,2,:),Xt(3,2,:),GAMt);
        u=u+u1; v=v+v1; w=w+w1;   
        [u2,v2,w2]= mVORTEX(x,y,z,Xt(1,2,:),Xt(2,2,:),Xt(3,2,:),Xt(1,3,:),Xt(2,3,:),Xt(3,3,:),GAMt);
        u=u+u2; v=v+v2; w=w+w2;
        [u3,v3,w3]= mVORTEX(x,y,z,Xt(1,3,:),Xt(2,3,:),Xt(3,3,:),Xt(1,4,:),Xt(2,4,:),Xt(3,4,:),GAMt);    
        u=u+u3; v=v+v3; w=w+w3;
        [u4,v4,w4]= mVORTEX(x,y,z,Xt(1,4,:),Xt(2,4,:),Xt(3,4,:),Xt(1,1,:),Xt(2,1,:),Xt(3,1,:),GAMt);    
        u=u+u4; v=v+v4; w=w+w4;
        VWT(1,n,i)=VWT(1,n,i)+u;
        VWT(2,n,i)=VWT(2,n,i)+v;
        VWT(3,n,i)=VWT(3,n,i)+w;
    end
    end
    clear GAMA GAMt Xt;  
end

end

