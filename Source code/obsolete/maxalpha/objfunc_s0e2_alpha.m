function fitness = objfunc_s0e2_alpha(X)
% OPTIMIZATION FILE FOR 3-STAGES MEMBRANE CASCADE s0e2
% OPEINING 
theta_F = X(1);
theta_S = 0;
theta_E = [X(2) , X(3)];
xF = 0.5;

% FEED
Feed = Stream(1,1,xF,1-xF);
% PROCCESS STRUCTURE
% ======================================================
nS = 0;
nE = 2;
% MATERIAL
alpha = 8.5;
Permeability = 3900; % Barrer
% ======================================================
thickness = 150e-9; % nm 
Pi = Permeability * 3.35 * 10^-16 / thickness ; % mol/m2.s.Pa
% OPRERATIONAL CONDITION
% ======================================================
CompressPressure = 15;
phi_F = CompressPressure^(1/3);
phi_S = 0;
phi_E = [CompressPressure^(1/3), CompressPressure^(1/3)];
% ======================================================
% SOLVER
maxint = 2000;
crit = 1e-6;

%FITNESS FUNCTION
[~,Enriched_Product,Depleted_Product,~,~,~] = SingleCompressor(Feed,nS,nE,alpha,phi_F,theta_F,phi_E,theta_E,phi_S,theta_S,CompressPressure,maxint,crit,Pi);
xR = Depleted_Product.xA;
yP = Enriched_Product.xA;
theta = (xF-xR)/(yP-xR);
Smin = log(xR/xF*(1-theta))/log(((1-xR)/(1-xF))*(1-theta));
fitness = -Smin;

end

