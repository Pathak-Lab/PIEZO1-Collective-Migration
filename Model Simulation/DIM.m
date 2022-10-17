function [] = DIM(data_path,params)
%% DIM, data initializing machine
%   inputs:
%       data_path, should be the complete path of data folder
%        params = [N Tr tol alp alp_type d d1 d2 l k ...
%           rdt nrdt rds nrds mu sig rw sl ibc btype pdtype prd_bd ...
%           bdm bdsd bdnp stripidx1 stripidx2]
% Jinghao Chen, jinghc2@uci.edu


%% grid setting

N = params(1);% grid size
if N == 50
    dt = 1e-4;
else
    dt = 1e-5;
end
h = 1/N;% spatial discretization size
T = 10;% stop time
Tr = params(2);% retraction activation time [optional]
tol = params(3);% wound edge tolerance

%% adhesion setting

alp = params(4);% adhesion coefficient, < 0.66 to ensure positive diffusivity
alp_type = params(5);
if alp_type > 2
    dt = 5e-5;% smaller dt is needed for P (promoting) models (3,4,5)
end

%% diffusion setting

d = params(6);% diffusion coefficient, keep <1.5 under usual grid size
d1 = params(7);% diffusion isotropy = 1 - cell directionality (1: isotropic, 0: anisotropic)
d2 = params(8);

%% retraction setting

l = params(9);% wound edge threshould (for retraction), default 0.4
k = params(10);% steep level of retraction, default 10
rdt = params(11);% retraction duration of time, to Yoda1: /5.8
nrdt = params(12);% inter-retraction duration of time, to Yoda1: /2.8
rds = params(13);% period standard deviation
nrds = params(14);% period standard deviation
mu = params(15);% retraction intensity
sig = params(16);% retraction intensity standard deviation
rt = zeros(1,6);% retraction info container, pre-allocation
rt(1) = normrnd(mu,sig);% retraction strength info
rt(2) = params(17);% retraction band width 0.2
rt(3) = params(18);% steep / smooth level
rt(4) = rand;% randomized location on one side
rt(5) = rand;% randomized location on the other side
rt(6) = 0;% retraction state, 0: inactive, 1: active
rdm = round(rdt/dt);% period mean
rd = round(normrnd(rdm,rds));% period = prd x dt
nrdm = round(nrdt/dt);% period mean
nrd = round(normrnd(nrdm,nrds));% period = prd x dt

%% domain setting
% boundary and initial values

ibc = params(19);% initial boundary condition
btype = params(20);% boundary type
pdtype = params(21);% pure diffusion type
[ud,bc] = inicond(ibc,pdtype,h);% initialize cell density
prd_bd = params(22);% boundary change period, prd_bd times of retraction period
bdm = params(23);% boundary random mean
bdsd = params(24);% boundary random standard deviation
bdnp = params(25);% random pts on a boundary
bc1 = bdgenerator(h,bdm,bdsd,bdnp);
bc2 = bdgenerator(h,bdm,bdsd,bdnp);
bdmid = bdmidgenerator(bc1,bc2,prd_bd*(rd+nrd));

%% data initialization

% data storage initialization
szrg = round(T/dt)+1;

% wound region strip initialization
stripidx1 = params(26);
stripidx2 = params(27);

Ud = ud;% store current cell density in Ud, since ud will be used for iteration

%% save data

if not(isfolder(data_path))
    mkdir(data_path);
end
save([data_path '/inidata']);
disp('Data initialization ready.');

end
