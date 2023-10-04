% 10/2/2023
% case study auto machine
% run directly through the terminal

clear;
% clc;
% clf;

%% grid setting

N = 50;% grid size
Tr = 0;% retraction activation time
tol = 0.05;% interface tolerance, alternatively 0.05 (11/07/2021)

%% adhesion setting

alp_type = 2;

%% diffusion setting

d2 = 1;

%% retraction setting

l = 0.4;% retraction range gamma, default 0.4
k = 10;% steep level of retraction
rw = 0.2;% retraction region width
sl = 3;% steep level

%% domain setting
% boundary and initial values

ibc = 4;
btype = 4;
pdtype = 2;
prd_bd = 2;% boundary change period is 2 times of retraction period
bdm = 0.6;% boundary random mean
bdsd = 0.3;% boundary random standard deviation
bdnp = 8;% random pts on a boundary

%% data initialization

% wound region strip initialization
stripidx1 = ceil(N/4);
stripidx2 = N-ceil(N/4)+2;

%% customized setting

run_opt = input(['Please input the case name for simulation: \n' ...
    'Options: controlcko, cko; dmso, yoda1; controlgof, gof. \n' ...
    'Empty input goes to customized case study. \n'],'s');

if strcmp(run_opt,'dmso') || strcmp(run_opt,'controlcko')
% dmso control ak data
    rdt = 2e-3;
    rds = 0.93*rdt;
    nrdt = 0.47*2e-3;
    nrds = 0.64*nrdt;
    mu = 20;
    sig = 0.61*mu;
    d = 1;
    d1 = 0.6;
    alp = 0.2;
elseif strcmp(run_opt,'cko')
    % cko ak data
    rdt = 1.3*2e-3;
    rds = 0.59*rdt;
    nrdt = 2.95*0.47*2e-3;
    nrds = 0.73*nrdt;
    mu = 1.42*20;
    sig = 0.36*mu;
    d = 1.2;
    d1 = 0.6;
    alp = 0.2;
elseif strcmp(run_opt,'yoda1')
    % yoda1 ak data
    rdt = 0.16*2e-3;
    rds = 0.45*rdt;
    nrdt = 0.41*0.47*2e-3;
    nrds = 0.44*nrdt;
    mu = 2.87*20;
    sig = 0.8*mu;
    d = 1;
    d1 = 0.6;
    alp = 0.2;
elseif strcmp(run_opt,'controlgof')
    % gof control ak data
    rdt = 2e-3;
    rds = 0.48*rdt;
    nrdt = 4e-3;
    nrds = nrdt;
    mu = 30;
    sig = 0.35*mu;
    d = 1;
    d1 = 0;
    alp = 0.2;
elseif strcmp(run_opt,'gof')
    % gof ak data
    rdt = 1.18*2e-3;
    rds = 0.86*rdt;
    nrdt = 0.5*4e-3;
    nrds = 0.77*nrdt;
    mu = 1.64*30;
    sig = 0.41*mu;
    d = 1;
    d1 = 0;
    alp = 0.2;
else
    % customized case
    rdt = 1.18*2e-3;
    rds = 0.86*rdt;
    nrdt = 0.5*4e-3;
    nrds = 0.77*nrdt;
    mu = 1.64*30;
    sig = 0.41*mu;
    d = 1;
    d1 = 0;
    alp = 0.2;
    run_opt = 'gof';
end

if strcmp(run_opt,'cko') || strcmp(run_opt,'gof') || strcmp(run_opt,'yoda1')
    inter_opt = input(['Would you like to change interaction terms? \n' ...
        'a0: adhesion decreases, a1: adhesion increases; d: directionality changes. \n' ...
        'Empty input goes to no change with the interaction terms. \n'],'s');
    if strcmp(inter_opt,'a0')
        alp = 0.1;
        run_opt = [run_opt '-alp'];
    elseif strcmp(inter_opt,'a00')
        alp = 0;
        run_opt = [run_opt '--alp'];
    elseif strcmp(inter_opt,'a1')
        alp = 0.3;
        run_opt = [run_opt '+alp'];
    elseif strcmp(inter_opt,'a11')
        alp = 0.4;
        run_opt = [run_opt '++alp'];
    elseif strcmp(inter_opt,'d')
        if strcmp(run_opt,'cko')
            d1 = 0;
        else
            d1 = 1;
        end
        run_opt = [run_opt '+dir'];
    end
end


data_path = '/Users/ononoki/Desktop/PIEZO1 wound healing/Data/adhesion free';
file_path = input(['Check following path for data storage: \n' data_path ...
    '\n Is that correct? Input no to change, otherwise confirm: '],'s');

if strcmp(file_path,'no')
    data_path = input('Please input the complete file path: \n','s');
end

% dataset path
data_path = [data_path '/' run_opt];
if not(isfolder(data_path))
    % data initialization
    DIM(data_path,[N Tr tol alp alp_type d d1 d2 l k ...
        rdt nrdt rds nrds mu sig rw sl ibc btype pdtype prd_bd ...
        bdm bdsd bdnp stripidx1 stripidx2]);

    % data collection and processing
    DCM(data_path,100);
    DPM(data_path);
end
