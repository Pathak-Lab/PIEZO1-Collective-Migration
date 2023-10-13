function [uddx,uddy,uddx0,uddy0] = velocityField(ud,bc,rt,params)
% velocity field
% inputs: ud, cell density
%         bc, boundary condition
%         rt, retraction info
%         params, parameter set, params = [btype alp alp_type k l d1 d2 d tol]

btype = params(1);
alp = params(2);
alp_type = params(3);
k = params(4);
l = params(5);
d1 = params(6);
d2 = params(7);
d = params(8);
tol = params(9);

M = size(ud,1)-1;
N = size(ud,2)-1;
h = 1/N;
[ud1,~] = bdcond(ud,btype,bc);

udx = zeros(size(ud));
udy = udx;
i = 3:M+3;
j = 3:N+3;
udx(i-2,j-2) = (ud1(i,j+1)-ud1(i,j-1))./(2*h);
udy(i-2,j-2) = (ud1(i+1,j)-ud1(i-1,j))./(2*h);
DoR = 2-(1+11*alp)*ud+(8*alp+16*alp^2)*ud.^2-(13*alp^2+7*alp^3)*ud.^3+6*alp^3*ud.^4;

if alp_type == 1 % H1 model
    Rmag = rt(1)*(1-ud).*(1-alp*ud);
elseif alp_type == 2 % H2 model
    Rmag = rt(1)*(1-ud).*(1-alp*ud).^3;
elseif alp_type == 3 % P1 model
    Rmag = rt(1)*(1-ud).*(1+alp*ud);
elseif alp_type == 4 % P2 model
    Rmag = rt(1)*(1-ud).*(1+alp*ud).^3;
elseif alp_type == 5 % M1 model
    Rmag = rt(1)*(1-ud).*(1+alp*ud).*(1-alp*ud);
elseif alp_type == 6 % M2 model
    Rmag = rt(1)*(1-ud).*(1+alp*ud).*(1-alp*ud).^2;
end

plr = 0.5*(1-tanh(k*(ud-l)));
Loc = zeros(size(ud));

Loc(i-2,j-2) = ((ud1(i+1,j)>ud1(i-1,j)).*fbell(h*(j-2-1),[0.3*rt(2) rt(3) rt(4)])+...
    (ud1(i+1,j)<=ud1(i-1,j)).*fbell(h*(j-2-1),[0.3*rt(2) rt(3) rt(5)]));

xdr = tanh(k.*udx);
ydr = tanh(k.*udy);

% isotropic mode, DoR need to be modified for anisotropic mode
uddx = -d1*d*DoR.*udx+xdr.*Rmag.*plr.*Loc;
uddy = -d2*d*DoR.*udy+ydr.*Rmag.*plr.*Loc;

uddx0 = -d1*d*DoR.*udx;
uddy0 = -d2*d*DoR.*udy;

uddx(ud<tol) = 0;
uddy(ud<tol) = 0;

uddx0(ud<tol) = 0;
uddy0(ud<tol) = 0;

end