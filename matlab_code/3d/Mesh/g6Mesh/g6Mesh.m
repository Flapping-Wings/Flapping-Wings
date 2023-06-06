%function [  ] = g6Mesh(  )
function [Xb,nXb,Nb,Xc,nXc,Nc  ] = g6Mesh(  )
%General 6-sided polygonal mesh with border strip
%{
1********2*********3
*                  *
*                  *
6**********5*******4

%}
%The center region consists of two (semi) rectangular regions.
%The mesh consists of all four sided elements

global wfactor nplot  mplot nside
global l_ c_ h_ fid

nside=6;

nplot=0;
%Ration of border edge element width over height (h)
    wfactor =4;
%Ratio of h over the chord length c
    hfactor = 0.05;
%Open an Output File:    
%    fid=fopen('mesh_output.txt','w');
%Example number
    example=7;
%Coordinate shift default (Bring the origin to the wing base center)
    dxi=0.0;
    deta=0.0;
%Specify the outer contour for nside edges
switch example
    case 1
        alpha=[95,100,10, -70, -90];
        alpha=pi*alpha/180.0;
        l=[1,1,0.3,1,1];
    case 2
        %Give data for 4 lines
        alpha=[90,90,0, -90,-90];
        alpha=pi*alpha/180.0;
        l=[1,1,1,1,1];
        dxi=-0.5;
        deta=0.0;
    case 3
        %Give data for 4 lines
        alpha=[95,100,-5, -45];
        alpha=pi*alpha/180.0;
        l=[1,0.5,0.5,0.75];
    case 4
        %Give data for 4 lines
        alpha=[170,100,-15, -90];
        alpha=pi*alpha/180.0;
        l=[0.5,1,1,0.5];
    case 5
        %Give data for 4 lines
        alpha=[180,100,-5,0, -180];
        alpha=pi*alpha/180.0;
        l=[0.5,1,1,0,0.5];
    case 6
        %Give data for 4 lines
        alpha=[150,100,-20,-60];
        alpha=pi*alpha/180.0;
        l=[1,0.75,1.5,0.75];
    case 7
        %Give data for 5 lines
        alpha=[95,90,-10,-95,-100];
        alpha=pi*alpha/180.0;
        l=[1,1,0.6,0.9,0.9];
        dxi=0.0;
        deta=0.2;
end
 
%Determine the length and slope of the 6th line using the closed contour condition
    lexp=l.*exp(1i*alpha);
    rlexp=sum(real(lexp));
    ilexp=sum(imag(lexp));
    l(nside)=sqrt(rlexp*rlexp+ilexp*ilexp);
    alpha(nside)=atan2(-ilexp,-rlexp);  
    fprintf(fid,'l= %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f\n',l);
    fprintf(fid,'alpha= %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f\n',alpha);

%Determine the coordinates of the nodes
    lexp=l.*exp(1i*alpha);
    tmp=zeros(1,nside+1);
    zeta=complex(tmp,tmp);
    for n=2:(nside+1)
        zeta(n)=zeta(n-1)+lexp(n-1);
    end
    xi=real(zeta);
    eta=imag(zeta);
    if nplot ==1
        plot(xi,eta,'-o');
        axis equal;
        hold on;
    end

%Determine the representative chord length and span length
%c=max(abs(zeta(2)-zeta(5)),abs(zeta(3)-zeta(4))); %This choice should be modified depending on l and alpha.
    c   =max(xi)-min(xi);
    span=max(eta);
    fprintf(fid,'c= %6.3f, span= %6.3f\n',c,span);
%height of the offset border relative to the chord length
    h=hfactor*c;
    fprintf(fid,'hfactor= %6.3f, wfactor= %6.3f\n',hfactor,wfactor);
%Internal offset contour
    [z]=offset_g6(h,l,alpha,zeta);

%Center region geometry
    [n,w]=center_g6(z,h);

%Center contour sub nodes (used to determine center elements)
    [Zt,Zr,z12,z23,z34,z45,z56,z61 ] = centerSN_g6(n,z);

%Border contour sub nodes
    [Z12,Z23,Z34,Z45,Z56,Z61 ] = borderSN_g6(h,alpha,zeta,z12,z23,z34,z45,z56,z61 );

%Border elements
    [Xb,nXb ] = BElem_g6(Z12,Z23,Z34,Z45,Z56,Z61,z12,z23,z34,z45,z56,z61);
    %Shift
    Xb(1,:,:)=Xb(1,:,:)+dxi;
    Xb(2,:,:)=Xb(2,:,:)+deta;
    if mplot ==1
        plot2Elm( Xb,nXb,4,'k',2 );
    end

%Center elements
    [ Xc,nXc] = CElem_g6(n, Zt,Zr); 
    %Shift
    Xc(1,:,:)=Xc(1,:,:)+dxi;
    Xc(2,:,:)=Xc(2,:,:)+deta;
    if mplot ==1
        plot2Elm( Xc,nXc,4,'b',2 );
        a=alpha*180.0/pi;
        title(['l= [',num2str(l(1)),' ',num2str(l(2)),' ',num2str(l(3)),' ',num2str(l(4)),' ',num2str(l(5)),' ',num2str(l(6)),']   ',...
           'a= [',num2str(a(1)),' ',num2str(a(2)),' ',num2str(a(3)),' ',num2str(a(4)),' ',num2str(a(5)),' ',num2str(a(6)),']   ',...
           'nXb= ',num2str(nXb),' nXc= ',num2str(nXc)]);
    end
    fprintf(fid,'nXb= %6.3f, nXc= %6.3f\n',nXb,nXc);
%add the j=3 component to Xb, Xc
    s=size(Xb);
    Xb(3,1:s(2),1:s(3))=0.0;
    s=size(Xc);
    Xc(3,1:s(2),1:s(3))=0.0;  
%Unit normal to the element
    Nb=zeros(3,nXb);
    Nc=zeros(3,nXc);
    Nb(3,:)=1.0;
    Nc(3,:)=1.0;
%put span, c and h into the global
    l_=span;
    c_=c;
    h_=h;
end

