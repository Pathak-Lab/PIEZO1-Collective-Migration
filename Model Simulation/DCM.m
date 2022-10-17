function [] = DCM(data_path,newdata_size)
%% DCM, data collecting machine
%   inputs:
%       data_path, should be the complete path of data folder
%       newdata_size, the number of new added data
%               i.e., the number of repeated simulations will be performed
%   Note: properly run DIM.m to initialize all the model parameters
%         into "inidata.mat" on data_path directory before run this script
% Jinghao Chen, jinghc2@uci.edu


% call "load" without overwriting
path_temp = data_path;
add_temp = newdata_size;
load([data_path '/inidata']);
data_path = path_temp;
newdata_size = add_temp;

% current number of data stored in the given folder
dataset_size = numel(dir([data_path '/*.mat'])) ...
    - numel(dir([data_path '/*data.mat']));

tStart = tic;

for i = dataset_size+1:dataset_size+newdata_size

    % start all over, pre-allocation
    ud = Ud;
    data_wscale = zeros(szrg,1);
    data_egl = data_wscale;
    data_cellmass = data_wscale;
    data_dist = data_wscale;
    data_dist1 = data_wscale;
    xav = zeros(szrg,2);
    egl = zeros(szrg,2);

    % counting indices initialization
    t = 0;
    ct = 0;% count for period using
    ct_bd_prd = 0;% count for boundary change period
    ct_bd = 1;% boundary change index

    tic;

    while t < T

        t = t+dt;

        data_wscale(round(t/dt)) = wscale(ud,tol);
        egcell = edge_detection(ud,tol);
        [egl(round(t/dt),1),egl(round(t/dt),2)] = edge_length(egcell);
        data_egl(round(t/dt)) = egl(round(t/dt),1)+egl(round(t/dt),2);
        data_cellmass(round(t/dt)) = cellmass(ud,stripidx1,stripidx2);
        xav(round(t/dt),1) = mean(egcell(:,1));
        xav(round(t/dt),2) = mean(egcell(:,2));
        data_dist(round(t/dt)) = edge_distance(ud,tol);
        data_dist1(round(t/dt)) = min(abs(egcell(:,2)-egcell(:,1)));

        if btype == 4
            bc = bdmid(:,min(ct_bd,size(bdmid,2)));
        elseif btype == 4.1
            bc = bdgenerator(h,bdm,bdsd,bdnp);
        end

        if ct == rd+nrd % modify retraction data after a complete period

            rd = round(normrnd(rdm,rds));% retraction duration
            nrd = round(normrnd(nrdm,nrds));% inter-retraction period

            rt(1) = normrnd(mu,sig);% randomize retraction strength
            rt(4) = rand;% randomize retraction region on one side
            rt(5) = rand;% randomize retraction region on the other side

            ct = 0;% initialize count in each total period

            % specially for randomized Dirichlet boundary condition
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

        rt(6) = (ct < rd)&&(t > Tr);

        ud = iter(ud,[dt alp d l k btype alp_type d1 d2],bc,rt);

        ct = ct+1;
        ct_bd = ct_bd+1;

        if touch(ud,tol)
            break;
        end

    end

    tOne = toc;

    clc;
    prog = round(100*(i-dataset_size)/newdata_size);
    estt = round(tOne*(dataset_size+newdata_size-i));
    disp([num2str(prog) '% in progress, ' num2str(estt) ' s estimated time remaining.']);


    data_wscale = data_wscale(1:round(t/dt));
    data_egl = data_egl(1:round(t/dt));
    data_cellmass = data_cellmass(1:round(t/dt));
    egl = egl(1:round(t/dt),:);
    xav = xav(1:round(t/dt),:);
    data_dist = data_dist(1:round(t/dt));
    data_dist1 = data_dist1(1:round(t/dt));

    save([data_path '/data' num2str(i)],'data_wscale','data_egl','data_cellmass', ...
        'egl','xav','ud','data_dist','data_dist1');

end

tEnd = toc(tStart);
clc;
disp(['Data collection takes ' num2str(tEnd) ' s in total.']);
disp(['Current dataset contains ' num2str(dataset_size+newdata_size) ...
    ' data, with ' num2str(newdata_size) ' new data just added in.']);

end