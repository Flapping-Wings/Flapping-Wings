function [B]= SOLVER(N,A,B,IP)
%	REAL A(N,N),B(N),T
%	INTEGER IP(N)
%	SOLUTION OF LINEAR SYSTEM, A*X=B.
%	N=ORDER OF MATRIX.
%	B=RIGHT HAND SIDE VECTOR.
%	IP=PIVOT VEVTOR OBTAINED FROM SUBROUTINE DECOMP.
%	B=SOLUTION VECTOR X.
%
	if N~=1
        NM1=N-1;
        for K=1:NM1
            KP1=K+1;
            M=IP(K);
            T=B(M);
            B(M)=B(K);
            B(K)=T;
            for I=KP1:N
                B(I)=B(I)+A(I,K)*T;
            end
        end
        for KB=1:NM1
            KM1=N-KB;
            K=KM1+1;
            B(K)=B(K)/A(K,K);
            T=-B(K);
            for I=1:KM1
                B(I)=B(I)+A(I,K)*T;
            end
        end
    end
	B(1)=B(1)/A(1,1);

end
