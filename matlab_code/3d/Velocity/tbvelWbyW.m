function [ VWW ] = tbvelWbyW(istep,XwT,nXw, Xw2_f,GAMAw2_f,nXw_f,Xw2_r,GAMAw2_r,nXw_r )
%Velocity  at wake element nodes (NO offset) due to wake vortices of 4 wings

%INPUT
% istep
% target=======
% XwT(j,n,iXw)      corrdinates of the target wake elements
% nXw               #of wake vortices
% sources=======
% Xw2_f(j,n,iXw,w)  coordinates of the front wake element
% GAMAw2_f(w,iXw)   front wake vortex
% nXw_f             # of front wake elements
% Xw2_r(j,n,iXw,w)  coordinates of the rear wake element
% GAMAw2_t(w,iXw)   rear wake vortex
% nXw_t             # of rear wake elements

%OUTPUT
%VWW(j,n,iXw)


VWW=zeros(3,4,nXw); % output value for istep=1
if istep > 1
    %Front wings
    %Contribution from right wing wake
    GAMAw=GAMAw2_f(1,:);
    GAMw=reshape(GAMAw,1,1,nXw_f); 
    Xw=Xw2_f(:,:,:,1);
    for i=1:nXw
    for n=1:4
        x=XwT(1,n,i);
        y=XwT(2,n,i);
        z=XwT(3,n,i);
        u=0.0; v=0.0; w=0.0;
        [u1,v1,w1]= mVORTEX(x,y,z,Xw(1,1,:),Xw(2,1,:),Xw(3,1,:),Xw(1,2,:),Xw(2,2,:),Xw(3,2,:),GAMw);
        u=u+u1; v=v+v1; w=w+w1;   
        [u2,v2,w2]= mVORTEX(x,y,z,Xw(1,2,:),Xw(2,2,:),Xw(3,2,:),Xw(1,3,:),Xw(2,3,:),Xw(3,3,:),GAMw);
        u=u+u2; v=v+v2; w=w+w2;
        [u3,v3,w3]= mVORTEX(x,y,z,Xw(1,3,:),Xw(2,3,:),Xw(3,3,:),Xw(1,4,:),Xw(2,4,:),Xw(3,4,:),GAMw);    
        u=u+u3; v=v+v3; w=w+w3;
        [u4,v4,w4]= mVORTEX(x,y,z,Xw(1,4,:),Xw(2,4,:),Xw(3,4,:),Xw(1,1,:),Xw(2,1,:),Xw(3,1,:),GAMw);    
        u=u+u4; v=v+v4; w=w+w4;
        VWW(1,n,i)=u;
        VWW(2,n,i)=v;
        VWW(3,n,i)=w;
    end
    end 
    %Contribution from left wing wake
    GAMAw=GAMAw2_f(2,:);
    GAMw=reshape(GAMAw,1,1,nXw_f); 
    Xw=Xw2_f(:,:,:,2);
    for i=1:nXw
    for n=1:4
        x=XwT(1,n,i);
        y=XwT(2,n,i);
        z=XwT(3,n,i);
        u=0.0; v=0.0; w=0.0;
        [u1,v1,w1]= mVORTEX(x,y,z,Xw(1,1,:),Xw(2,1,:),Xw(3,1,:),Xw(1,2,:),Xw(2,2,:),Xw(3,2,:),GAMw);
        u=u+u1; v=v+v1; w=w+w1;   
        [u2,v2,w2]= mVORTEX(x,y,z,Xw(1,2,:),Xw(2,2,:),Xw(3,2,:),Xw(1,3,:),Xw(2,3,:),Xw(3,3,:),GAMw);
        u=u+u2; v=v+v2; w=w+w2;
        [u3,v3,w3]= mVORTEX(x,y,z,Xw(1,3,:),Xw(2,3,:),Xw(3,3,:),Xw(1,4,:),Xw(2,4,:),Xw(3,4,:),GAMw);    
        u=u+u3; v=v+v3; w=w+w3;
        [u4,v4,w4]= mVORTEX(x,y,z,Xw(1,4,:),Xw(2,4,:),Xw(3,4,:),Xw(1,1,:),Xw(2,1,:),Xw(3,1,:),GAMw);    
        u=u+u4; v=v+v4; w=w+w4;
        VWW(1,n,i)=VWW(1,n,i)+u;
        VWW(2,n,i)=VWW(2,n,i)+v;
        VWW(3,n,i)=VWW(3,n,i)+w;
    end
    end 
    
    %Rear wings
    %Contribution from right wing wake
    GAMAw=GAMAw2_r(1,:);
    GAMw=reshape(GAMAw,1,1,nXw_r); 
    Xw=Xw2_r(:,:,:,1);
    for i=1:nXw
    for n=1:4
        x=XwT(1,n,i);
        y=XwT(2,n,i);
        z=XwT(3,n,i);
        u=0.0; v=0.0; w=0.0;
        [u1,v1,w1]= mVORTEX(x,y,z,Xw(1,1,:),Xw(2,1,:),Xw(3,1,:),Xw(1,2,:),Xw(2,2,:),Xw(3,2,:),GAMw);
        u=u+u1; v=v+v1; w=w+w1;   
        [u2,v2,w2]= mVORTEX(x,y,z,Xw(1,2,:),Xw(2,2,:),Xw(3,2,:),Xw(1,3,:),Xw(2,3,:),Xw(3,3,:),GAMw);
        u=u+u2; v=v+v2; w=w+w2;
        [u3,v3,w3]= mVORTEX(x,y,z,Xw(1,3,:),Xw(2,3,:),Xw(3,3,:),Xw(1,4,:),Xw(2,4,:),Xw(3,4,:),GAMw);    
        u=u+u3; v=v+v3; w=w+w3;
        [u4,v4,w4]= mVORTEX(x,y,z,Xw(1,4,:),Xw(2,4,:),Xw(3,4,:),Xw(1,1,:),Xw(2,1,:),Xw(3,1,:),GAMw);    
        u=u+u4; v=v+v4; w=w+w4;
        VWW(1,n,i)=VWW(1,n,i)+u;
        VWW(2,n,i)=VWW(2,n,i)+v;
        VWW(3,n,i)=VWW(3,n,i)+w;
    end
    end 
    %Contribution from left wing wake
    GAMAw=GAMAw2_r(2,:);
    GAMw=reshape(GAMAw,1,1,nXw_r); 
    Xw=Xw2_r(:,:,:,2);
    for i=1:nXw
    for n=1:4
        x=XwT(1,n,i);
        y=XwT(2,n,i);
        z=XwT(3,n,i);
        u=0.0; v=0.0; w=0.0;
        [u1,v1,w1]= mVORTEX(x,y,z,Xw(1,1,:),Xw(2,1,:),Xw(3,1,:),Xw(1,2,:),Xw(2,2,:),Xw(3,2,:),GAMw);
        u=u+u1; v=v+v1; w=w+w1;   
        [u2,v2,w2]= mVORTEX(x,y,z,Xw(1,2,:),Xw(2,2,:),Xw(3,2,:),Xw(1,3,:),Xw(2,3,:),Xw(3,3,:),GAMw);
        u=u+u2; v=v+v2; w=w+w2;
        [u3,v3,w3]= mVORTEX(x,y,z,Xw(1,3,:),Xw(2,3,:),Xw(3,3,:),Xw(1,4,:),Xw(2,4,:),Xw(3,4,:),GAMw);    
        u=u+u3; v=v+v3; w=w+w3;
        [u4,v4,w4]= mVORTEX(x,y,z,Xw(1,4,:),Xw(2,4,:),Xw(3,4,:),Xw(1,1,:),Xw(2,1,:),Xw(3,1,:),GAMw);    
        u=u+u4; v=v+v4; w=w+w4;
        VWW(1,n,i)=VWW(1,n,i)+u;
        VWW(2,n,i)=VWW(2,n,i)+v;
        VWW(3,n,i)=VWW(3,n,i)+w;
    end
    end 
clear GAMAW GAMw Xw 
end
end

