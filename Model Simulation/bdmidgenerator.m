function [bdmid] = bdmidgenerator(bc1,bc2,ndt)
%% randomness Dirichlet boundary smoothing
%   ensure the continuity of boundary functions
%   inputs:
%       bc1, bc2: randomly generated boundaries info
%       ndt: the time interval (period) between 2 changes for smoothing
% Jinghao Chen, jinghc2@uci.edu

% heatmap storage
bdmid = zeros(length(bc1),ndt);

% linear interp from bc1 (excluded) to bc2 (included)
i = 1:length(bc1);
j = 1:ndt;
bdmid(i,j) = bc1(i)+j.*(bc2(i)-bc1(i))./ndt;

end