function [ud1] = iter0(ud,dt,alp,btype,bc)
% this is only used for generating initial values [optional]
% Jinghao Chen, jinghc2@uci.edu

N = size(ud,1)-1;
h = 1/N;

[ud,ud1] = bdcond(ud,btype,bc);

% diffusion option, in a very old version
i = 3:N+3;
j = 3:N+3;
ud1(i-2,j-2) = ud(i,j)+...
    (dt/h^2)*(ud(i,j-1).^2.*(1-ud(i,j)).*(1-alp*ud(i,j-2))+ud(i,j+1).^2.*(1-ud(i,j)).*(1-alp*ud(i,j+2))...
    -ud(i,j).^2.*(1-ud(i,j+1)).*(1-alp*ud(i,j-1))-ud(i,j).^2.*(1-ud(i,j-1)).*(1-alp*ud(i,j+1))...
    +ud(i-1,j).^2.*(1-ud(i,j)).*(1-alp*ud(i-2,j))+ud(i+1,j).^2.*(1-ud(i,j)).*(1-alp*ud(i+2,j))...
    -ud(i,j).^2.*(1-ud(i+1,j)).*(1-alp*ud(i-1,j))-ud(i,j).^2.*(1-ud(i-1,j)).*(1-alp*ud(i+1,j)));

% rectification
ud1 = rectifier(ud1);

end