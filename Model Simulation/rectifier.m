function [ud] = rectifier(ud)
%% rectification function
%   used to constrain cell density within [0,1]
% Jinghao Chen, jinghc2@uci.edu

ud(ud<0) = 0;
ud(ud>1) = 1;

end

