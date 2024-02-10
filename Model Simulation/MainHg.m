% Numerical Simulation for 2D Model, Main Script
% 2/21/2022

clear;
% clc;
clf;

%% plot setting

mode_plot = 5.3;% run codes for 0: non-random display,
        % 1: display, 2: test, 
        % 3: contour type A, 3.1: contour type B, 3.2: contour type A+B
        % 4: live wound area type A
        % 5: interface x-average, 6: interface arc length,
        % 7: mixed plotting
        % 8: velocity visualization
        % 9: visualization of Diffusion over density
        % 400: spline fitting
wt_plot = 10;% initial wait time
if_plot = 1;% plot (1) or not (0)
dt_plot = if_plot*0.0000001;% graph gap time =0 just process it

%% grid setting

N = 50;% grid size
% time step size, 0.00001 for N=100, 0.0001 for N=50
if N == 50
    dt = 1e-4;
else
    dt = 1e-5;
end
h = 1/N;% spatial discretization size
T = 10;% stop time
Tr = 0;% retraction activation time
tol = 0.05;% interface tolerance, alternatively 0.05 (11/07/2021)

%% adhesion setting

alp1 = 0.2;% adhesion coefficient, < 0.66 to ensure positive, cell type 1
alp2 = 0.2;% cell type 2

alp_type = 2;
if alp_type > 2
    dt = 0.00005;% need to reduce dt for P models (3,4,5)
end

%% diffusion setting

% cell type 1
d_1 = 1;% diffusion coefficient, keep <1.5 under usual grid size
d1_1 = 0.6;% diffusion directionality (1: isotropic, 0: anisotropic)
d2 = 1;
% cell type 2
d_2 = 1.2;
d1_2 = 0.6;% diffusion directionality (1: isotropic, 0: anisotropic)
    
%% retraction setting

l = 0.4;% retraction range gamma, default 0.4
k = 10;% steep level of retraction

% cell type 1
rt1 = zeros(1,6);
rdt1 = 0.002;% retraction duration of time, YODA1: /5.8
nrdt1 = 0.47*0.002;% no retraction duration of time, YODA1: /2.8
rds1 = 0;% period standard deviation, =1
nrds1 = 0;% period standard deviation, =1
mu1 = 20;% retraction intensity, YODA1: times 16
sig1 = 0.61*mu1;% retraction intensity standard deviation, = 2
rt1(1) = normrnd(mu1,sig1);
rt1(2) = 0.2;% retraction band width 0.2
rt1(3) = 3;% steep / smooth level
rt1(4) = rand;
rt1(5) = rand;
rt1(6) = 0;% retraction state, 0: inactive, 1: active
rdm1 = round(rdt1/dt);% period mean
rd1 = round(normrnd(rdm1,rds1));% period = prd x dt
nrdm1 = round(nrdt1/dt);% period mean
nrd1 = round(normrnd(nrdm1,nrds1));% period = prd x dt

% cell type 2
rt2 = zeros(1,6);
rdt2 = 1.3*rdt1;% retraction duration of time, YODA1: /5.8
nrdt2 = 2.59*nrdt1;% no retraction duration of time, YODA1: /2.8
rds2 = 0;% period standard deviation, =1
nrds2 = 0;% period standard deviation, =1
mu2 = 1.42*mu1;% retraction intensity, YODA1: times 16
sig2 = 0.36*mu2;% retraction intensity standard deviation, = 2
rt2(1) = normrnd(mu2,sig2);
rt2(2) = 0.2;% retraction band width 0.2
rt2(3) = 3;% steep / smooth level
rt2(4) = rand;
rt2(5) = rand;
rt2(6) = 0;% retraction state, 0: inactive, 1: active
rdm2 = round(rdt2/dt);% period mean
rd2 = round(normrnd(rdm2,rds2));% period = prd x dt
nrdm2 = round(nrdt2/dt);% period mean
nrd2 = round(normrnd(nrdm2,nrds2));% period = prd x dt

