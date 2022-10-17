function [ud,bc] = inicond(ibc,pdtype,h)
%% initial condition
%   inputs：
%       ibc: initial boundary condition
%       pdtype: pure diffusion type, 0 for no diffusion (just ibc)
%           1 for diffusion based on ibc, 2 for a given initial condition
%           default value: 2, invariant to compare the simulation results
%       h: grid size
%   outputs:
%       ud: cell density
%       bc: boundary condition
% Jinghao Chen, jinghc2@uci.edu

[x,y] = meshgrid(0:h:1);

if 1/h == 50
    dt = 1e-4;
elseif 1/h == 100
    dt = 1e-5;
else
    dt = 5e-4;
end

% initial boundary condition data
bc = zeros(4,1);% Dirichlet boundary condition, left-right-up-down order

% different initial & boundary conditions
if ibc == 1% 2D Gaussian function
    % btype = 1;
    u = @(x,y) 0.9*exp(-20*(x-0.5).^2-20*(y-0.5).^2);
elseif ibc == 2% single heaviside initial data
    bc(3) = 1; % btype = 2;
    u = @(x,y) heaviside(y-0.5);
elseif ibc == 3% double heaviside initial data
    ws = 0.05;
    bc(3) = 1; bc(4) = 1; % btype = 3;
    u = @(x,y) (heaviside(ws-y)+heaviside(y-1+ws));
elseif ibc == 4% zero initial data
    [bc(3),bc(4)] = deal(1); % btype = 2;
    u = @(x,y) 0*x;
elseif ibc == 5% sinunoidal-type
    ws = 7;
    f = @(x) 0.1-0.05*sin(ws*pi*x); g = @(x) 0.9+0.05*sin(ws*pi*x);
    bc(3) = 1; bc(4) = 1; % btype = 3;
    u = @(x,y) heaviside(f(x)-y)+heaviside(y-g(x));
end
ud = u(x,y);

% let it diffuses for a while, to gain a natural shape.
if pdtype == 1
    t = 0;
    % this diffusion way is independent, and different with
    % current one in the model, which use much simpler method.
    while t < 0.02
        ud = iter0(ud,dt,0.75,2,[0;0;1;1]);
        t = t+dt;
    end
elseif pdtype == 2
    iniud = load([pwd '/iniud']);% a built-in initial condition
    ud = iniud.ud;
end

end