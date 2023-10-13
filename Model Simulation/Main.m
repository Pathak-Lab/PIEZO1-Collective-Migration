%% Numerical Simulation Main Script
%   for a single case testing, visualization, etc.
% Jinghao Chen, jinghc2@uci.edu

clear;
% clc;
clf;
fig_dir = pwd;% folder path to store the plotted figures, default pwd

%% plot setting

mode_plot = 3.1; % plotting modes:
        % 1: 3D morphology
        % 1.1: 3D morphology + wound edges visualization
        % 2: wound edges visualization
        % 2.1: wound edges visualization on a color map
        % 2.2: wound edges visualization on a grid (mosaic-like)
        % 2.3: wound edges snapshots, on the same figure (overlapping)
        % 2.4: wound edges snapshots, on different figures and save
        % 2.5: wound edges + quantified instantaneous wound edge length
        % 2.6: wound edges + quantified instantaneous wound area
        % 2.7: wound edges + quantified instantaneous wound edge position average
        % 2.8: wound edges + quantified instantaneous cell mass
        % 2.9: wound edges + mixed everything + outputs [at the end]
        % 3: velocity visualization (streamlines)
        % 3.1: velocity visualization (vector field)
        % 4: visualization of diffusion over density

wt_plot = 0;% initial wait time
if_plot = 1;% plot (1) or not (0)
dt_plot = if_plot*1e-6;% graph plotting gap time =0 just process it

%% grid setting

N = 50;% grid size
dt = 1e-4;% time step size, 1e-5 for N=100, 1e-4 for N=50
h = 1/N;% spatial discretization size
T = 10;% stop time
Tr = 0;% retraction activation time [optional]
tol = 0.05;% interface tolerance, alternatively 0.05

%% adhesion setting

alp = 0.2;% adhesion coefficient, < 0.66 to ensure positive diffusivity
alp_type = 2;% adhesion type, default 2: hindering in 2D
if alp_type > 2
    dt = 5e-5;% smaller dt is needed for P (promoting) models (3,4,5)
end

%% diffusion setting

d = 1;% diffusion coefficient, keep <1.5 under usual grid size
d1 = 0.6;% diffusion isotropy = 1 - cell directionality (1: isotropic, 0: anisotropic)
d2 = 1;
    
%% retraction setting

l = 0.4;% wound edge threshould (for retraction), default 0.4
k = 10;% steep level of retraction
rdt = 0.002;% retraction duration, to Yoda1: /5.8
nrdt = 0.47*0.002;% inter-retraction duration, to Yoda1: /2.8
rds = 0;% period standard deviation
nrds = 0;% period standard deviation
mu = 20;% retraction strength
sig = .61*mu;% retraction strength standard deviation
rt = zeros(1,6);% retraction info container, pre-allocation
rt(1) = normrnd(mu,sig);% retraction strength info
rt(2) = 0.2;% retraction band width 0.2
rt(3) = 3;% steep / smooth level
rt(4) = rand;% randomized location on one side
rt(5) = rand;% randomized location on the other side
rt(6) = 0;% retraction state, 0: inactive, 1: active
rdm = round(rdt/dt);% period mean
rd = round(normrnd(rdm,rds));% period = prd x dt
nrdm = round(nrdt/dt);% period mean
nrd = round(normrnd(nrdm,nrds));% period = prd x dt

%% domain setting
% boundary and initial values

% 3,2,0 or 4,4,2
ibc = 4;% initial boundary condition
btype = 4;% boundary type
pdtype = 2;% pure diffusion type
[ud,bc] = inicond(ibc,pdtype,h);% initialize cell density
prd_bd = 2;% boundary change period, prd_bd times of retraction period
bdm = 0.6;% boundary random mean
bdsd = 0.3;% boundary random standard deviation
bdnp = 8;% random pts number on a boundary
bc1 = bdgenerator(h,bdm,bdsd,bdnp);
bc2 = bdgenerator(h,bdm,bdsd,bdnp);
bdmid = bdmidgenerator(bc1,bc2,prd_bd*(rd+nrd));

