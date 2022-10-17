function [ws] = wscale(ud,tol)
%% wound scale
%   output ws represents the proportion of the wound area 
%   (normalized) in the whole domain
% Jinghao Chen, jinghc2@uci.edu

ws = sum(ud(:)<=tol)/length(ud(:));

end