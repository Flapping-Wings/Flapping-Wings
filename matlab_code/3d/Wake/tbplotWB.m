function [  ] = tbplotWB(m,istep,nXb,nXw,Xb,Xw)
%Plot  wake elements along with the original border elements
%INPUT
% m                    1(front), 2(rear) wing
% istep                # of time step
% nXb                  # of border vortices
% nXw                  # of wake vortices 
% Xb(j,inode,iXb,w)    coordinate j of inode node point for the border iXb
% Xw(j,inode,iXw,w)    coordinate j of inode point for wake element iXb of wing w

%INDEX
  % w           1(right), 2(left) wing
  % inode       1:4     index of velocity calculation sites for each element
  % iXb         1:nXb   index of shed vortice elements
  % j           1:3     (x,y,z)

global folder nwing wpfig
if m == 1
    wpfig=figure();
end
   
%Border elements original
for w=1:nwing
    for i=1:nXb
        x=[Xb(1,1,i,w),Xb(1,2,i,w),Xb(1,3,i,w),Xb(1,4,i,w),Xb(1,1,i,w)];
        y=[Xb(2,1,i,w),Xb(2,2,i,w),Xb(2,3,i,w),Xb(2,4,i,w),Xb(2,1,i,w)];
        z=[Xb(3,1,i,w),Xb(3,2,i,w),Xb(3,3,i,w),Xb(3,4,i,w),Xb(3,1,i,w)];    
        plot3(x,y,z,'r');
        view(3);
        hold on;
    end
end

if nXw ~= 0
%Wake elements 
for w=1:nwing
    for i=1:nXw
        x=[Xw(1,1,i,w),Xw(1,2,i,w),Xw(1,3,i,w),Xw(1,4,i,w),Xw(1,1,i,w)];
        y=[Xw(2,1,i,w),Xw(2,2,i,w),Xw(2,3,i,w),Xw(2,4,i,w),Xw(2,1,i,w)];
        z=[Xw(3,1,i,w),Xw(3,2,i,w),Xw(3,3,i,w),Xw(3,4,i,w),Xw(3,1,i,w)];  
        if w == 1
            plot3(x,y,z,'k');
        else
            plot3(x,y,z,'b');
        end
        view(3);
        hold on;
    end
end
end

    axis equal;
    if m == 2
        hold off
        saveas(wpfig,[folder, '/wake/wake_', num2str(istep), '.fig']);
        close;
    end
    clear x y z;
end

