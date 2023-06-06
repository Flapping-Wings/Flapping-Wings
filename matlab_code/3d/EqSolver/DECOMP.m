function [IP,A]= DECOMP(N,A)
%	REAL A(NDIM,NDIM),T
%	INTEGER IP(NDIM)
%	MATRIX TRIANGULARIZATION BY GAUSSIAN ELIMINATION.
%	N = ORDER OF MATRIX. NDIM = DECLARED DIMSISION OF ARRAY A.
%	A = MATRIX TO BE TRIANGULARIZED
%	IP(K) , K .LT. N = INDEX OF K-TH PIVOT ROW.
%
	IP(N)=1;
	for K=1:N
        if K < N
            KP1=K+1;
            M=K;
            for I=KP1:N
                if abs(A(I,K)) > abs(A(M,K))
                    M=I;
                end
            end
            IP(K)=M;
            if M ~= K 
                IP(N)=-IP(N);
            end
            T=A(M,K);
            A(M,K)=A(K,K);
            A(K,K)=T;
            if T ~= 0.E0
                for I=KP1:N
                   A(I,K)=-A(I,K)/T;
                end
                for J=KP1:N
                    T=A(M,J);
                    A(M,J)=A(K,J);
                    A(K,J)=T;
                    if T~=0.E0
                        for I=KP1:N
                            A(I,J)=A(I,J)+A(I,K)*T;
                        end
                    end
                end
            end
        end
        if A(K,K)==0.E0
            IP(N)=0;
        end
    end

end
