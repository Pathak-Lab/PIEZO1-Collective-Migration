function [ud,ud1] = bdcond(ud,btype,bc)
%% boundary condition
%   set boundary condition for the PDE problem
%   inputs:
%       ud: cell density
%       btype: boundary type, default value = 4
%       bc: a vector contains boundary info depending on btype
% Jinghao Chen, jinghc2@uci.edu

M = size(ud,1)-1;
N = size(ud,2)-1;% unit length side

% extension
ud1 = ud;
ud = zeros(M+5,N+5);
ud(3:M+3,3:N+3) = ud1;


if btype == 0
    % pure Dirichlet boundary condition
    ud(1,3:N+3) = bc(3);% up
    ud(2,3:N+3) = bc(3);
    ud(N+4,3:N+3) = bc(4);% down
    ud(N+5,3:N+3) = bc(4);
    ud(3:N+3,1) = bc(1);% left
    ud(3:N+3,2) = bc(1);
    ud(3:N+3,N+4) = bc(2);% right
    ud(3:N+3,N+5) = bc(2);
    
elseif btype == 1
    % pure Neumann boundary condition
    ud(1,3:N+3) = ud1(1,:);% up
    ud(2,3:N+3) = ud1(1,:);
    ud(N+4,3:N+3) = ud1(N+1,:);% down
    ud(N+5,3:N+3) = ud1(N+1,:);
    ud(3:N+3,1) = ud1(:,1);% left
    ud(3:N+3,2) = ud1(:,1);
    ud(3:N+3,N+4) = ud1(:,N+1);% right
    ud(3:N+3,N+5) = ud1(:,N+1);   
    
elseif btype == 2
    % mixed boundary condition 1
    % up and down Dirichlet, left and right Neumann
    ud(1,3:N+3) = bc(3);% up
    ud(2,3:N+3) = bc(3);
    ud(M+4,3:N+3) = bc(4);% down
    ud(M+5,3:N+3) = bc(4);
    ud(3:M+3,1) = ud1(:,1);% left
    ud(3:M+3,2) = ud1(:,1);
    ud(3:M+3,N+4) = ud1(:,N+1);% right
    ud(3:M+3,N+5) = ud1(:,N+1);
        
elseif btype == 3
    % mixed boundary condition 2
    % up and down Dirichlet, left and right periodic
    ud(1,3:N+3) = bc(3);% up
    ud(2,3:N+3) = bc(3);
    ud(M+4,3:N+3) = bc(4);% down
    ud(M+5,3:N+3) = bc(4);
    ud(3:M+3,1) = ud1(:,N);% left
    ud(3:M+3,2) = ud1(:,N+1);
    ud(3:M+3,N+4) = ud1(:,1);% right
    ud(3:M+3,N+5) = ud1(:,2);
    
elseif btype == 4 || btype == 4.1
    % mixed boundary condition 3
    % up and down Dirichlet, left and right Neumann
    %   randomized Dirichlet, values are pointwise specified from inputs,
    %   not uniformly set 
    ud(1,3:N+3) = bc(1:N+1);% up
    ud(2,3:N+3) = bc(1:N+1);
    ud(M+4,3:N+3) = bc(N+2:end);% down
    ud(M+5,3:N+3) = bc(N+2:end);
    ud(3:M+3,1) = ud1(:,1);% left
    ud(3:M+3,2) = ud1(:,1);
    ud(3:M+3,N+4) = ud1(:,N+1);% right
    ud(3:M+3,N+5) = ud1(:,N+1);

end


end