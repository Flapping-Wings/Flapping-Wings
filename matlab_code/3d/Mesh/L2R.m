function [ xb,nb,xc,nc ]=L2R( xb,nb,xc,nc )
%ransform from the lHS to RHS
xb(2,:,:)=-xb(2,:,:);
xc(2,:,:)=-xc(2,:,:);
nb(2,:)  =-nb(2,:);
nc(2,:)  =-nc(2,:);

end