%% domain setting
% boundary and initial values

% 3,2,0 or 4,4,2
ibc = 4;
btype = 4;
pdtype = 2;
[ud,bc] = inicond(ibc,pdtype,h);
prd_bd = round(0.006/dt);% boundary change period is 2 times of retraction period of DMSO control
bdm = 0.6;% boundary random mean
bdsd = 0.3;% boundary random standard deviation
bdnp = 8;% random pts on a boundary
bc1 = bdgenerator(h,bdm,bdsd,bdnp);
bc2 = bdgenerator(h,bdm,bdsd,bdnp);
bdmid = bdmidgenerator(bc1,bc2,prd_bd);

%% data initialization

% wound region strip initialization
stripidx1 = ceil(N/4);
stripidx2 = N-ceil(N/4)+2;

% data storage initialization, for cell type 1
szrg = round(T/dt)+1;
data_wscale1 = zeros(szrg,1);
data_egl1 = data_wscale1;
data_cellmass1 = data_wscale1;
xav1 = zeros(szrg,2);
egl1 = zeros(szrg,2);

% for cell type 2
data_wscale2 = data_wscale1;
data_egl2 = data_wscale1;
data_cellmass2 = data_wscale1;
xav2 = zeros(szrg,2);
egl2 = zeros(szrg,2);

% counting indices initialization
t = 0;
ct = 0;% count for period using
ct_bd = 1;% boundary change index

% initial plot, optional
if wt_plot > 0
    CAgovernor = imread('plotpending.jpg');
    image(CAgovernor);
    pause(wt_plot);
end


%% main loop
pp = 0.5;% the percentage of 1st cell population
params1 = [dt alp1 d_1 l k btype alp_type d1_1 d2];
params2 = [dt alp2 d_2 l k btype alp_type d1_2 d2];
alp_inter = (alp1+alp2)/2;% adhesion between 2
ud1 = pp*ud;
ud2 = (1-pp)*ud;
rd = round(pp*rd1+(1-pp)*rd2);
nrd = round(pp*nrd1+(1-pp)*nrd2);
% for plotting
fig_dir = 'C:\Users\cjh_m\Desktop\plos 2nd resubmission\control2cko8';
fig_dt = 0;
fig_ss = .02;% snapshot gap
M = size(ud1,1)-1;
N = size(ud1,2)-1;
ll = round(M/N);% long length
[xp,yp] = meshgrid(0:h:1,0:h:ll);
PP1 = [];
PPS = [];

if mode_plot == 3.3
    figure(1);
    hold on;
end

