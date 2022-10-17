function [egcell] = edge_detection(ud,tol)
%% edge cells detection
%   inputs:
%       ud: cell density
%       tol: tolerance
% Jinghao Chen, jinghc2@uci.edu

M = size(ud,1)-1;
N = size(ud,2)-1;% unit length side
h = 1/N;

egcell = round(M/N)*ones(N+1,2);
egcell(:,1) = 0;

for j = 1:N+1
    for i = M+1:-1:2
        if ud(i-1,j)>tol && ud(i,j)<=tol
            egcell(j,1) = h*(i-1);% since i=1 for 0
        end
    end
    for i = 1:M
        if ud(i,j)<=tol && ud(i+1,j)>tol
            egcell(j,2) = h*(i-1);
        end
    end
end

end
