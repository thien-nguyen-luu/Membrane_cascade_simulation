function fitness = objfunc(X)

% OPEINING 
theta_S = 0;
theta_E = [X(1),X(2)];
xF = 0.25;
yP = 0.99;
xR = 0.03;
theta_ov = (xF-xR)/(yP-xR);
%=======================================================
theta_F = 1 / (1 + (1/theta_ov - 1)*theta_E(1)*theta_E(2));
%=======================================================

% FEED
Feed = Stream(1,1,xF,1-xF);
% PROCCESS STRUCTURE
nS = 0;
nE = 2;
% MATERIAL
alpha = 8.5;
Permeability = 3900; % Barrer
thickness = 150e-9; % nm 
Pi = Permeability * 3.35 * 10^-16 / thickness ; % mol/m2.s.Pa
% OPRERATIONAL CONDITION
CompressPressure = 15;
phi_F = 15^(1/3);
phi_S = 0;
phi_E = [15^(1/3), 15^(1/3)];

% SOLVER
maxint = 2000;
crit = 1e-6;
[~,~,Depleted_Product,~,~,~] = SingleCompressor(Feed,nS,nE,alpha,phi_F,theta_F,phi_E,theta_E,phi_S,theta_S,CompressPressure,maxint,crit,Pi);
xR_cal = Depleted_Product.xA;
%FITNESS FUNCTION

%=======================================================
R = theta_F*((1-theta_E(1))+theta_E(1)*(1-theta_E(2)));
%=======================================================
%Recycle = R / (1-R);
%Penalty = (xR_cal>xR)*(xR_cal-xR)^0.5*1000;
fitness = xR_cal-xR;
%fitness = Recycle + Penalty;
end

