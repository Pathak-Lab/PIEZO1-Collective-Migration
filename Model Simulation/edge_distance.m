function [y] = edge_distance(ud,tol)
%% wound edges distance
%   the distance between two interfaces
% Jinghao Chen, jinghc2@uci.edu

N = size(ud,2)-1;
h = 1/N;
all_dist = zeros(N+1,1);

for i = 1:N+1
    all_dist(i) = h*length(nonzeros(ud(:,i)<=tol));
end

y = min(all_dist);

end