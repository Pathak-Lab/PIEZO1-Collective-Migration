% Visualization Script for Fig. 2, 3 
% and their respective supplemental figures
% Jinghao Chen, jinghc2@uci.edu

%% Fig. 2A
% use main.m, plot_mode = 1

%% Fig. 2 B, D
% use main.m, plot_mode = 2.4

%% Fig. 2C
% ensure "SingleSimulationNormalizedData.mat" is loaded in the workspace
hold on;
plot(xhighmu,highmu);
plot(xctrl,ctrl);
plot(xlowmu, lowmu);
xlim([0 0.3]);
xlabel('Time');
ylabel('Norm. Edge Length');
hold off;
legend('Higher Retraction','Control','Lower Retraction');

%% Fig. 2E
% ensure "SingleSimulationNormalizedData.mat" is loaded in the workspace
hold on;
plot(xhighan,highan);
plot(xctrl,ctrl);
plot(xlowan, lowan);
xlim([0 0.3]);
xlabel('Time');
ylabel('Norm. Edge Length');
hold off;
legend('Higher Directionality','Control','Lower Directionality');

%% Fig. 2F and Fig. 2 - Figure supplement 1
% ensure "parameter study dataset" is in the folder path
% and edit the folder_path
clf;
param = 1;
% Fig. 2F: 3
% Fig. 2 - Figure Supplement 1A: 4
% Fig. 2 - Figure Supplement 1B: 2
% Fig. 2 - Figure Supplement 1C: 5
% Fig. 2 - Figure Supplement 1D: 6
% Fig. 2 - Figure Supplement 1E: 1

folder_path = 'C:\Users\cjh_m\Desktop\Data\parameter study dataset';% replace ... by the folder path

Rdt = 0:0.0005:0.004;
Nrdt = 0:0.0001:0.0005;
Mu = 30:5:60;
Alp = 0.4:0.05:0.65;
D = 0.6:0.05:0.9;
D2 = 0:0.1:1;

% set up the info cell C:
% 1st row, params name abbreviation in the file name
% 2nd row, params scaling
% 3rd row, params range
% 4th row, params basecase value
% 5th row, params name for plotting
% 6th row, plotting xlim option
C = {'rdt','nrdt','mu','alp','d','iso'; ...
    1e4,1e4,1,1e2,1e2,1e2; ...
    Rdt,Nrdt,Mu,Alp,D,D2; ...
    2e-3,0.468*2e-3,30,0.2,1,0.4; ...
    'Retraction Duration','Inter-Retraction Duration', ...
    'Retraction Strength','Cell-Cell Adhesion', ...
    'Cell Motility','Cell Directionality';
    [-0.25e-3 4.25e-3],[-0.5e-4 5.5e-4],[27.5 62.5],[0.375 0.675],[0.575 0.935],[-0.05 1.05]};

