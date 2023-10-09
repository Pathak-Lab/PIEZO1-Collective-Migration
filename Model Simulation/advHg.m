function [y] = adv(ul,ur,uu,ud,uc,params,ret,x,ul2,ur2,uu2,ud2,uc2,alp,s)
% advection part, in the conservative form, using 2nd order WENO
% inputs: left-right-up-down-center
% corresponding to ud(i,j-1),ud(i,j+1),ud(i-1,j),ud(i+1,j),ud(i,j)
% following the geometric consistency, not matrix coordinate consistency
%
% parameters: params =  [alp,l,h,k,alp_type]
% retraction info: ret
% current position (compared with retraction channel): x

if nargin>8
    % total cell density for heterogeneous cell population
    uls = ul+ul2;
    urs = ur+ur2;
    uus = uu+uu2;
    uds = ud+ud2;
    ucs = uc+uc2;
else
    uls = ul;
    urs = ur;
    uus = uu;
    uds = ud;
    ucs = uc;
    alp = params(1);
    s = ret(1);
end


ux = (ur-ul)./(2*params(3));
uy = (uu-ud)./(2*params(3));
xdr = -tanh(params(4)*ux);% x direction
ydr = -tanh(params(4)*uy);% y direction
plr = 0.5*(1-tanh(params(4)*(ucs-params(2))));% polarization

% hypertangent can be replaced by step function like
% plr = heaviside(l-uc);


if params(5) == 1
    % H1 model
    xadv = xdr.*(ur.*(1-ur).*(1-alp.*ur) ...
        -ul.*(1-ul).*(1-alp.*ul))./(2*params(3));
    yadv = ydr.*(uu.*(1-uu).*(1-alp.*uu) ...
        -ud.*(1-ud).*(1-alp.*ud))./(2*params(3));
    
elseif params(5) == 2
    % H2 model
    xadv = xdr.*(ur.*(1-urs).*(1-alp.*ur).^3 ...
        -ul.*(1-uls).*(1-alp.*ul).^3)./(2*params(3));
    yadv = ydr.*(uu.*(1-uus).*(1-alp.*uu).^3 ...
        -ud.*(1-uds).*(1-alp.*ud).^3)./(2*params(3));
    
elseif params(5) == 3
    % P1 model
    xadv = xdr.*(ur.*(1-ur).*(1+alp.*ur) ...
        -ul.*(1-ul).*(1+alp.*ul))./(2*params(3));
    yadv = ydr.*(uu.*(1-uu).*(1+alp.*uu) ...
        -ud.*(1-ud).*(1+alp.*ud))./(2*params(3));
    
elseif params(5) == 4
    % P2 model
    xadv = xdr.*(ur.*(1-ur).*(1+alp.*ur).^3 ...
        -ul.*(1-ul).*(1+alp.*ul).^3)./(2*params(3));
    yadv = ydr.*(uu.*(1-uu).*(1+alp.*uu).^3 ...
        -ud.*(1-ud).*(1+alp.*ud).^3)./(2*params(3));
    
elseif params(5) == 5
    % M1 model
    xadv = xdr.*(ur.*(1-ur).*(1+alp.*ur).*(1-alp.*ur)...
        -ul.*(1-ul).*(1+alp.*ul).*(1-alp.*ul))./(2*params(3));
    yadv = ydr.*(uu.*(1-uu).*(1+alp.*uu).*(1-alp.*uu)...
        -ud.*(1-ud).*(1+alp.*ud).*(1-alp.*ud))./(2*params(3));
    
elseif params(5) == 6
    % M2 model
    xadv = xdr.*(ur.*(1-ur).*(1+alp.*ur).*(1-alp.*ur).^2 ...
        -ul.*(1-ul).*(1+alp.*ul).*(1-alp.*ul).^2)./(2*params(3));
    yadv = ydr.*(uu.*(1-uu).*(1+alp.*uu).*(1-alp.*uu).^2 ...
        -ud.*(1-ud).*(1+alp.*ud).*(1-alp.*ud).^2)./(2*params(3));
    
end

% polarization on both sides, omits if/else for vectorization
y = s.*plr.*(xadv+yadv).*((ud>uu).*fbell(x,[0.3*ret(2) ret(3) ret(4)])+...
    (ud<=uu).*fbell(x,[0.3*ret(2) ret(3) ret(5)]));

end