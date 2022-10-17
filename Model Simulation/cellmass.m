function [m] = cellmass(ud,stripidx1,stripidx2)
%% Cell mass
%   integrating the cell mass in the given banded region
%   from stripidx1 to stripidx2
% Jinghao Chen, jinghc2@uci.edu

N = size(ud,2)-1;% unit side
h = 1/N;

m = sum(ud(stripidx1:stripidx2,:),'all')*h^2;

end

