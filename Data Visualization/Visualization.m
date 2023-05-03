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
param = 3;
% Fig. 2F: 3
% Fig. 2 - Figure Supplement 1A: 4
% Fig. 2 - Figure Supplement 1B: 2
% Fig. 2 - Figure Supplement 1C: 5
% Fig. 2 - Figure Supplement 1D: 6
% Fig. 2 - Figure Supplement 1E: 1

folder_path = '...\parameter study dataset';% replace ... by the folder path

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
param = 3;
% Fig. 2G and Fig. 2 - Figure Supplement 2C: 3
% Fig. 2H and Fig. 2 - Figure Supplement 2F: 6
% Fig. 2 - Figure Supplement 2A: 1
% Fig. 2 - Figure Supplement 2B: 2
% Fig. 2 - Figure Supplement 2D: 4
% Fig. 2 - Figure Supplement 2E: 5

folder_path = '...\parameter study dataset';% replace ... by the folder path

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
data_path = 'C:\Users\cjh_m\Desktop\Data\kymo_adapt';
C = {'ControlcKO(SC)','cKO(SC)','cKO(SC)+Dir',...
    'DMSO(SC)','Yoda1(SC)','Yoda1(SC)-Dir',...
    'ControlGoF(SC)','GoF(SC)','GoF(SC)-Dir'};
writecell(C,[data_path '\piezo1_el.xlsx']);
writecell(C,[data_path '\piezo1_cs.xlsx']);

% Step 2: collecting the data
Cel = {};
Ccs = {};
C_filename = {'controlcko','cko','cko+dir', ...
    'dmso','yoda1','yoda1+dir', ...
    'controlgof','gof','gof+dir'};

% Step 3: remember to normalize the data w.r.t the control
for k = 1:9
    case_path = [data_path '\' C_filename{k}];
    control_path = [data_path '\' C_filename{3*ceil(k/3)-2}];
    control_alldata = load([control_path '\alldata']);
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
writecell(Ccs,[data_path '\piezo1_cs.xlsx'],'WriteMode','append');
writecell(Cel,[data_path '\piezo1_el.xlsx'],'WriteMode','append');
