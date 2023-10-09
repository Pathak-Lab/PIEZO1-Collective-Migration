function [ud1x,ud2x] = iterHg(ud1,ud2,params1,params2,bc1,bc2,ret1,ret2)
% one step iteration for heterogeneous cell population
% params = [dt alp d ga k btype alp_type d1 d2]

M = size(ud1,1)-1;
N = size(ud1,2)-1;% this side is unit length
h = 1/N;
params1(4) = params1(4)*max(ud1(:));% ensure retraction only happens around the front
params2(4) = params2(4)*max(ud2(:));% ensure retraction only happens around the front
[ud1,ud1x] = bdcond(ud1,params1(6),bc1);
[ud2,ud2x] = bdcond(ud2,params2(6),bc2);

% determine the parameter values
uds = ud1x+ud2x;
pp1 = ud1x./uds;
pp1(isnan(pp1)) = 0;
pp2 = 1-pp1;
alp = params1(2)*pp1+params2(2)*pp2;
d = params1(3)*pp1+params2(3)*pp2;
d1 = params1(8)*pp1+params2(8)*pp2;
s = ret1(1)*pp1+ret2(1)*pp2;

% diffusion-advection
i = 3:M+3;
j = 3:N+3;
ud1x = ud1(i,j)+params1(1)*(difHg(ud1(i,j-1),ud1(i,j+1),ud1(i-1,j),ud1(i+1,j),ud1(i,j),...
    ud1(i-1,j-1),ud1(i-1,j+1),ud1(i+1,j-1),ud1(i+1,j+1),...
    ud1(i,j-2),ud1(i,j+2),ud1(i-2,j),ud1(i+2,j),...
    [params1(2) params1(3) params1(8) params1(9) params1(7) N], ...
    ud2(i,j-1),ud2(i,j+1),ud2(i-1,j),ud2(i+1,j),ud2(i,j),alp,d,d1)...
    +ret1(6)*advHg(ud1(i,j-1),ud1(i,j+1),ud1(i-1,j),ud1(i+1,j),ud1(i,j),...
    [params1(2) params1(4) h params1(5) params1(7)],ret1,h*(j-3), ...
    ud2(i,j-1),ud2(i,j+1),ud2(i-1,j),ud2(i+1,j),ud2(i,j),alp,s));

ud2x = ud2(i,j)+params2(1)*(difHg(ud2(i,j-1),ud2(i,j+1),ud2(i-1,j),ud2(i+1,j),ud2(i,j),...
    ud2(i-1,j-1),ud2(i-1,j+1),ud2(i+1,j-1),ud2(i+1,j+1),...
    ud2(i,j-2),ud2(i,j+2),ud2(i-2,j),ud2(i+2,j),...
    [params2(2) params2(3) params2(8) params2(9) params2(7) N], ...
    ud1(i,j-1),ud1(i,j+1),ud1(i-1,j),ud1(i+1,j),ud1(i,j),alp,d,d1)...
    +ret2(6)*advHg(ud2(i,j-1),ud2(i,j+1),ud2(i-1,j),ud2(i+1,j),ud2(i,j),...
    [params2(2) params2(4) h params2(5) params2(7)],ret2,h*(j-3), ...
    ud1(i,j-1),ud1(i,j+1),ud1(i-1,j),ud1(i+1,j),ud1(i,j),alp,s));

% rectification
ud1x = rectifier(ud1x);
ud2x = rectifier(ud2x);

end