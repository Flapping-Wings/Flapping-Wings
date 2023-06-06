%function [  ] = g5Mesh(  )
function [Xb,nXb,Nb,Xc,nXc,Nc  ] = g5Mesh(  )
%General 5-sided polygonal mesh with border strip
%The center region consists of the tapered region near the wing base and
%a (semi) rectangular region near the tip.
%The mesh consists of all four sided elements

global wfactor itaper cplot nplot mplot
global l alpha
global l_ c_ h_ fid

cplot=0;
nplot=0;
%Ration of border edge element width over height (h)
    wfactor =3;
%Ratio of h over the chord length c
    hfactor = 0.05;
%Open an Output File:    
%    fid=fopen(['mesh_output.txt'],'w');
%Example number
    example=6;
%Specify the outer contour for 4 edged
switch example
    case 1
        itaper=1;
        alpha=[135,90,0, -90, -135];
        alpha=pi*alpha/180.0;
        l=[1,1,-2*cos(alpha(1)),1,1];

        %consistency check: should be zero
        sum(l.*sin(alpha))
        sum(l.*cos(alpha))
    case 2
        itaper=1;
        %Give data for 4 lines
        alpha=[135,100,5, -45];
        alpha=pi*alpha/180.0;
        l=[1,0.8,0.5,1];
    case 3
        itaper=1;
        %Give data for 4 lines
        alpha=[95,100,-5, -45];
        alpha=pi*alpha/180.0;
        l=[1,0.5,0.5,0.75];
    case 4
        itaper=1;
        %Give data for 4 lines
        alpha=[170,100,-15, -90];
        alpha=pi*alpha/180.0;
        l=[0.5,1,1,0.5];
    case 5
        itaper=0;
        %Give data for 4 lines
        alpha=[180,100,-5,0, -180];
        alpha=pi*alpha/180.0;
        l=[0.5,1,1,0,0.5];
    case 6
        itaper=1;
        %Give data for 4 lines
        alpha=[150,100,-20,-60];
        alpha=pi*alpha/180.0;
        l=[1,0.75,1.5,0.75];
end
if itaper ==1 
    %Determine the length and slope of the 5th line using the closed contour condition
    lexp=l.*exp(1i*alpha);
    rlexp=sum(real(lexp));
    ilexp=sum(imag(lexp));
    l(5)=sqrt(rlexp*rlexp+ilexp*ilexp);
    alpha(5)=atan2(-ilexp,-rlexp);   
else
    %Determine the length and slope of the 4th line using the closed contour condition
    lexp=l.*exp(1i*alpha);
    rlexp=real(lexp(1)+lexp(2)+lexp(3)+lexp(5));
    ilexp=imag(lexp(1)+lexp(2)+lexp(3)+lexp(5));
    l(4)=sqrt(rlexp*rlexp+ilexp*ilexp);
    alpha(4)=atan2(-ilexp,-rlexp); 
end
%Determine the coordinates of the nodes
    lexp=l.*exp(1i*alpha);
    tmp=zeros(1,6);
    zeta=complex(tmp,tmp);
    for n=2:6
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
    [z]=offset(h,l,alpha,zeta);

%Center region geometry
    [n,w]=center(z,h);

%Center contour sub nodes (used to determine center elements)
    [Zt,Zr,z12,z23,z34,z45,z51 ] = centerSN(n,z);

%Border contour sub nodes
    [Z12,Z23,Z34,Z45,Z51 ] = borderSN(h,alpha,zeta,z12,z23,z34,z45,z51 );

%Border elements
    [Xb,nXb ] = BElem(Z12,Z23,Z34,Z45,Z51,z12,z23,z34,z45,z51);
    if mplot ==1
        plot2Elm( Xb,nXb,4,'k',2 );
    end


%Center elements
    [ Xc,nXc] = CElem(n, Zt,Zr );
    if mplot == 1
        plot2Elm( Xc,nXc,4,'b',2 );
        a=alpha*180.0/pi;
        title(['l= [',num2str(l(1)),' ',num2str(l(2)),' ',num2str(l(3)),' ',num2str(l(4)),' ',num2str(l(5)),']   ',...
               'a= [',num2str(a(1)),' ',num2str(a(2)),' ',num2str(a(3)),' ',num2str(a(4)),' ',num2str(a(5)),']   ',...
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

