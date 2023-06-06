%function [ ] = s5Mesh(  )
function [ Xb,nXb,Nb,Xc,nXc,Nc, lo_,co_ ] = tbs5Mesh(W,lt_,lr_,bang_,hfac,wfac  )
%INPUT
% W = 1(forward), 2(Rear) wing

%OUTPUT
% lo_   span
% co_   chord length

%Symmetrical tapered mesh
%GLOBAL VARIABLES
global ielong hfactor wfactor itaper  c_  l_
global icamber acamber  
global mplot  fid  folder 

mplot=1;


%RECTANGULR ELEMENTS COUNT
%nXb     # of shed edge elements
%nXc     # of center elements


%==========WING GEOMETRY
%lt_ 	tapered section wing span (cm)
%lr_    square section wing span (cm)
%bang_  base angle (deg)
%c_     chord length of the rectangular section
%       = 2*lt_sin(bang): cannot be specified independeltly
    itaper = 1; %assume a tapered wing by default
    %lt_=0.5;
    %lr_=0.5;
    %bang_=30;   %90 Produces a rectangular wing
    if bang_ == 90
        itaper = 0;
    end
    bang=pi*bang_/180.0;
    %Chord length
    c_=2.0*lt_*sin(bang);
    %Span length
    l_=    lt_*cos(bang)+lr_;
%Height of border strip
    hfactor=hfac;   %ratio of h_ over c_
                    %use 0.1 for high aspect ration wing (chord < span)
                    %use 0.05 or smaller for low aspect ration wing (chord > span)
%Width of the border ectangular elements
    wfactor = wfac; % ratio of w (element width) over h (height)
%Fixed # of border elements: ielong 0 (no) 1 (yes)
    %Use he same nunber of divisions as that for the tip border strip
    ielong=0;
%Center Elements
%{
%If ielong=0 then use the number of the border strip, n(I), to create rectangular grid
    %Tapered section
    nCelmti=n(3);  %# of major division in x-direction
    nCelmtj=n(1);  %# of major division in y-direction
    %Rectangular section
    nCelmri=n(3);  %# of square elements in x-direction
    nCelmrj=n(2);  %# of square elements in y-direction 
%If ielong=1 then use n(3) to create rectangular grid
    %Tapered section
    nCelmti=n(3);  %# of major division in x-direction
    nCelmtj=n(3);  %# of major division in y-direction
    %Rectangular section
    nCelmri=n(3);  %# of square elements in x-direction
    nCelmrj=n(3);  %# of square elements in y-direction 
%}

%Camber direction: 0(no camber), 1(x-direction), 2(y-direction), 3(both directions)
    icamber = 0;
    acamber=0.2;    %Camber amplitude

%Elemnts in the border strips
    %Xb(j,n,i)    Borger elements
    %nXb          # of border elements
    %Nb(j,i)      Unit normal
    [ Xb,nXb,Nb,Lt,Lr,C,n,wi_1] = WingBorder(lt_,lr_,bang);
    
%Elements in the center region
    %Xc(j,n,i)    Center elements
    %nXc          # of center elements
    %Nc(j,i)      Unit normal
    [ Xc,nXc,Nc ] = WingCenter(Lt,Lr,C,bang,n,wi_1);
%Output l_ and c_
    lo_=l_;
    co_=c_;
%Plot mesh
    if mplot ==1
        f2=figure();
        plot2Elem(Xb,nXb,4,'r',2);
        plot2Elem(Xc,nXc,4,'b',2);
        %title(['lt= ',num2str(lt_),'   lr= ',num2str(lr_), '   bang= ',num2str(bang_),'   hfactor= ', num2str(hfactor), '   wfactor= ', num2str(wfactor)]);
        saveas(f2,[folder 'mesh/2dmesh_',num2str(W),'.fig']);
        close;
        f3=figure();
        plot3Elem(Xb,nXb,Nb);
        plot3Elem(Xc,nXc,Nc);
        %title(['lt= ',num2str(lt_),'   lr= ',num2str(lr_), '   bang= ',num2str(bang_),'   hfactor= ', num2str(hfactor), '   wfactor= ', num2str(wfactor)]);
        saveas(f3,[folder 'mesh/3dmesh_',num2str(W),'.fig']);
        close;
    end

    fprintf(fid, 'W = %3d, lt_   = %6.3f, lr_= %6.3f, l_ = %6.3f, bang_  = %6.3f, c_   = %6.3f, hfactor = %6.3f, wfactor = %6.3f\n', ...
            W,lt_,lr_,l_,bang_,c_,hfactor,wfactor);
     
end

