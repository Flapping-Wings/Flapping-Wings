function [VBT]=tbcrossvelBbyT(Xb,nXb,Xt,GAMA,nXt)
%Velocity  at border element nodes of wing i due to total vortices (nXt) on
%the wing j. The velocity is evaluated at the nodes; no offset 

%INPUT
% Xb(j,n,iXb)    coordinate j of observation node n of the wake element (destination)
% nXb            #of border vortices (destination)
% Xt(j,n,iXt)    coordinate j of source node n for the total element iXt on the wing)
% GAMA(iXt)      entire bound vortex (source)
% nXt            # of total elements on the wing (source)

%OUTPUT
%VBT(j,n,iXb)


VBT=zeros(3,4,nXb); 

GAMt=reshape(GAMA,1,1,nXt); 
for i=1:nXb
    for n=1:4
        x=Xb(1,n,i);
        y=Xb(2,n,i);
        z=Xb(3,n,i);
        u=0.0; v=0.0; w=0.0;
        [u1,v1,w1]= mVORTEX(x,y,z,Xt(1,1,:),Xt(2,1,:),Xt(3,1,:),Xt(1,2,:),Xt(2,2,:),Xt(3,2,:),GAMt);
        u=u+u1; v=v+v1; w=w+w1;   
        [u2,v2,w2]= mVORTEX(x,y,z,Xt(1,2,:),Xt(2,2,:),Xt(3,2,:),Xt(1,3,:),Xt(2,3,:),Xt(3,3,:),GAMt);
        u=u+u2; v=v+v2; w=w+w2;
        [u3,v3,w3]= mVORTEX(x,y,z,Xt(1,3,:),Xt(2,3,:),Xt(3,3,:),Xt(1,4,:),Xt(2,4,:),Xt(3,4,:),GAMt);    
        u=u+u3; v=v+v3; w=w+w3;
        [u4,v4,w4]= mVORTEX(x,y,z,Xt(1,4,:),Xt(2,4,:),Xt(3,4,:),Xt(1,1,:),Xt(2,1,:),Xt(3,1,:),GAMt);    
        u=u+u4; v=v+v4; w=w+w4;
        VBT(1,n,i)=u;
        VBT(2,n,i)=v;
        VBT(3,n,i)=w;
    end
end 

clear GAMt;  

end

