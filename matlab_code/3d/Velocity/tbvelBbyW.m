function [ VBW ] = tbvelBbyW(istep,Xb,nXb, Xw2_f,GAMAw2_f,nXw_f, Xw2_r,GAMAw2_r,nXw_r )
%Velocity at border element nodes of each wing due to wake vortices from 4 wings

%INPUT
% istep
% target==========
% Xb(j,n,iXb)       coordinate j of node point n for the border element i
% nXb               #of border elements
% sources=========
% Xw2_f(j,n,iXw,w)  coordinates of the front wake element
% GAMAw2_f(w,iXw)   front wake vortex
% nXw_f             #of front wake vortices
% Xw2_r(j,n,iXw,w)  coordinates of the rear wake element
% GAMAw2_r(w,iXw)   rear wake vortex
% nXw_r             #of rear wake vortices

%OUTPUT
%VBW(j,n,iXb)

VBW=zeros(3,4,nXb); % output value for istep=1
if istep > 1
    %Front wings
    %Contribution from wake of right wing
    GAMAw=GAMAw2_f(1,:);
    GAMw=reshape(GAMAw,1,1,nXw_f); %Gamw(1,1,nXw) and Xw(3,4,nXw) share the same shape
    Xw=Xw2_f(:,:,:,1);
    
    for i=1:nXb
    for n=1:4
        x=Xb(1,n,i);
        y=Xb(2,n,i);
        z=Xb(3,n,i);
        u=0.0; v=0.0; w=0.0;
        [u1,v1,w1]= mVORTEX(x,y,z,Xw(1,1,:),Xw(2,1,:),Xw(3,1,:),Xw(1,2,:),Xw(2,2,:),Xw(3,2,:),GAMw);
        u=u+u1; v=v+v1; w=w+w1;   
        [u2,v2,w2]= mVORTEX(x,y,z,Xw(1,2,:),Xw(2,2,:),Xw(3,2,:),Xw(1,3,:),Xw(2,3,:),Xw(3,3,:),GAMw);
        u=u+u2; v=v+v2; w=w+w2;
        [u3,v3,w3]= mVORTEX(x,y,z,Xw(1,3,:),Xw(2,3,:),Xw(3,3,:),Xw(1,4,:),Xw(2,4,:),Xw(3,4,:),GAMw);    
        u=u+u3; v=v+v3; w=w+w3;
        [u4,v4,w4]= mVORTEX(x,y,z,Xw(1,4,:),Xw(2,4,:),Xw(3,4,:),Xw(1,1,:),Xw(2,1,:),Xw(3,1,:),GAMw);    
        u=u+u4; v=v+v4; w=w+w4;
        VBW(1,n,i)=u;
        VBW(2,n,i)=v;
        VBW(3,n,i)=w;
    end
    end 

    %Contribution from wake of left wing
    GAMAw=GAMAw2_f(2,:);
    GAMw=reshape(GAMAw,1,1,nXw_f); %Gamw(1,1,nXw) and Xw(3,4,nXw) share the same shape
    Xw=Xw2_f(:,:,:,2);
    for i=1:nXb
    for n=1:4
        x=Xb(1,n,i);
        y=Xb(2,n,i);
        z=Xb(3,n,i);
        u=0.0; v=0.0; w=0.0;
        [u1,v1,w1]= mVORTEX(x,y,z,Xw(1,1,:),Xw(2,1,:),Xw(3,1,:),Xw(1,2,:),Xw(2,2,:),Xw(3,2,:),GAMw);
        u=u+u1; v=v+v1; w=w+w1;   
        [u2,v2,w2]= mVORTEX(x,y,z,Xw(1,2,:),Xw(2,2,:),Xw(3,2,:),Xw(1,3,:),Xw(2,3,:),Xw(3,3,:),GAMw);
        u=u+u2; v=v+v2; w=w+w2;
        [u3,v3,w3]= mVORTEX(x,y,z,Xw(1,3,:),Xw(2,3,:),Xw(3,3,:),Xw(1,4,:),Xw(2,4,:),Xw(3,4,:),GAMw);    
        u=u+u3; v=v+v3; w=w+w3;
        [u4,v4,w4]= mVORTEX(x,y,z,Xw(1,4,:),Xw(2,4,:),Xw(3,4,:),Xw(1,1,:),Xw(2,1,:),Xw(3,1,:),GAMw);    
        u=u+u4; v=v+v4; w=w+w4;
        VBW(1,n,i)=VBW(1,n,i)+u;
        VBW(2,n,i)=VBW(2,n,i)+v;
        VBW(3,n,i)=VBW(3,n,i)+w;
    end
    end 
    
    %Rear wings
    %Contribution from wake of right wing
    GAMAw=GAMAw2_r(1,:);
    GAMw=reshape(GAMAw,1,1,nXw_r); %Gamw(1,1,nXw) and Xw(3,4,nXw) share the same shape
    Xw=Xw2_r(:,:,:,1);
    
    for i=1:nXb
    for n=1:4
        x=Xb(1,n,i);
        y=Xb(2,n,i);
        z=Xb(3,n,i);
        u=0.0; v=0.0; w=0.0;
        [u1,v1,w1]= mVORTEX(x,y,z,Xw(1,1,:),Xw(2,1,:),Xw(3,1,:),Xw(1,2,:),Xw(2,2,:),Xw(3,2,:),GAMw);
        u=u+u1; v=v+v1; w=w+w1;   
        [u2,v2,w2]= mVORTEX(x,y,z,Xw(1,2,:),Xw(2,2,:),Xw(3,2,:),Xw(1,3,:),Xw(2,3,:),Xw(3,3,:),GAMw);
        u=u+u2; v=v+v2; w=w+w2;
        [u3,v3,w3]= mVORTEX(x,y,z,Xw(1,3,:),Xw(2,3,:),Xw(3,3,:),Xw(1,4,:),Xw(2,4,:),Xw(3,4,:),GAMw);    
        u=u+u3; v=v+v3; w=w+w3;
        [u4,v4,w4]= mVORTEX(x,y,z,Xw(1,4,:),Xw(2,4,:),Xw(3,4,:),Xw(1,1,:),Xw(2,1,:),Xw(3,1,:),GAMw);    
        u=u+u4; v=v+v4; w=w+w4;
        VBW(1,n,i)=VBW(1,n,i)+u;
        VBW(2,n,i)=VBW(2,n,i)+v;
        VBW(3,n,i)=VBW(3,n,i)+w;
    end
    end 

    %Contribution from wake of left wing
    GAMAw=GAMAw2_r(2,:);
    GAMw=reshape(GAMAw,1,1,nXw_r); %Gamw(1,1,nXw) and Xw(3,4,nXw) share the same shape
    Xw=Xw2_r(:,:,:,2);
    for i=1:nXb
    for n=1:4
        x=Xb(1,n,i);
        y=Xb(2,n,i);
        z=Xb(3,n,i);
        u=0.0; v=0.0; w=0.0;
        [u1,v1,w1]= mVORTEX(x,y,z,Xw(1,1,:),Xw(2,1,:),Xw(3,1,:),Xw(1,2,:),Xw(2,2,:),Xw(3,2,:),GAMw);
        u=u+u1; v=v+v1; w=w+w1;   
        [u2,v2,w2]= mVORTEX(x,y,z,Xw(1,2,:),Xw(2,2,:),Xw(3,2,:),Xw(1,3,:),Xw(2,3,:),Xw(3,3,:),GAMw);
        u=u+u2; v=v+v2; w=w+w2;
        [u3,v3,w3]= mVORTEX(x,y,z,Xw(1,3,:),Xw(2,3,:),Xw(3,3,:),Xw(1,4,:),Xw(2,4,:),Xw(3,4,:),GAMw);    
        u=u+u3; v=v+v3; w=w+w3;
        [u4,v4,w4]= mVORTEX(x,y,z,Xw(1,4,:),Xw(2,4,:),Xw(3,4,:),Xw(1,1,:),Xw(2,1,:),Xw(3,1,:),GAMw);    
        u=u+u4; v=v+v4; w=w+w4;
        VBW(1,n,i)=VBW(1,n,i)+u;
        VBW(2,n,i)=VBW(2,n,i)+v;
        VBW(3,n,i)=VBW(3,n,i)+w;
    end
    end 
clear GAMAW GAMw Xw 
end
end

