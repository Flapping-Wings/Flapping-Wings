function [Vncw] = tbnvelTbyW(istep,nXt,XC, NC, Xw2_f, GAMAw2_f, nXw_f, Xw2_r, GAMAw2_r, nXw_r)
%Normal velocity contribution on the airfoil by the wake vortex
%INPUT
% nXt                    # of collocation points
% XC(j,i)   (3,nXt)      whole collocation points
% NC        (3,nXt)      unit normal at the collocation points
% Xw2_f     (3,4,nXw_f,nwing)    location of the wake vortices
% GAMAw2_f  (nwing,nXw_f)      wake vortex. USE the value set in the previous step
% nXw_f                    # of wake vortices=istep*nXb. USE the value set in the previous step
% Xw2_r     (3,4,nXw_r,nwing)    location of the wake vortices
% GAMAw2_r  (nwing,nXw_r)      wake vortex. USE the value set in the previous step
% nXw_r                    # of wake vortices=istep*nXb. USE the value set in the previous step
%OUTPUT
% Vncw      (1,nXt)      normal velocity components at the collocation points due to the wake vortices
%Initialize the normal velocity vector
Vncw=zeros(1,nXt); %return value for step=1
if istep > 1
    %Contribution from forward wing wake
    GAMAw=GAMAw2_f(1,:);
    GAMw=reshape(GAMAw,1,1,nXw_f);
    Xw=Xw2_f(:,:,:,1);
    for i=1:nXt
        x=XC(1,i);
        y=XC(2,i);
        z=XC(3,i);
        u=0.0; v=0.0; w=0.0;
    
        [u1,v1,w1]= mVORTEX(x,y,z,Xw(1,1,:),Xw(2,1,:),Xw(3,1,:),Xw(1,2,:),Xw(2,2,:),Xw(3,2,:),GAMw);
        u=u+u1; v=v+v1; w=w+w1;   
        [u2,v2,w2]= mVORTEX(x,y,z,Xw(1,2,:),Xw(2,2,:),Xw(3,2,:),Xw(1,3,:),Xw(2,3,:),Xw(3,3,:),GAMw);
        u=u+u2; v=v+v2; w=w+w2;
        [u3,v3,w3]= mVORTEX(x,y,z,Xw(1,3,:),Xw(2,3,:),Xw(3,3,:),Xw(1,4,:),Xw(2,4,:),Xw(3,4,:),GAMw);    
        u=u+u3; v=v+v3; w=w+w3;
        [u4,v4,w4]= mVORTEX(x,y,z,Xw(1,4,:),Xw(2,4,:),Xw(3,4,:),Xw(1,1,:),Xw(2,1,:),Xw(3,1,:),GAMw);    
        u=u+u4; v=v+v4; w=w+w4;
    
        Vncw(i)=u*NC(1,i)+v*NC(2,i)+w*NC(3,i);    
    end
    
    GAMAw=GAMAw2_f(2,:);
    GAMw=reshape(GAMAw,1,1,nXw_f); 
    Xw=Xw2_f(:,:,:,2);
    for i=1:nXt
        x=XC(1,i);
        y=XC(2,i);
        z=XC(3,i);
        u=0.0; v=0.0; w=0.0;
    
        [u1,v1,w1]= mVORTEX(x,y,z,Xw(1,1,:),Xw(2,1,:),Xw(3,1,:),Xw(1,2,:),Xw(2,2,:),Xw(3,2,:),GAMw);
        u=u+u1; v=v+v1; w=w+w1;   
        [u2,v2,w2]= mVORTEX(x,y,z,Xw(1,2,:),Xw(2,2,:),Xw(3,2,:),Xw(1,3,:),Xw(2,3,:),Xw(3,3,:),GAMw);
        u=u+u2; v=v+v2; w=w+w2;
        [u3,v3,w3]= mVORTEX(x,y,z,Xw(1,3,:),Xw(2,3,:),Xw(3,3,:),Xw(1,4,:),Xw(2,4,:),Xw(3,4,:),GAMw);    
        u=u+u3; v=v+v3; w=w+w3;
        [u4,v4,w4]= mVORTEX(x,y,z,Xw(1,4,:),Xw(2,4,:),Xw(3,4,:),Xw(1,1,:),Xw(2,1,:),Xw(3,1,:),GAMw);    
        u=u+u4; v=v+v4; w=w+w4;
    
        Vncw(i)=Vncw(i)+u*NC(1,i)+v*NC(2,i)+w*NC(3,i);    
    end    
    %Contribution from rear wing wake
    GAMAw=GAMAw2_r(1,:);
    GAMw=reshape(GAMAw,1,1,nXw_r);
    Xw=Xw2_r(:,:,:,1);
    for i=1:nXt
        x=XC(1,i);
        y=XC(2,i);
        z=XC(3,i);
        u=0.0; v=0.0; w=0.0;
    
        [u1,v1,w1]= mVORTEX(x,y,z,Xw(1,1,:),Xw(2,1,:),Xw(3,1,:),Xw(1,2,:),Xw(2,2,:),Xw(3,2,:),GAMw);
        u=u+u1; v=v+v1; w=w+w1;   
        [u2,v2,w2]= mVORTEX(x,y,z,Xw(1,2,:),Xw(2,2,:),Xw(3,2,:),Xw(1,3,:),Xw(2,3,:),Xw(3,3,:),GAMw);
        u=u+u2; v=v+v2; w=w+w2;
        [u3,v3,w3]= mVORTEX(x,y,z,Xw(1,3,:),Xw(2,3,:),Xw(3,3,:),Xw(1,4,:),Xw(2,4,:),Xw(3,4,:),GAMw);    
        u=u+u3; v=v+v3; w=w+w3;
        [u4,v4,w4]= mVORTEX(x,y,z,Xw(1,4,:),Xw(2,4,:),Xw(3,4,:),Xw(1,1,:),Xw(2,1,:),Xw(3,1,:),GAMw);    
        u=u+u4; v=v+v4; w=w+w4;
    
        Vncw(i)=Vncw(i)+u*NC(1,i)+v*NC(2,i)+w*NC(3,i);    
    end
    
    GAMAw=GAMAw2_r(2,:);
    GAMw=reshape(GAMAw,1,1,nXw_r); 
    Xw=Xw2_r(:,:,:,2);
    for i=1:nXt
        x=XC(1,i);
        y=XC(2,i);
        z=XC(3,i);
        u=0.0; v=0.0; w=0.0;
    
        [u1,v1,w1]= mVORTEX(x,y,z,Xw(1,1,:),Xw(2,1,:),Xw(3,1,:),Xw(1,2,:),Xw(2,2,:),Xw(3,2,:),GAMw);
        u=u+u1; v=v+v1; w=w+w1;   
        [u2,v2,w2]= mVORTEX(x,y,z,Xw(1,2,:),Xw(2,2,:),Xw(3,2,:),Xw(1,3,:),Xw(2,3,:),Xw(3,3,:),GAMw);
        u=u+u2; v=v+v2; w=w+w2;
        [u3,v3,w3]= mVORTEX(x,y,z,Xw(1,3,:),Xw(2,3,:),Xw(3,3,:),Xw(1,4,:),Xw(2,4,:),Xw(3,4,:),GAMw);    
        u=u+u3; v=v+v3; w=w+w3;
        [u4,v4,w4]= mVORTEX(x,y,z,Xw(1,4,:),Xw(2,4,:),Xw(3,4,:),Xw(1,1,:),Xw(2,1,:),Xw(3,1,:),GAMw);    
        u=u+u4; v=v+v4; w=w+w4;
    
        Vncw(i)=Vncw(i)+u*NC(1,i)+v*NC(2,i)+w*NC(3,i);    
    end      
    clear  GAMAw GAMw Xw;
end
end

