function [ Xc,nXc,Nc ] = WingCenter( Lt,Lr,C,delta,n,wi_1 )
%Meshing for the center eegion
%INPUT
%Lt     length of the tapered edge for the center region  
%Lr     length of the horizontal edge for the center region  
%C      length of the vertical tip edge of the center region
%delta  base opening angle/2 
%n(I)   number of border strip elements: I=1:5
%wi_1
%l      total wing span
%OUTPUT
%Xc     total center rectangular elements
%nXc    # of total center recangular elements
%Nc    Unit normal to the element
global itaper h_
%Coodinates of the nodes for the center region
[ Xct,Xcr ] = CRnodes( Lt,Lr,C,delta,n );

%RECTANGULAR MESH POONTS BY ROWS (x-direction) & COLUMNS (y-direction)
%For each element, the node start at left bottom and rotate clock-wise
% 2   3      ir,ic+1  ir+1,ic+1    
%   5    =
% 1   4      ir,ic    ir+1,ic
%x=horizontal, y=vertical directions
if itaper ==1
    %Tapered region
    for ic=1:n(1)
    for ir=1:n(3)        
        for j=1:2
            XctS(j,1,ir,ic)=Xct(j,ir,  ic);
            XctS(j,2,ir,ic)=Xct(j,ir,  ic+1);
            XctS(j,3,ir,ic)=Xct(j,ir+1,ic+1);
            XctS(j,4,ir,ic)=Xct(j,ir+1,ic);
        end
    end
    end
end
%Rectangular region
for ic=1:n(2)
    for ir=1:n(3)
        for j=1:2
            XcrS(j,1,ir,ic)=Xcr(j,ir,  ic);
            XcrS(j,2,ir,ic)=Xcr(j,ir,  ic+1);
            XcrS(j,3,ir,ic)=Xcr(j,ir+1,ic+1);
            XcrS(j,4,ir,ic)=Xcr(j,ir+1,ic);
        end
    end
end

%RECTANGULAR (&POLYGON) MESH

if itaper ==1
    %Tapered region============================================================
    %Triangular apex mesh with 4 nodes
    i=1;
    ic=1;
    for j=1:2
    XctR(j,1,i) =XctS(j,1,1,   ic);      
    XctR(j,2,i) =XctS(j,2,1,   ic);    
    XctR(j,4,i) =XctS(j,3,n(3),ic);
    end
    XctR(1,3,i) =0.0;
    XctR(2,3,i) =XctS(2,2,1,   ic);
    i=i+1;

    %Four sided meshes
    %i=2;
    for ic=2:n(1)
    for ir=1:n(3)
        for j=1:2
            XctR(j,1,i)  =XctS(j,1,ir,ic);
            XctR(j,2,i)  =XctS(j,2,ir,ic);
            XctR(j,3,i)  =XctS(j,3,ir,ic);
            XctR(j,4,i)  =XctS(j,4,ir,ic);
        end
        i=i+1;
    end
    end
    nXctR=i-1;
end
%Rectangular region========================================================
i=1;
for ic=1:n(2)
    for ir=1:n(3)
        for j=1:2
            XcrR(j,1,i)  =XcrS(j,1,ir,ic);
            XcrR(j,2,i)  =XcrS(j,2,ir,ic);
            XcrR(j,3,i)  =XcrS(j,3,ir,ic);
            XcrR(j,4,i)  =XcrS(j,4,ir,ic);
        end
        i=i+1;
    end
end
nXcrR=i-1;

if itaper == 1
    %Total center rectangular elements
    nXc=nXctR+nXcrR;
    Xc=zeros(2,4,nXc);
    Nc=zeros(3,nXc);

    Xc(:,:,1:nXctR)      =XctR;
    Xc(:,:,(1+nXctR):nXc)   =XcrR;
    %Introduce the camber (size(Xc)=(3,4,nXc))
    [ Xc(3,:,:) ] = Camber( Xc(1,:,:),Xc(2,:,:));
    %Unit normal to the element [size(uNc)=(3,nXc]
    for i=1:nXc
        [ Nc(:,i) ]=uNormal(Xc(1,:,i),Xc(2,:,i),Xc(3,:,i));
    end
    %Centroid (size(Xc)=(3,5,nXc))
    Xc(:,5,:)=0.25*(Xc(:,1,:)+Xc(:,2,:)+Xc(:,3,:)+Xc(:,4,:));
  
    
    %Add the eta-coordinate (vertical) of the corder
    yshift=wi_1/cos(delta);
    Xc(2,:,:)=Xc(2,:,:)+yshift;
else
    %Total center rectangular elements
    nXc=nXcrR;
    Xc=zeros(2,4,nXc);
    Nc=zeros(3,nXc);
    
    Xc(:,:,1:nXc)   =XcrR;
    %Introduce the camber (size(Xc)=(3,4,nXc))
    [ Xc(3,:,:) ] = Camber( Xc(1,:,:),Xc(2,:,:));
    %Unit normal to the element [size(uNc)=(3,nXc]
    for i=1:nXc
        [ Nc(:,i) ]=uNormal(Xc(1,:,i),Xc(2,:,i),Xc(3,:,i));
    end
    %Centroid (size(Xc)=(3,5,nXc))
    Xc(:,5,:)=0.25*(Xc(:,1,:)+Xc(:,2,:)+Xc(:,3,:)+Xc(:,4,:));
   
    %Add the eta-coordinate (vertical) of the corder
    yshift=h_;
    Xc(2,:,:)=Xc(2,:,:)+yshift;
end
end

