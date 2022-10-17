function [] = DVM(data_path,params,V)
%% DMV, data visualization machine
% input:
%   data_path: complete dataset path
%   params: plotting info
%       params = [vis_type i]
%       vis_type is the visualization type, 
%       0 for a bar graph, otherwise for a line graph with errorbars.
%       i indicates the parameter to plot
%   V is a cell containing info about the whole parameter set
% Jinghao Chen, jinghc2@uci.edu

vis_type = params(1);% visualization type
i = params(2);
paranum = size(V,2);% number of parameter to check

% set up the base case
bcase = zeros(paranum,1);
for k = 1:paranum
    bcase(k) = V{4,k};
end

P1 = V{3,i};
ccase = bcase;% refresh, current case = base case
if vis_type
    wct_mean = zeros(length(P1),1);
    wct_sem = wct_mean;% standard error of mean
    ael_mean = wct_mean;
    ael_sem = wct_mean;
    wcs_mean = wct_mean;
    wcs_sem = wct_mean;
else
    closure_wound = zeros(length(P1),1);
end

for p1 = P1
    ccase(i) = p1;
    current_path = [data_path '/rdt' num2str(round(V{2,1}*ccase(1))) ...
        'nrdt' num2str(round(V{2,2}*ccase(2))) ...
        'mu' num2str(round(V{2,3}*ccase(3))) ...
        'alp' num2str(round(V{2,4}*ccase(4))) ...
        'd' num2str(round(V{2,5}*ccase(5))) ...
        'iso' num2str(round(V{2,6}*(1-ccase(6))))];
    alldata = load([current_path '/alldata']);
    dataset_size = numel(dir([current_path '/*.mat'])) ...
        - numel(dir([current_path '/*data.mat']));
    if vis_type
        wct_mean(P1==p1) = alldata.wct_mean;
        wct_sem(P1==p1) = sqrt(alldata.wct_var/dataset_size);
        ael_mean(P1==p1) = alldata.ael_mean;
        ael_sem(P1==p1) = sqrt(alldata.ael_var/dataset_size);
        wcs_mean(P1==p1) = alldata.wcs_mean;
        wcs_sem(P1==p1) = sqrt(alldata.wcs_var/dataset_size);
    else
        closure_wound(P1==p1) = 1-alldata.open_wound;
    end
end

figure(1);

if vis_type
    wcs_mean = wcs_mean./wcs_mean(V{6,i});
    ael_mean = ael_mean./ael_mean(V{6,i});
    yyaxis left;
    errorbar(P1,wcs_mean,wcs_sem,'-r');
    ax = gca;
    ax.YColor = 'r';
    ylabel('Norm. Wound Closure');
    ylim([0 3.5]);
    yyaxis right;
    errorbar(P1,ael_mean,ael_sem,'-b');
    ax = gca;
    ax.YColor = 'b';
    ylabel('Norm. Edge Length');
    ylim([0.8 1.3]);
    xlabel(V{5,i});
else
    bar(P1,closure_wound);
    xlabel(V{5,i});
    ylabel('Wound Closure Frequency');
    xlim(V{6,i});
end


end