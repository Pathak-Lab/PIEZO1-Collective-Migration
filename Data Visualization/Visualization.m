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


%% S14 - S17 Fig.
% Note:
% the following codes are used for generating dataset for S14 - S17 Figures
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


%% S18 Fig.
% Retraction robustness test

data_path = 'G:/Data/ratio test gof';

% load the data
ratioTestData = load([data_path,'/ratioTestData']);
cs = ratioTestData.cs;
cs_dir = ratioTestData.cs_dir;
el = ratioTestData.el;
el_dir = ratioTestData.el_dir;
cs_a1 = ratioTestData.cs_a1;
cs_a3 = ratioTestData.cs_a3;
el_a1 = ratioTestData.el_a1;
el_a3 = ratioTestData.el_a3;

pt = 4;% number of errorbars
font_size = 13;% text font size
marker_size = 5;
line_width = 2;

% plot wound closure
figure(1);
clf;
subplot(1,2,1);
% clf;
plot([-1,pt+1],[1,1],'b--',LineWidth=line_width);
hold on;
errorbar([mean(cs),mean(cs_dir),mean(cs_a1),mean(cs_a3)],[std(cs),std(cs_dir),std(cs_a1),std(cs_a3)],'o',LineWidth=line_width,MarkerSize=marker_size,Color='r');
xlim([0,pt+1]);
xticks(1:pt);
xticklabels({'^{CM}GoF','^{CM}GoF+↓Cor.Dir.','^{CM}GoF+↓Adh.','^{CM}GoF+↑Adh.'});
% ylim([0,1.1]);
ylabel('Norm. Wound Closure');
text(pt,0.95,'Control_{GoF}','FontSize', font_size);
ax = gca;
ax.XAxis.FontSize = font_size;
ax.YAxis.FontSize = font_size;
box off;
annotation('textbox', [0.06, 1, 0, 0], 'string', '(A)','FontSize', font_size+1);
hold off;

% plot edge length
subplot(1,2,2);
% clf;
plot([-1,pt+1],[1,1],'b--',LineWidth=line_width);
hold on;
errorbar([mean(el),mean(el_dir),mean(el_a1),mean(el_a3)],[std(el),std(el_dir),std(el_a1),std(el_a3)],'o',LineWidth=line_width,MarkerSize=marker_size,Color='r');
xlim([0,pt+1]);
xticks(1:pt);
xticklabels({'^{CM}GoF','^{CM}GoF+↓Cor.Dir.','^{CM}GoF+↓Adh.','^{CM}GoF+↑Adh.'});
% ylim([0,1.1]);
ylabel('Norm. Edge Length');
text(pt,1.03,'Control_{GoF}','FontSize', font_size);
ax = gca;
ax.XAxis.FontSize = font_size;
ax.YAxis.FontSize = font_size;
box off;
annotation('textbox', [0.5, 1, 0, 0], 'string', '(B)','FontSize', font_size+1);
hold off;

% save
% saveas(1,'C:\Users\cjh_m\Desktop\...\231211_new_supp_figures\S18_Fig_test.svg');
% f = gcf;
% exportgraphics(f,'C:\Users\cjh_m\Desktop\...\231211_new_supp_figures\S18_Fig_test.png','Resolution',500);

%% S19 Fig.
% phenotype = 'cKO' for S19B
% phenotype = 'GoF' for S19D

phenotype = 'cKO';

if strcmp(phenotype,'GoF')
    control_location = ['C:\Users\cjh_m\Desktop\...\' ...
        '231215_front_test\231215_controlgof_mix_controlgof'];
    load_location = ['C:\Users\cjh_m\Desktop\...\' ...
        '231215_front_test\231215_controlgof_mix_gof'];
    phenotype_control = 'Control_{GoF}';
else
    control_location = ['C:\Users\cjh_m\Desktop\...\' ...
        '231215_front_test\231215_controlcko_mix_controlcko'];
    if strcmp(phenotype,'cKO')
        load_location = ['C:\Users\cjh_m\Desktop\...\' ...
            '231215_front_test\231215_controlcko_mix_cko'];
        phenotype_control = 'Control_{cKO}';
    else
        load_location = ['C:\Users\cjh_m\Desktop\...\' ...
            '231215_front_test\231215_dmso_mix_yoda1'];
        phenotype_control = 'DMSO';
    end
end

control_data = load(control_location);
load(load_location);
save_location = ['C:\Users\cjh_m\Desktop\...\' ...
    '231215_front_test\' phenotype];

% 231215 initialization
sp = 1:-0.1:0; % source percentage
x_label = 'v cells Percentage in Initial and Source Cells';
y_label = 'v cells Percentage in Edge Cells';
font_size = 14;

% visualization
l_test = 0.2;

l_idx = round(l_test/0.01);
figure(1);
clf;
hold on;
plot(0:0.1:1,0:0.1:1,'--b',LineWidth=1);
errorbar(sp,1-wrp_test_average_mean(l_idx,:),wrp_test_average_sem(l_idx,:),LineWidth=2,Color='r');
errorbar(sp,1-control_data.wrp_test_average_mean(l_idx,:),control_data.wrp_test_average_sem(l_idx,:),LineWidth=2,Color=[.5 .5 .5]);
ax = gca;
ax.FontSize = font_size;
xlabel(x_label,"FontSize",font_size);
ylabel(y_label,"FontSize",font_size);
leg1 = legend('y=x line',[phenotype_control ' (u) mix ' phenotype ' (v)'], ...
        [phenotype_control ' (u) mix ' phenotype_control ' (v)'],'Location','northwest');
set(leg1,'Box','off')
hold off;
f = gcf;
exportgraphics(f,[save_location '\' phenotype '_front_test_fig_finalized.png'],'Resolution',500);
% saveas(1,[save_location '\' phenotype '_front_test_fig' num2str(l_idx) '.png']);