DVM([folder_path '\' C{5,param}],[0 param],C);

%% Fig. 2 G, H and Fig. 2 - Figure Supplement 2
% ensure "parameter study dataset" is in the folder path
% and edit the folder_path
clf;
param = 5;
% Fig. 2G and Fig. 2 - Figure Supplement 2C: 3
% Fig. 2H and Fig. 2 - Figure Supplement 2F: 6
% Fig. 2 - Figure Supplement 2A: 1
% Fig. 2 - Figure Supplement 2B: 2
% Fig. 2 - Figure Supplement 2D: 4
% Fig. 2 - Figure Supplement 2E: 5

folder_path = 'C:\Users\cjh_m\Desktop\Data\parameter study dataset';% replace ... by the folder path

Rdt = 0:0.00025:0.003;
Nrdt = 0.0005:0.00025:0.003;
Mu = 0:2.5:30;
Alp = 0:0.05:0.5;
D = 0.8:0.05:1.2;
D2 = 0:0.05:1;

% set up the info cell C:
% 1st row, params name abbreviation in the file name
% 2nd row, params scaling
% 3rd row, params range
% 4th row, params basecase value
% 5th row, params name for plotting
% 6th row, basecase position for normalization
C = {'rdt','nrdt','mu','alp','d','iso'; ...
    1e4,1e4,1,1e2,1e2,1e2; ...
    Rdt,Nrdt,Mu,Alp,D,D2; ...
    2e-3,0.468*2e-3,30,0.2,1,0.4; ...
    'Retraction Duration','Inter-Retraction Duration', ...
    'Retraction Strength','Cell-Cell Adhesion', ...
    'Cell Motility','Cell Directionality';
    9,3,13,5,5,9};

DVM([folder_path '\' C{5,param}],[1 param],C);

%% Fig. 3 B, C, D
% Note:
% the following codes are used for generating dataset for Fig.3 B, C, D
% the plotting codes are in Python with DABEST package
% input the data_path by the folder location for data storage

clear;

% Step 1: initializing the files
data_path = '/Volumes/Expansion/Data/amereh new model';
C = {'ControlcKO(CM)','cKO(CM)','cKO(CM)+Dir',...
    'DMSO(CM)','Yoda1(CM)','Yoda1(CM)-Dir',...
    'ControlGoF(CM)','GoF(CM)','GoF(CM)-Dir'};
writecell(C,[data_path '/piezo1_el.xlsx']);
writecell(C,[data_path '/piezo1_cs.xlsx']);

% Step 2: collecting the data
Cel = {};
Ccs = {};
C_filename = {'controlcko','cko','cko+dir', ...
    'dmso','yoda1','yoda1+dir', ...
    'controlgof','gof','gof+dir'};

% Step 3: remember to normalize the data w.r.t the control
for k = 1:9
    case_path = [data_path '/' C_filename{k}];
    control_path = [data_path '/' C_filename{3*ceil(k/3)-2}];
    control_alldata = load([control_path '/alldata']);
    control_cs = control_alldata.wcs_mean;
    control_el = control_alldata.ael_mean;
    inidata_temp = load([case_path '/inidata']);
    dt = inidata_temp.dt;
    for j = 1:numel(dir([case_path '/data*']))
        dataA = load([case_path '/data' num2str(j)]);
        Ccs{j,k} = (0.45/(dt*length(dataA.data_wscale)))/control_cs;
        Cel{j,k} = (mean(dataA.data_egl(round(0.5*length(dataA.data_egl)):end)))/control_el;
    end
end

% Step 4: store the data
writecell(Ccs,[data_path '/piezo1_cs.xlsx'],'WriteMode','append');
writecell(Cel,[data_path '/piezo1_el.xlsx'],'WriteMode','append');


%% S7 Fig.
% Note:
% the following codes are used for generating dataset for S7 Fig. (~ Fig. 3)
% the plotting codes are in Python with DABEST package
% input the data_path by the folder location for data storage

clear;

% Step 1: initializing the files
data_path = '/Volumes/Expansion/Data/amereh new model';
C = {'ControlcKO(CM)','cKO(CM)','cKO(CM)+Alp','cKO(CM)-Alp',...
    'DMSO(CM)','Yoda1(CM)','Yoda1(CM)+Alp','Yoda1(CM)-Alp',...
    'ControlGoF(CM)','GoF(CM)','GoF(CM)+Alp','GoF(CM)-Alp'};
writecell(C,[data_path '/supp_piezo1_el.xlsx']);
writecell(C,[data_path '/supp_piezo1_cs.xlsx']);

% Step 2: collecting the data
Cel = {};
Ccs = {};
C_filename = {'controlcko','cko','cko+alp','cko-alp', ...
    'dmso','yoda1','yoda1+alp','yoda1-alp', ...
    'controlgof','gof','gof+alp','gof-alp'};

% Step 3: remember to normalize the data w.r.t the control
for k = 1:12
    case_path = [data_path '/' C_filename{k}];
    control_path = [data_path '/' C_filename{4*ceil(k/4)-3}];
    control_alldata = load([control_path '/alldata']);
    control_cs = control_alldata.wcs_mean;
    control_el = control_alldata.ael_mean;
    inidata_temp = load([case_path '/inidata']);
    dt = inidata_temp.dt;
    for j = 1:numel(dir([case_path '/data*']))
        dataA = load([case_path '/data' num2str(j)]);
        Ccs{j,k} = (0.45/(dt*length(dataA.data_wscale)))/control_cs;
        Cel{j,k} = (mean(dataA.data_egl(round(0.5*length(dataA.data_egl)):end)))/control_el;
    end
end

% Step 4: store the data
writecell(Ccs,[data_path '/supp_piezo1_cs.xlsx'],'WriteMode','append');
writecell(Cel,[data_path '/supp_piezo1_el.xlsx'],'WriteMode','append');


%% New Supp Fig.
% Note:
% the following codes are used for generating dataset for new Fig. (~ Fig. S7)
% the plotting codes are in Python with DABEST package
% input the data_path by the folder location for data storage

clear;

% Step 1: initializing the files
data_path = '/Volumes/Expansion/Data/amereh new model';
C = {'ControlcKO(CM)','cKO(CM)','cKO(CM)+Mot','cKO(CM)-Mot',...
    'DMSO(CM)','Yoda1(CM)','Yoda1(CM)+Mot','Yoda1(CM)-Mot',...
    'ControlGoF(CM)','GoF(CM)','GoF(CM)+Mot','GoF(CM)-Mot'};
writecell(C,[data_path '/supp_piezo1_el.xlsx']);
writecell(C,[data_path '/supp_piezo1_cs.xlsx']);

% Step 2: collecting the data
Cel = {};
Ccs = {};
C_filename = {'controlcko','cko','cko+d','cko-d', ...
    'dmso','yoda1','yoda1+d','yoda1-d', ...
    'controlgof','gof','gof+d','gof-d'};

% Step 3: remember to normalize the data w.r.t the control
for k = 1:12
    case_path = [data_path '/' C_filename{k}];
    control_path = [data_path '/' C_filename{4*ceil(k/4)-3}];
    control_alldata = load([control_path '/alldata']);
    control_cs = control_alldata.wcs_mean;
    control_el = control_alldata.ael_mean;
    inidata_temp = load([case_path '/inidata']);
    dt = inidata_temp.dt;
    for j = 1:numel(dir([case_path '/data*']))
        dataA = load([case_path '/data' num2str(j)]);
        Ccs{j,k} = (0.45/(dt*length(dataA.data_wscale)))/control_cs;
        Cel{j,k} = (mean(dataA.data_egl(round(0.5*length(dataA.data_egl)):end)))/control_el;
    end
end

% Step 4: store the data
writecell(Ccs,[data_path '/supp_piezo1_cs.xlsx'],'WriteMode','append');
writecell(Cel,[data_path '/supp_piezo1_el.xlsx'],'WriteMode','append');


%% New Supp Fig 
% Retraction robustness test
% data collection

clear;

data_path = '/Volumes/Expansion/Data/ratio test gof';
control_path = [data_path,'/controlgof'];

control_alldata = load([control_path '/alldata']);
control_cs = control_alldata.wcs_mean;
control_el = control_alldata.ael_mean;
inidata_temp = load([control_path '/inidata']);
dt = inidata_temp.dt;

cs = [];
el = [];
k = 0;

for i1 = 1:3
    for i2 = 1:3
        for i3 = 1:3
            case_path = [data_path,'/r',num2str(i1),'n',num2str(i2),'s',num2str(i3)];
            for j = 1:numel(dir([case_path '/data*']))
                dataA = load([case_path '/data' num2str(j)]);
                k = k+1;
                cs(k) = (0.45/(dt*length(dataA.data_wscale)))/control_cs;
                el(k) = (mean(dataA.data_egl(round(0.5*length(dataA.data_egl)):end)))/control_el;
            end
        end
    end
end


cs_dir = [];
el_dir = [];
k = 0;

dr = dir([data_path '/r*dir']);
N = numel(dr);

for i = 1:N
    case_path = [data_path,'/',dr(i).name];
    for j = 1:numel(dir([case_path '/data*']))
        dataA = load([case_path '/data' num2str(j)]);
        k = k+1;
        cs_dir(k) = (0.45/(dt*length(dataA.data_wscale)))/control_cs;
        el_dir(k) = (mean(dataA.data_egl(round(0.5*length(dataA.data_egl)):end)))/control_el;
    end
end

% save the data for future use
save([data_path,'/ratioTestData'],'cs','cs_dir','el','el_dir');
disp('Ratio test data save.');

%% New Supp Fig 
% Retraction robustness test
% visualization

% load the data
ratioTestData = load([data_path,'/ratioTestData']);
cs = ratioTestData.cs;
cs_dir = ratioTestData.cs_dir;
el = ratioTestData.el;
el_dir = ratioTestData.el_dir;

% plot wound closure
figure(1);
clf;
plot([-1,4],[1,1],'--',LineWidth=3);
hold on;
errorbar([mean(cs),mean(cs_dir)],[std(cs),std(cs_dir)],'o',LineWidth=3,MarkerSize=10);
xlim([0,3]);
xticks([1,2]);
xticklabels({'^{CM}GoF','^{CM}GoF+↓Dir.'});
ylim([0,1.1]);
ylabel('Norm. Wound Closure');
text(2.4,0.95,'Control_{GoF}','FontSize', 15);
ax = gca;
ax.XAxis.FontSize = 15;
ax.YAxis.FontSize = 15;
hold off;

% plot edge length
figure(2);
clf;
plot([-1,4],[1,1],'--',LineWidth=3);
hold on;
errorbar([mean(el),mean(el_dir)],[std(el),std(el_dir)],'o',LineWidth=3,MarkerSize=10);
xlim([0,3]);
xticks([1,2]);
xticklabels({'^{CM}GoF','^{CM}GoF+↓Dir.'});
% ylim([0,1.1]);
ylabel('Norm. Edge Length');
text(2.45,1.03,'Control_{GoF}','FontSize', 15);
ax = gca;
ax.XAxis.FontSize = 15;
ax.YAxis.FontSize = 15;
hold off;