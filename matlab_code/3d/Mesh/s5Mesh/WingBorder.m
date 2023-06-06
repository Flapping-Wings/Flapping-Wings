function [ Xb,nXb,Nb,Lt,Lr,C,n,wi_1 ] = WingBorder( lt,lr,delta)
%Mesh for tapered/nontapered rectangular wings
%INPUT
%lt     length of the tapered section
%lr     length of the rectangular section
%delta  half taper angle (radian)



%OUTPUT
%Xb(j,n,i)  entire shed rectangular edge elements
%nXb        # of border rectangukar shed elements
%Nb(j,i)   unit normal vector for the rectangular element
%Lt
%Lr
%C
%n(I)       # of rectangles in the border strip 
%wi_1

global ielong h_ hfactor c_ 
%%%%%%%%%%BORDER STRIPS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=5; %# of border strips
h_=hfactor*c_;  %height of the border strip
c=c_;           %dimensional chord length
h=h_;           %dimensional border height
%Global position of the origin of the border strip systems
sdel=sin(delta);
cdel=cos(delta);
xo(1,1)=0.0;
xo(2,1)=0.0;
xo(1,2)=-lt*sdel;
xo(2,2)= lt*cdel;
xo(1,3)=-lt*sdel;
xo(2,3)= lt*cdel+lr;
xo(1,4)= lt*sdel;
xo(2,4)= lt*cdel+lr;
xo(1,5)= lt*sdel;
xo(2,5)= lt*cdel;
ang(1)=delta;
ang(2)=0.0;
ang(3)=-0.5*pi;
ang(4)=-pi;
ang(5)=-(pi+delta);

%Width of the rectangular elements in the border strips & # of rectangular elements on them
if ielong == 0
[ n,w,wi,wf,Lt,Lr,C ] = BStrip( lt,lr,c,delta,h );
else
[ n,w,wi,wf,Lt,Lr,C ] = BStripElongated( lt,lr,c,delta,h );
end

sumn=sum(n);
nXb=sumn;  %No corner elements
Xb=zeros(2,5,nXb);
Nb=zeros(3,nXb);

inf=0;

%I=1;
for I=1:N
    [ xeE ] = BRelemLoc(n(I),wi(I),w(I),wf(I),h);
    [ xeE ] = BRelem( xeE,xo(:,I),ang(I));
    Xb(:,1,  (inf+1))=xeE(:,1,1);
    Xb(:,2:4,(inf+1))=xeE(:,2:4,2);
    %Xb(:,5,  (inf+1))=0.25*(Xb(:,1,(inf+1))+Xb(:,2,(inf+1))+Xb(:,3,(inf+1))+Xb(:,4,(inf+1)));
    inf=inf+(  n(I));
    ini=inf-(  n(I))+2;
    Xb(:,:,ini:inf)  =xeE(:,:,3:(n(I)+1));
    Xb(:,2,inf)      =xeE(:,2,n(I)+2);
    %Xb(:,5,inf)=0.25*(Xb(:,1,inf)+Xb(:,2,inf)+Xb(:,3,inf)+Xb(:,4,inf));
end
%Introduce the camber [size(Xb)=(3,4,nXb)]
    [ Xb(3,:,:) ] = Camber( Xb(1,:,:),Xb(2,:,:));
%Unit normal to the element [size(uNb)=(3,nXb]
for i=1:nXb
    [ Nb(:,i) ]=uNormal(Xb(1,:,i),Xb(2,:,i),Xb(3,:,i));
end
%Centroid [size(Xb)=(3,5,nXb)]
    Xb(:,5,:)=0.25*(Xb(:,1,:)+Xb(:,2,:)+Xb(:,3,:)+Xb(:,4,:));
wi_1=wi(1);
end