while t < T
    
    t = t+dt;

    % cell type 1
    data_wscale1(round(t/dt)) = wscale(ud1,tol);
    egcell1 = edge_detection(ud1,tol);
    [egl1(round(t/dt),1),egl1(round(t/dt),2)] = edge_length(egcell1);
    data_egl1(round(t/dt)) = egl1(round(t/dt),1)+egl1(round(t/dt),2);
    data_cellmass1(round(t/dt)) = cellmass(ud1,stripidx1,stripidx2);
    xav1(round(t/dt),1) = mean(egcell1(:,1));
    xav1(round(t/dt),2) = mean(egcell1(:,2));

    % cell type 2
    data_wscale2(round(t/dt)) = wscale(ud2,tol);
    egcell2 = edge_detection(ud2,tol);
    [egl2(round(t/dt),1),egl2(round(t/dt),2)] = edge_length(egcell2);
    data_egl2(round(t/dt)) = egl2(round(t/dt),1)+egl2(round(t/dt),2);
    data_cellmass2(round(t/dt)) = cellmass(ud2,stripidx1,stripidx2);
    xav2(round(t/dt),1) = mean(egcell2(:,1));
    xav2(round(t/dt),2) = mean(egcell2(:,2));

    % overall cell
    uds = ud1+ud2;
    udp = ud1./uds;
    udp(isnan(udp)) = 0;% the wound region will be covered in the plot
    PP1(round(t/dt)) = sum(ud1(uds<l))./sum(uds(uds<l));
    egcells = edge_detection(uds,tol);
    egidx = round(egcells./h+1);
    s1 = 0;
    s2 = 0;
    for i = 1:N+1
        s1 = s1+ud1(egidx(i,1),i)+ud1(egidx(i,2),i);
        s2 = s2+ud2(egidx(i,1),i)+ud2(egidx(i,2),i);
    end
    PPS(round(t/dt)) = s1/(s1+s2);

    if dt_plot>0
        if mode_plot == 5 || mode_plot == 5.1
            figure(1);
            lw = 3;
            clf;
            hold on;
            fill([0 0:h:1 1],[0;max(egcell1(:,1),egcell2(:,1));0],[.8 .8 .8],'EdgeColor','none')
            fill([0 0:h:1 1],[1;min(egcell1(:,2),egcell2(:,2));1],[.8 .8 .8],'EdgeColor','none')
            plot(0:h:1,egcell2(:,1),'r',LineWidth=lw);
            plot(0:h:1,egcell2(:,2),'r',LineWidth=lw);
            plot(0:h:1,egcell1(:,1),'b',LineWidth=lw);
            plot(0:h:1,egcell1(:,2),'b',LineWidth=lw);
            xlim([0 ll]);
            ylim([0 1]);
            set(gca,'visible','off');
            set(gca,'xtick',[],'ytick',[]);
            if mode_plot == 5
                % clc;
                % input(['t=' num2str(t)]);
                pause(dt_plot);
            elseif mod(round(t/dt),round(fig_ss/dt)) == 0 || t==dt
                saveas(1,[fig_dir '\' num2str(fig_dt) '.png']);
                fig_dt = fig_dt+1;
            end
        elseif mode_plot == 5.2
            figure(1);
            lw = 2;
            clf;
            subplot(1,2,1);
            hold on;
            fill([0 0:h:1 1],[0;egcells(:,1);0],[.8 .8 .8],'EdgeColor','none')
            fill([0 0:h:1 1],[1;egcells(:,2);1],[.8 .8 .8],'EdgeColor','none')
            plot(0:h:1,egcells(:,1),'b',LineWidth=lw);
            plot(0:h:1,egcells(:,2),'b',LineWidth=lw);
            xlim([0 ll]);
            ylim([0 1]);
            set(gca,'visible','off');
            set(gca,'xtick',[],'ytick',[]);
            hold off;
            subplot(1,2,2);
            hold on;
            plot(PPS);
            plot(1-PPS);
            ylim([0 1]);
            hold off;
        elseif mode_plot == 5.3
            lw = 2;            
            figure(1);
            clf;
            hold on;
            surf(xp,yp,uds);
            shading interp;
            xlim([0 1]);
            ylim([0 ll]);
            zlim([0 1]);
            caxis([0 1]);
            view(-90,90);
            plot3(0:h:1,egcells(:,1),ones(N+1,1),'w--',LineWidth=lw);
            plot3(0:h:1,egcells(:,2),ones(N+1,1),'w--',LineWidth=lw);
            xlim([0 ll]);
            ylim([0 1]);
            set(gca,'visible','off');
            set(gca,'xtick',[],'ytick',[]);
            hold off;
            pause(dt_plot);
        elseif mode_plot == 5.4
            lw = 2;            
            figure(1);
            clf;
            hold on;
            surf(xp,yp,udp);
            shading interp;
%             colorbar;
            caxis([0 1]);
            xlim([0 1]);
            ylim([0 ll]);
            zlim([0 1]);
            view(-90,90);
            fill3([0 0:h:1 1 1 1:-h:0 0],[0;egcells(:,1);0;1;egcells(end:-1:1,2);1],ones(2*N+6,1),'w','EdgeColor','none')
            plot3(0:h:1,egcells(:,1),ones(N+1,1),'w--',LineWidth=lw);
            plot3(0:h:1,egcells(:,2),ones(N+1,1),'w--',LineWidth=lw);
            xlim([0 ll]);
            ylim([0 1]);
            set(gca,'visible','off');
            set(gca,'xtick',[],'ytick',[]);
            hold off;
            pause(dt_plot);
        else
            figure(1);
            subplot(1,2,1);
            plotfunc(ud1,...
                [mode_plot dt dt_plot tol t ct rd rd+nrd alp1 alp_type d_1 d1_1 d2 l k],...
                data_wscale1,data_egl1,data_cellmass1,xav1,egl1,egcell1,rt1);
            subplot(1,2,2);
            plotfunc(ud2,...
                [mode_plot dt dt_plot tol t ct rd rd+nrd alp2 alp_type d_2 d1_2 d2 l k],...
                data_wscale2,data_egl2,data_cellmass2,xav2,egl2,egcell2,rt2);
        end
    end

    bc = bdmid(:,ct_bd);
    
    % modify retraction data after a complete total period
    if ct == rd+nrd

        uds = ud1+ud2;
        pp1 = sum(ud1(uds<l))./sum(uds(uds<l));% sum(uds(uds<l)) = 0 is almost impossible in our setting
        pp2 = 1-pp1;

        rd1 = normrnd(rdm1,rds1);% retraction duration
        rd2 = normrnd(rdm2,rds2);% retraction duration
        rd = round(pp1*rd1+pp2*rd2);
        nrd1 = normrnd(nrdm1,nrds1);% inter-retraction period        
        nrd2 = normrnd(nrdm2,nrds2);% inter-retraction period
        nrd = round(pp1*nrd1+pp2*nrd2);

        rt1(1) = normrnd(mu1,sig1);% randomize retraction strength
        rt2(1) = normrnd(mu2,sig2);% randomize retraction strength
        rt1(4) = rand;% randomize retraction region 1
        rt2(4) = rt1(4);
        rt1(5) = rand;% randomize retraction region 2
        rt2(5) = rt1(5);

        ct = 0;% initialize count in each total period
    end

    % specially for randomized Dirichlet boundary condition
    if ct_bd == prd_bd
        ct_bd = 0;% the ghost round
        bc1 = bc2;
        bc2 = bdgenerator(h,bdm,bdsd,bdnp);
        bdmid = bdmidgenerator(bc1,bc2,prd_bd);
    end

    rt1(6) = (ct < rd)&&(t > Tr);
    rt2(6) = (ct < rd)&&(t > Tr);

    [ud1,ud2] = iterHgInd(ud1,ud2,params1,params2,pp*bc,(1-pp)*bc,rt1,rt2,alp_inter);
    
    ct = ct+1;
    ct_bd = ct_bd+1;
    
    if touch(ud1,tol) || touch(ud2,tol)
        break;
    end
    
end

%%

% figure(1);
% clf;
% hold on;
% plot(PP1);
% plot(1-PP1);
% ylim([0 1]);
figure(2);
clf;
hold on;
PPS2 = 1-PPS;
plot(PPS(1:850),LineWidth=2);
plot(PPS2(1:850),LineWidth=2);
ylim([0 1]);
legend('Control_{cKO}','cKO');
xlabel('time step');
ylabel('percentage in edge cells');


if mode_plot == 3.3
    col = 'rgbcmyk';
    plot(egcell1(:,1),0:h:1,col(floor(t/0.08)+2),egcell1(:,2),0:h:1,col(floor(t/0.08)+2));
    xlim([0 1]);
    ylim([0 1]);
    disp(floor(t/0.08)+2);
    disp(t);
    hold off;
elseif mode_plot == 3.4
    figure(1);
    clf;
    plot(egcell1(:,1),0:h:1,'b',egcell1(:,2),0:h:1,'b','LineWidth',2);
    xlim([0 1]);
    ylim([0 1]);
    title(num2str(t));
    saveas(1,['C:\Users\user\Desktop\current workspace\medha ppt' '\' num2str(floor(t/0.08)+2) '.jpg']);
end
