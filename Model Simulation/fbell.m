function [y] = fbell(x,params)
%% bell curve function exactly like Matlab function "gbellmf",
%% but less computational costy.
%   fbell(x,[a b c])
%   a = 0.3*(retraction width in wide, default 0.2)
%   b = 3 transition steepness
%   c bell center, randomly set
% Jinghao Chen, jinghc2@uci.edu

y = 1./(1+((x-params(3))./params(1)).^(2*params(2)));

end
