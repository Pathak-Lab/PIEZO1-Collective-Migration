function [ud1] = iter(ud,params,bc,ret)
%% one step iteration
%   inputs:
%       ud: cell density
%       params = [dt alp d ga k btype alp_type d1 d2]
%       bc: boundary condition
%       ret: retractrion info
% Jinghao Chen, jinghc2@uci.edu

M = size(ud,1)-1;
N = size(ud,2)-1;% this side is unit length
h = 1/N;
params(4) = params(4)*max(ud(:));% ensure retraction only happens around the front
[ud,ud1] = bdcond(ud,params(6),bc);

% diffusion-advection
i = 3:M+3;
j = 3:N+3;
ud1(i-2,j-2) = ud(i,j)+params(1)*(dif(ud(i,j-1),ud(i,j+1),ud(i-1,j),ud(i+1,j),ud(i,j),...
    ud(i-1,j-1),ud(i-1,j+1),ud(i+1,j-1),ud(i+1,j+1),...
    ud(i,j-2),ud(i,j+2),ud(i-2,j),ud(i+2,j),...
    [params(2) params(3) params(8) params(9) params(7) N])...
    +ret(6)*adv(ud(i,j-1),ud(i,j+1),ud(i-1,j),ud(i+1,j),ud(i,j),...
    [params(2) params(4) h params(5) params(7)],ret,h*(j-3)));

% rectification
ud1 = rectifier(ud1);

end