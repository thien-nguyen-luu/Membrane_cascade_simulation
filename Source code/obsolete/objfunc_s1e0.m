function fitness = objfunc_s1e0(X)
global yP
% OPTIMIZATION FILE FOR 2-STAGES MEMBRANE CASCADE s1e0
% OPEINING FEED AND REQUIREMENT

theta_S = X(1);
theta_E = 0;
xF = 0.25;
%yP = 0.9;
xR = 0.03;
theta_ov = (xF-xR)/(yP-xR);

%=======================================================
theta_F = 1 / (1 + (1/theta_ov - 1)*1/(1-theta_S(1)));
%=======================================================
% FEED
Feed = Stream(1,1,xF,1-xF);
% PROCCESS STRUCTURE
% ======================================================
nS = 1;
nE = 0;
% MATERIAL
alpha = 32;
Permeability = 4.8; % Barrer
% ======================================================
thickness = 150e-9; % nm 
Pi = Permeability * 3.35 * 10^-16 / thickness ; % mol/m2.s.Pa
% OPRERATIONAL CONDITION
% ======================================================
CompressPressure = X(2);
phi_F = CompressPressure;
phi_S = CompressPressure;
phi_E = 0;
% ======================================================
% SOLVER
maxint = 2000;
crit = 1e-6;

% ======================================================
%FITNESS FUNCTION COST
[StreamTable,~,Depleted_Product,TotalArea,~,~] = SingleCompressor(Feed,nS,nE,alpha,phi_F,theta_F,phi_E,theta_E,phi_S,theta_S,CompressPressure,maxint,crit,Pi);
xR_cal = Depleted_Product.xA;
Area = sum(TotalArea)*1;
Q = StreamTable.Flowrate;
Ws = Membr.DutyComp(Q(2),CompressPressure)/(80/100);
membrane_cost = 100; % EUR/m2
energy_cost = 0.09; % EUR/kWh
time = 3; %years
FinalCost = CostEstimate(Q(1),Area,Ws,time,membrane_cost,energy_cost)*100; % EUR CENT
Penalty = (xR_cal>xR)*(xR_cal-xR)^0.5*5000;
fitness = FinalCost + Penalty ;
% ======================================================
end

