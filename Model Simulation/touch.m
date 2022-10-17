function [y] = touch(ud,tol)
%% wound closure criterion - interfaces touching
%   inputs: ud: cell density, tol: tolerance
%   output: y: 0 for not touching (not closed), otherwise closed
% Jinghao Chen, jinghc2@uci.edu

y = 0;
M = size(ud,1)-1;
N = size(ud,2)-1;

for i = 1:N+1
    y = y+(length(nonzeros(ud(:,i)>tol)) == M+1);
end

end