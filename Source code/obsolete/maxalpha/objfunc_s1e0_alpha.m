function fitness = objfunc_s1e0_alpha(X)
% OPTIMIZATION FILE FOR 2-STAGES MEMBRANE CASCADE s1e0
% OPEINING FEED AND REQUIREMENT
theta_F = X(1);
theta_S = X(2);
theta_E = 0;
xF = 0.75;

%=======================================================
% FEED
Feed = Stream(1,1,xF,1-xF);
% PROCCESS STRUCTURE
% ======================================================
nS = 1;
nE = 0;
% MATERIAL
alpha = 8.5;
Permeability = 3900; % Barrer
% ======================================================
thickness = 150e-9; % nm 
Pi = Permeability * 3.35 * 10^-16 / thickness ; % mol/m2.s.Pa
% OPRERATIONAL CONDITION
% ======================================================
CompressPressure = 15;
phi_F = CompressPressure;
phi_S = CompressPressure;
phi_E = 0;
% ======================================================
% SOLVER
maxint = 2000;
crit = 1e-6;

% ======================================================
%FITNESS FUNCTION COST
[~,Enriched_Product,Depleted_Product,~,~,~] = SingleCompressor(Feed,nS,nE,alpha,phi_F,theta_F,phi_E,theta_E,phi_S,theta_S,CompressPressure,maxint,crit,Pi);
xR = Depleted_Product.xA;
yP = Enriched_Product.xA;
theta = (xF-xR)/(yP-xR);
Smin = log(xR/xF*(1-theta))/log(((1-xR)/(1-xF))*(1-theta));
fitness = -Smin;
% ======================================================
end

