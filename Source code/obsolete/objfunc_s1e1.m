function fitness = objfunc_s1e1(X)
% OPTIMIZATION FILE FOR 3-STAGES MEMBRANE CASCADE s1e1
% OPEINING 
theta_S = X(1);
theta_E = X(2);
xF = 0.25;
yP = 0.9;
xR = 0.03;
theta_ov = (xF-xR)/(yP-xR);
% ======================================================
theta_F = 1 / (1 + (1/theta_ov - 1)*theta_E/(1-theta_S));
% ======================================================
% FEED
Feed = Stream(1,1,xF,1-xF);
% ======================================================
% PROCCESS STRUCTURE
nS = 1;
nE = 1;
% MATERIAL
alpha = 32;
Permeability = 4.8; % Barrer
% ======================================================
thickness = 150e-9; % nm 
Pi = Permeability * 3.35 * 10^-16 / thickness ; % mol/m2.s.Pa
% OPRERATIONAL CONDITION
% ======================================================
CompressPressure = 64;
phi_F = 15^0.5;
phi_S = 15;
phi_E = 15^0.5;
% ======================================================

% SOLVER
maxint = 2000;
crit = 1e-6;

%FITNESS FUNCTION
[StreamTable,~,Depleted_Product,TotalArea,~,~] = SingleCompressor(Feed,nS,nE,alpha,phi_F,theta_F,phi_E,theta_E,phi_S,theta_S,CompressPressure,maxint,crit,Pi);
xR_cal = Depleted_Product.xA;
Area = sum(TotalArea)*1;
Q = StreamTable.Flowrate;
Ws = Membr.DutyComp(Q(2),CompressPressure)/(85/100);
membrane_cost = 100; % EUR/m2
energy_cost = 0.09; % EUR/kWh
time = 3; %years
FinalCost = CostEstimate(Q(1),Area,Ws,time,membrane_cost,energy_cost)*100;
Penalty = (xR_cal>xR)*(xR_cal-xR)^0.5*1000;
fitness = FinalCost + Penalty ;
end