%% data initialization

% the region to observe the cell mass
stripidx1 = ceil(N/4);
stripidx2 = N-ceil(N/4)+2;

% data storage pre-allocation
szrg = round(T/dt)+1;
data_wscale = zeros(szrg,1);
data_egl = data_wscale;
data_cellmass = data_wscale;
xav = zeros(szrg,2);
egl = zeros(szrg,2);

% counting indices initialization
t = 0;
ct = 0;% count for period using
ct_bd_prd = 0;% count for boundary change period
ct_bd = 1;% boundary change index

% initial plot [optional]
if wt_plot > 0
    CAgovernor = imread('plotpending.jpg');
    image(CAgovernor);
    pause(wt_plot);
end

%% main loop

while t < T
    
    t = t+dt;

    % data collection
    data_wscale(round(t/dt)) = wscale(ud,tol);
    egcell = edge_detection(ud,tol);
    [egl(round(t/dt),1),egl(round(t/dt),2)] = edge_length(egcell);
    data_egl(round(t/dt)) = egl(round(t/dt),1)+egl(round(t/dt),2);
    data_cellmass(round(t/dt)) = cellmass(ud,stripidx1,stripidx2);
    xav(round(t/dt),1) = mean(egcell(:,1));
    xav(round(t/dt),2) = mean(egcell(:,2));

    % randomized Dirichlet boundaries option
    if btype == 4
        bc = bdmid(:,min(ct_bd,size(bdmid,2)));
    elseif btype == 4.1
        bc = bdgenerator(h,bdm,bdsd,bdnp);
    end
    
    % plotting option
    if dt_plot>0
        plotfunc(ud,...
            [mode_plot dt dt_plot tol t ct rd rd+nrd alp alp_type d d1 d2 l k btype],...
            data_wscale,data_egl,data_cellmass,xav,egl,egcell,rt,fig_dir,bc);
    end

    % retraction setting
    if ct == rd+nrd % randomly reset retraction data after a period        
        rd = round(normrnd(rdm,rds));% randomize retraction duration
        nrd = round(normrnd(nrdm,nrds));% randomize inter-retraction duration        
        rt(1) = normrnd(mu,sig);% randomize retraction strength
        rt(4) = rand;% randomize location on one side
        rt(5) = rand;% randomize location one the other side
        ct = 0;% set back count in each period        
        % specially for randomized Dirichlet boundaries option
        if btype == 4
            ct_bd_prd = ct_bd_prd+1;

            if ct_bd_prd == prd_bd
                ct_bd = 1;
                ct_bd_prd = 0;
                bc1 = bc2;
                bc2 = bdgenerator(h,bdm,bdsd,bdnp);
                bdmid = bdmidgenerator(bc1,bc2,prd_bd*(rd+nrd));
            end
        elseif btype == 4.1
            ct_bd_prd = ct_bd_prd+1;
            if ct_bd_prd == prd_bd
                ct_bd = 1;
                ct_bd_prd = 0;
                bc = bdgenerator(h,bdm,bdsd,bdnp);
            end  
        end       
    end

    rt(6) = (ct < rd)&&(t > Tr);% retraction, or not
    ud = iter(ud,[dt alp d l k btype alp_type d1 d2],bc,rt);% one step
    
    ct = ct+1;
    ct_bd = ct_bd+1;
    
    % check if wound closed or not
    if touch(ud,tol)
        break;
    end
    
end

% some plotting options
if mode_plot == 2.3 || mode_plot == 2.4
    plotfunc(ud,...
        [mode_plot+0.01 dt dt_plot tol t ct rd rd+nrd alp alp_type d d1 d2 l k btype],...
        data_wscale,data_egl,data_cellmass,xav,egl,egcell,rt,fig_dir,bc);
end

%% summarized plotting [optional]

% mode_plot = 2.9;
% plotfunc(ud,...
%     [mode_plot dt dt_plot tol t ct rd rd+nrd alp alp_type d d1 d2 l k btype],...
%     data_wscale,data_egl,data_cellmass,xav,egl,egcell,rt,fig_dir,bc);