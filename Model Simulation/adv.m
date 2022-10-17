function [y] = adv(ul,ur,uu,ud,uc,params,ret,x)
%% advection part, modeling retraction
%   inputs: left-right-up-down-center
%       corresponding to ud(i,j-1),ud(i,j+1),ud(i-1,j),ud(i+1,j),ud(i,j)
%       following the geometric consistency, not matrix coordinate consistency
%   parameters: params =  [alp,l,h,k,alp_type]
%   retraction info: ret
%   current position (compared with retraction channel): x
% Jinghao Chen, jinghc2@uci.edu

ux = (ur-ul)./(2*params(3));
uy = (uu-ud)./(2*params(3));
xdr = -tanh(params(4)*ux);% x direction
ydr = -tanh(params(4)*uy);% y direction

% Different models classified by adhesion effects on the cell migration
% H: hindering model, P: promotion model, M: mixed model
% default: H2 model
if params(5) == 1
    % H1 model
    xadv = xdr.*(ur.*(1-ur).*(1-params(1)*ur) ...
        -ul.*(1-ul).*(1-params(1)*ul))./(2*params(3));
    yadv = ydr.*(uu.*(1-uu).*(1-params(1)*uu) ...
        -ud.*(1-ud).*(1-params(1)*ud))./(2*params(3));    
elseif params(5) == 2
    % H2 model
    xadv = xdr.*(ur.*(1-ur).*(1-params(1)*ur).^3 ...
        -ul.*(1-ul).*(1-params(1)*ul).^3)./(2*params(3));
    yadv = ydr.*(uu.*(1-uu).*(1-params(1)*uu).^3 ...
        -ud.*(1-ud).*(1-params(1)*ud).^3)./(2*params(3));    
elseif params(5) == 3
    % P1 model
    xadv = xdr.*(ur.*(1-ur).*(1+params(1)*ur) ...
        -ul.*(1-ul).*(1+params(1)*ul))./(2*params(3));
    yadv = ydr.*(uu.*(1-uu).*(1+params(1)*uu) ...
        -ud.*(1-ud).*(1+params(1)*ud))./(2*params(3));    
elseif params(5) == 4
    % P2 model
    xadv = xdr.*(ur.*(1-ur).*(1+params(1)*ur).^3 ...
        -ul.*(1-ul).*(1+params(1)*ul).^3)./(2*params(3));
    yadv = ydr.*(uu.*(1-uu).*(1+params(1)*uu).^3 ...
        -ud.*(1-ud).*(1+params(1)*ud).^3)./(2*params(3));    
elseif params(5) == 5
    % M1 model
    xadv = xdr.*(ur.*(1-ur).*(1+params(1)*ur).*(1-params(1)*ur)...
        -ul.*(1-ul).*(1+params(1)*ul).*(1-params(1)*ul))./(2*params(3));
    yadv = ydr.*(uu.*(1-uu).*(1+params(1)*uu).*(1-params(1)*uu)...
        -ud.*(1-ud).*(1+params(1)*ud).*(1-params(1)*ud))./(2*params(3));    
elseif params(5) == 6
    % M2 model
    xadv = xdr.*(ur.*(1-ur).*(1+params(1)*ur).*(1-params(1)*ur).^2 ...
        -ul.*(1-ul).*(1+params(1)*ul).*(1-params(1)*ul).^2)./(2*params(3));
    yadv = ydr.*(uu.*(1-uu).*(1+params(1)*uu).*(1-params(1)*uu).^2 ...
        -ud.*(1-ud).*(1+params(1)*ud).*(1-params(1)*ud).^2)./(2*params(3));    
end

% retraction polarization
pol = 0.5*(1-tanh(params(4)*(uc-params(2))));% hypertangent smoothing Heaviside
y = ret(1)*pol.*(xadv+yadv).*((ud>uu).*fbell(x,[0.3*ret(2) ret(3) ret(4)])+...
    (ud<=uu).*fbell(x,[0.3*ret(2) ret(3) ret(5)]));

end