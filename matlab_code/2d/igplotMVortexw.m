function [  ] = igplotMVortexw(v_,d_, GAMAw,nstep )
%Print and plot the magnitudes of the wake vortex
%INPUT
% GAMAw     wake vortex
% nstep     # of time steps
global fid folder
%Reference value for the circulation
    gama_=v_*d_;
    %fprintf(fid, '%6.3f',gama_*GAMAw);
    %fprintf(fid, '\n');
    f=figure();
    iodd=1:2:2*nstep-1;
    ieven=2:2:2*nstep;
    %Dimensional alues of the circulation
    GAMAwo=gama_*GAMAw(iodd);
    GAMAwe=gama_*GAMAw(ieven);
    it=1:nstep;
    plot(it, GAMAwo, 'o-k', it,GAMAwe, 'o-r');
    grid on;
    saveas(f,[folder 'GAMAw' '.tif']);
    close;
    
end

