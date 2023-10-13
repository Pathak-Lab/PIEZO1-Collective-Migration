function [] = plotfunc(ud,params,data_wscale,data_egl,data_cellmass,xav,egl,egcell,rt,fig_dir,bc)
%% simulation visualization
%   params = [mode_plot dt dt_plot tol t ct prd allprd alp alp_type d d1 d2 l k btype bc]
% Jinghao Chen, jinghc2@uci.edu

mode_plot = params(1);
dt = params(2);
dt_plot = params(3);
tol = params(4);
t = params(5);
ct = params(6);
prd = params(7);
allprd = params(8);
alp = params(9);
alp_type = params(10);
d = params(11);
d1 = params(12);
d2 = params(13);
l = params(14);
k = params(15);
btype = params(16);


M = size(ud,1)-1;
N = size(ud,2)-1;
h = 1/N;
ll = round(M/N);% long length
[x,y] = meshgrid(0:h:1,0:h:ll);

if mode_plot == 1 % 3D morphology
    meshz(x,y,ud);
    title(['t = ' num2str(t)]);
    hidden off;
    xlim([0 1]);
    ylim([0 ll]);
    zlim([0 1]);
    view(-60,40);
    pause(dt_plot);
elseif mode_plot == 1.1 % 3D morphology + wound edges visualization
    subplot(1,2,1);
    meshz(x,y,ud);
    hidden off;
    xlim([0 1]);
    ylim([0 ll]);
    zlim([0 1]);
    view(-60,40);
    subplot(1,2,2);
    if mod(ct,allprd) < prd
        plot(egcell(:,1),0:h:1,'r',egcell(:,2),0:h:1,'r');
    else
        plot(egcell(:,1),0:h:1,'b',egcell(:,2),0:h:1,'b');
    end
    xlim([0 ll]);
    ylim([0 1]);
    pause(dt_plot);
elseif mode_plot == 2 % wound edges visualization
    if mod(ct,allprd) < prd
        plot(egcell(:,1),0:h:1,'r',egcell(:,2),0:h:1,'r');
    else
        plot(egcell(:,1),0:h:1,'b',egcell(:,2),0:h:1,'b');
    end
    xlim([0 ll]);
    ylim([0 1]);
    pause(dt_plot);
elseif mode_plot == 2.1 % wound edges visualization on a color map
    clf;
    hold on;
    plot3(0:h:1,egcell(:,1),ones(M+1),'w',0:h:1,egcell(:,2),ones(M+1),'w');
    surf(x,y,ud);
    xlim([0 1]);
    ylim([0 ll]);
    zlim([0 1]);
    view(-90,90);
    shading interp;
    colorbar;
    caxis([0 1]);
    hold off;
    title(['t = ' num2str(t)]);
    pause(dt_plot);
elseif mode_plot == 2.2 % wound edges visualization on a grid
    ud(ud>tol) = 1;
    surf(x,y,ud);
    xlim([0 1]);
    ylim([0 ll]);
    zlim([0 1]);
    view(-90,89);
    pause(dt_plot);
elseif mode_plot == 2.3 % plot snapshots on the same figure
    figure(1);
    hold on;
    if mod(round(t/dt),round(0.08/dt)) == 0 || round(t/dt)==round(0.01/dt)
        col = 'rgbcmyk';
        plot(egcell(:,1),0:h:1,col(round(t/0.08)+1),egcell(:,2),0:h:1,col(round(t/0.08)+1));
        xlim([0 ll]);
        ylim([0 1]);
        disp(round(t/0.08)+1);
        disp(t);
    end
elseif mode_plot == 2.31 % plot snapshots on the same figure, last one
    col = 'rgbcmyk';
    plot(egcell(:,1),0:h:1,col(floor(t/0.08)+2),egcell(:,2),0:h:1,col(floor(t/0.08)+2));
    xlim([0 1]);
    ylim([0 1]);
    disp(floor(t/0.08)+2);
    disp(t);
    hold off;
