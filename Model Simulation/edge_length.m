function [ll,rl] = edge_length(egcell)
%% wound edge length
%   input: egcell is the output from edge_detection.m
%   output: ll and rl are lengths of left and right wound edge respectively
% Jinghao Chen, jinghc2@uci.edu

N = length(egcell)-1;
h = 1/N;

ll = sum(sqrt((egcell(2:end,1)-egcell(1:N,1)).^2+(h*ones(N,1)).^2));
rl = sum(sqrt((egcell(2:end,2)-egcell(1:N,2)).^2+(h*ones(N,1)).^2));

end

