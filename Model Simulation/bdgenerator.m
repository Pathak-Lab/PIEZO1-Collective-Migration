function [bc] = bdgenerator(h,bdmu,bdsig,np)
%% randomness Dirichlet boundary generator
%   inputs: 
%       h: space step size, bdmu: mean, bdsig: std, np: number of pts
%   outputs: 
%       bc: contains boundary values
% Jinghao Chen, jinghc2@uci.edu

N = 1/h;

if np == N+1 % completely random
    bc = normrnd(bdmu,bdsig,[2*N+2,1]);
else
    bc = zeros(2*N+2,1);
    bp = normrnd(bdmu,bdsig,[2*np,1]);
    bp = rectifier(bp);% ensure in [0,1]
    x = 0:1/(np-1):1;
    xx = 0:h:1;
    bc(1:N+1) = spline(x,bp(1:np),xx);
    bc(N+2:end) = spline(x,bp(np+1:end),xx);
end

end