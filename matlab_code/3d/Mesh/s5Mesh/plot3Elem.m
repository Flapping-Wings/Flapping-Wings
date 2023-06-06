function [ ] = plot3Elem( X,nX,N )
%Plot 3D elements with the unit normals
%INPUT
%X(j,n,i)   rectangulr element array
%nX         # of elements
%N(j,i)     Unit normal to the element
global folder
scale=0.1;
Nline=zeros(3,2);
%f=figure();
for i=1:nX
    %3D rectangulr elements
    for n=1:4
        x(n)=X(1,n,i);
        y(n)=X(2,n,i);
        z(n)=X(3,n,i);
    end
    x(5)=X(1,1,i);
    y(5)=X(2,1,i);
    z(5)=X(3,1,i);
    plot3(x,y,z,'k');
    hold on;
    %Unit normal at the centroid
    Nline(:,:)=[X(:,5,i),X(:,5,i)+scale*N(:,i)]; 
    plot3(Nline(1,:),Nline(2,:),Nline(3,:),'r');
    hold on;
    axis equal;
end
%saveas(f,[folder 'mesh/3dmesh.fig']);
%close;
end

