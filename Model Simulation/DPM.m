function [] = DPM(data_path)
%% DPM, data processing machine
% Jinghao Chen, jinghc2@uci.edu

inidata_temp = load([data_path '/inidata']);
dt = inidata_temp.dt;

% current number of data stored in the given folder
dataset_size = numel(dir([data_path '/*.mat'])) ...
    - numel(dir([data_path '/*data.mat']));

wct_temp = zeros(dataset_size,1);% wound closing time
fwa_temp = zeros(dataset_size,1);% final wound area
fcm_temp = zeros(dataset_size,1);% final cells mass
ael_temp = zeros(dataset_size,1);% average edge length
wcr_temp = zeros(dataset_size,1);% wound closing rate
% wmd_temp = zeros(dataset_size,1);% wound minimal distance
% wmd1_temp = zeros(dataset_size,1);% wound minimal distance, alternative

disp('Start processing the data ...');

for i = 1:dataset_size
    data_temp = load([data_path '/data' num2str(i)]);
    wct_temp(i) = length(data_temp.data_wscale);
    fwa_temp(i) = data_temp.data_wscale(end);
    fcm_temp(i) = data_temp.data_cellmass(end);
    ael_temp(i) = mean(data_temp.data_egl(round(0.5*length(data_temp.data_egl)):end));
    wcr_temp(i) = (data_temp.data_wscale(1)-data_temp.data_wscale(end))/length(data_temp.data_wscale);
%     wmd_temp(i) = min(data_temp.data_dist);
%     wmd1_temp(i) = min(data_temp.data_dist1);
end

wct_temp = dt*wct_temp;
wct_mean = mean(wct_temp);
wct_var = var(wct_temp);
fwa_mean = mean(fwa_temp);
fwa_var = var(fwa_temp);
fcm_mean = mean(fcm_temp);
fcm_var = var(fcm_temp);
ael_mean = mean(ael_temp);
ael_var = var(ael_temp);
wcr_mean = mean(wcr_temp);
wcr_var = var(wcr_temp);
open_wound = sum(wct_temp>9.9)/length(wct_temp);
wcs_temp = 0.45./wct_temp;
wcs_mean = mean(wcs_temp);
wcs_var = var(wcs_temp);

save([data_path '/alldata'],'wct_mean','wct_var','fwa_mean','fwa_var', ...
    'fcm_mean','fcm_var','ael_mean','ael_var','wcr_mean','wcr_var','open_wound',...
    'wcs_mean','wcs_var');

disp('Data processing done.');

end