elseif mode_plot == 2.4 % plot snapshots on different figures and save
    if mod(round(t/dt),round(0.08/dt)) == 0 || round(t/dt)==round(0.01/dt)
        figure(1);
        clf;
        plot(egcell(:,1),0:h:1,'b',egcell(:,2),0:h:1,'b','LineWidth',2);
        xlim([0 ll]);
        ylim([0 1]);
        title(num2str(t));
        saveas(1,[fig_dir '\' num2str(round(t/0.08)+1) '.jpg']);
    end
elseif mode_plot == 2.41 % plot snapshots on different figures, last one
    figure(1);
    clf;
    plot(egcell(:,1),0:h:1,'b',egcell(:,2),0:h:1,'b','LineWidth',2);
    xlim([0 1]);
    ylim([0 1]);
    title(num2str(t));
    saveas(1,[fig_dir '\' num2str(floor(t/0.08)+2) '.jpg']);

elseif mode_plot == 2.5 % wound edges + quantified instantaneous wound edge length
    x1 = 0:dt:t-dt;
    subplot(1,2,1);
    plot(egcell(:,1),0:h:1,'b',egcell(:,2),0:h:1,'r');
    xlim([-0.1 ll+0.1]);
    ylim([0 1]);
    subplot(1,2,2);
    plot(x1,egl(1:length(x1),1),'b',x1,egl(1:length(x1),2),'r');
    ylim([1 1.5]);
    xlabel('time');
    ylabel('wound edge length');
    pause(dt_plot);
elseif mode_plot == 2.6 % wound edges + quantified instantaneous wound area
    x1 = 0:dt:t-dt;
    subplot(1,2,1);
    if mod(ct,allprd) < prd
        plot(egcell(:,1),0:h:1,'r',egcell(:,2),0:h:1,'r');
    else
        plot(egcell(:,1),0:h:1,'b',egcell(:,2),0:h:1,'b');
    end
    xlim([0 ll]);
    ylim([0 1]);
    subplot(1,2,2);
    if mod(ct,allprd) < prd
        plot(x1,data_wscale(1:length(x1)),'r');
    else
        plot(x1,data_wscale(1:length(x1)),'b');
    end
    xlabel('time');
    ylabel('wound area');
    ylim([0 ll]);
    pause(dt_plot);
elseif mode_plot == 2.7 % wound edges + quantified instantaneous wound edge position average
    x1 = 0:dt:t-dt;
    subplot(1,2,1);
    plot(egcell(:,1),0:h:1,'b',egcell(:,2),0:h:1,'r');
    xlim([0 ll]);
    ylim([0 1]);
    subplot(1,2,2);
    plot(x1,xav(1:length(x1),1),'b',x1,xav(1:length(x1),2),'r');
    xlabel('time');
    ylabel('wound edge position average');
    ylim([0 ll]);
    pause(dt_plot);
elseif mode_plot == 2.8 % wound edges + quantified instantaneous cell mass
    x1 = 0:dt:t-dt;
    subplot(1,2,1);
    plot(egcell(:,1),0:h:1,'b',egcell(:,2),0:h:1,'r');
    xlim([0 ll]);
    ylim([0 1]);
    subplot(1,2,2);
    if mod(ct,allprd) < prd
        plot(x1,data_cellmass(1:length(x1)),'r');
    else
        plot(x1,data_cellmass(1:length(x1)),'b');
    end
    xlabel('time');
    ylabel('cell mass');
    pause(dt_plot);
elseif mode_plot == 2.9 % wound edges + mixed everything + outputs
    x1 = 0:dt:t-2*dt;
    figure(1);
    clf;
    hold on;
    plot3(0:h:1,egcell(:,1),ones(M+1),'w',0:h:1,egcell(:,2),ones(M+1),'w');
    surf(x,y,ud);
    xlim([0 1]);
    ylim([0 ll]);
    zlim([0 1]);
    view(-90,90);
    shading interp;
    colorbar;
    hold off;
    figure(2);
    plot(x1,data_egl(1:length(x1)));
    xlabel('time');
    ylabel('wound edge length');
    figure(3);
    plot(x1,data_wscale(1:length(x1)));
    xlabel('time');
    ylabel('wound area');
    ylim([0 ll]);
    figure(4);
    plot(x1,data_cellmass(1:length(x1)));
    xlabel('time');
    ylabel('cell mass in the initial wound');

    data_wscale = nonzeros(data_wscale);
    data_egl = nonzeros(data_egl);
    data_cellmass = nonzeros(data_cellmass);
    wct = dt*length(data_egl);
    abl = mean(data_egl(round(0.5*length(data_egl)):end));
    fwa = data_wscale(end);
    fcv = data_cellmass(end);
    wcr = (data_wscale(1)-data_wscale(end))/length(data_wscale);

    disp(['wound closing time: ' num2str(wct)]);
    disp(['wound edge length: ' num2str(abl)]);
    disp(['final wound area: ' num2str(fwa)]);
    disp(['final cell mass: ' num2str(fcv)]);
    disp(['wound closing rate: ' num2str(wcr)]);

elseif mode_plot == 3 || mode_plot == 3.1 % visualization of velocity
    clf;

    [uddx,uddy] = velocityField(ud,bc,rt,[btype alp alp_type k l d1 d2 d tol]);

    hold on;

    if mod(ct,allprd) < prd
        plot3(0:h:1,egcell(:,1),zeros(M+1),'r',0:h:1,egcell(:,2),zeros(M+1),'r');
    else
        plot3(0:h:1,egcell(:,1),zeros(M+1),'w',0:h:1,egcell(:,2),zeros(M+1),'w');
    end

    surf(x,y,ud);
    xlim([0 1]);
    ylim([0 ll]);
    zlim([0 1]);
    view(-90,-90);
    shading interp;
    colorbar;
    caxis([0 0.9]);
    if mode_plot == 3
        l = streamslice(x,y,uddx,uddy,5);
    else
        l = quiver(x,y,uddx,uddy);
    end

    set(l,'Color','w');
    set(l,'LineStyle','--');
    hold off;

    pause(dt_plot);

elseif mode_plot == 4 % visualization of diffusion over density
    % tol = tol*0.01;
    ud(ud<tol) = 0;
    DoR = 2-(1+11*alp)*ud+(8*alp+16*alp^2)*ud.^2-(13*alp^2+7*alp^3)*ud.^3+6*alp^3*ud.^4;

    surf(x,y,DoR);
    xlim([0 1]);
    ylim([0 ll]);
    % zlim([0 1]);
    view(-90,90);
    shading interp;
    colorbar;
    caxis([0 2]);

    pause(dt_plot);
end

end

