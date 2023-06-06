function [ MVN ] = tbassembleMatrix( nxt_f,nxt_r,MVNs_f,MVNs_r,MVNs_12,MVNs_13,MVNs_14,...
  MVNs_21,MVNs_23,MVNs_24,MVNs_31,MVNs_32,MVNs_34,MVNs_41,MVNs_42,MVNs_43 )
%Assemblle 16 sub-matrices 
%INPUT
% nxt_f,nxt_r           size of the sub-matrices for front (f) and rear (r) wings
% MVNs_f(nxt_f,nxt_f,2) self-influence sub-matrices for front wings
% MVNs_r(nxt_r,nxt_r,2) self-influence sub-matrices for rear wings

% MVNs_11(nxt_f,nxt_f)=MVNs_f(nxt_f,nxt_f,1)
% MVNs_12(nxt_f,nxt_f)
% MVNs_13(nxt_f,nxt_r)
% MVNs_14(nxt_f,nxt_r)
% MVNs_21(nxt_f,nxt_f)
% MVNs_22(nxt_f,nxt_f)=MVNs_f(nxt_f,nxt_f,2)
% MVNs_23(nxt_f,nxt_r)
% MVNs_24(nxt_f,nxt_r)
% MVNs_31(nxt_r,nxt_f)
% MVNs_32(nxt_r,nxt_f)
% MVNs_33(nxt_r,nxt_r)=MVNs_r(nxt_r,nxt_r,1)
% MVNs_34(nxt_r,nxt_r)
% MVNs_41(nxt_r,nxt_f)
% MVNs_42(nxt_r,nxt_f)
% MVNs_43(nxt_r,nxt_r)
% MVNs_44(nxt_r,nxt_r)=MVNs_r(nxt_r,nxt_r,2)

%OUTPUT
% MVN((2*nxt_f+  2*nxt_r), (2*nxt_f+  2*nxt_r))

    MVN(               1 :   nxt_f,                          1 :   nxt_f         )=MVNs_f( 1:nxt_f,1:nxt_f,1);
    MVN(               1 :   nxt_f,           (  nxt_f      +1): 2*nxt_f         )=MVNs_12(1:nxt_f,1:nxt_f );
    MVN(               1 :   nxt_f,           (2*nxt_f      +1):(2*nxt_f+  nxt_r))=MVNs_13(1:nxt_f,1:nxt_r );
    MVN(               1 :   nxt_f,           (2*nxt_f+nxt_r+1):(2*nxt_f+2*nxt_r))=MVNs_14(1:nxt_f,1:nxt_r );
    MVN((  nxt_f      +1): 2*nxt_f,                          1 :   nxt_f)         =MVNs_21(1:nxt_f,1:nxt_f );
    MVN((  nxt_f      +1): 2*nxt_f,           (  nxt_f      +1): 2*nxt_f         )=MVNs_f( 1:nxt_f,1:nxt_f,2);
    MVN((  nxt_f      +1): 2*nxt_f,           (2*nxt_f      +1):(2*nxt_f+  nxt_r))=MVNs_23(1:nxt_f,1:nxt_r );
    MVN((  nxt_f      +1): 2*nxt_f,           (2*nxt_f+nxt_r+1):(2*nxt_f+2*nxt_r))=MVNs_24(1:nxt_f,1:nxt_r );
    MVN((2*nxt_f      +1):(2*nxt_f+    nxt_r),               1 :   nxt_f         )=MVNs_31(1:nxt_r,1:nxt_f );
    MVN((2*nxt_f      +1):(2*nxt_f+    nxt_r),(  nxt_f      +1): 2*nxt_f         )=MVNs_32(1:nxt_r,1:nxt_f );
    MVN((2*nxt_f      +1):(2*nxt_f+    nxt_r),(2*nxt_f      +1):(2*nxt_f+  nxt_r))=MVNs_r( 1:nxt_r,1:nxt_r,1);
    MVN((2*nxt_f      +1):(2*nxt_f+    nxt_r),(2*nxt_f+nxt_r+1):(2*nxt_f+2*nxt_r))=MVNs_34(1:nxt_r,1:nxt_r );
    MVN((2*nxt_f+nxt_r+1):(2*nxt_f+  2*nxt_r),               1 :   nxt_f         )=MVNs_41(1:nxt_r,1:nxt_f );
    MVN((2*nxt_f+nxt_r+1):(2*nxt_f+  2*nxt_r),(  nxt_f      +1): 2*nxt_f         )=MVNs_42(1:nxt_r,1:nxt_f );
    MVN((2*nxt_f+nxt_r+1):(2*nxt_f+  2*nxt_r),(2*nxt_f      +1):(2*nxt_f+  nxt_r))=MVNs_43(1:nxt_r,1:nxt_r );
    MVN((2*nxt_f+nxt_r+1):(2*nxt_f+  2*nxt_r),(2*nxt_f+nxt_r+1):(2*nxt_f+2*nxt_r))=MVNs_r( 1:nxt_r,1:nxt_r,2);
    
end

