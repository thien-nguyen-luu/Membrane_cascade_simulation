function fitness = objfunc_s0e0(X)
global yP
% OPTIMIZATION FILE FOR 1-STAGE MEMBRANE CASCADE s0e0
% OPEINING 
xF = 0.25;
%yP = 0.95;
xR = 0.03;
theta_ov = (xF-xR)/(yP-xR);
% ======================================================
theta_F = theta_ov;
theta_S = 0;
theta_E = 0;
% ======================================================
% FEED
Feed = Stream(1,1,xF,1-xF);
% ======================================================
% PROCCESS STRUCTURE
nS = 0;
nE = 0;
% MATERIAL
alpha = X(1);
Permeability = 5369140*alpha^-2.636; % Barrer in Robeson plot 2008
% ======================================================
thickness = 150e-9; % nm 
Pi = Permeability * 3.35 * 10^-16 / thickness ; % mol/m2.s.Pa
% OPRERATIONAL CONDITION
% ======================================================
CompressPressure = X(2);
phi_F = CompressPressure;
phi_S = 0;
phi_E = 0;
% ======================================================

% SOLVER
maxint = 2000;
crit = 1e-6;

%FITNESS FUNCTION
[StreamTable,~,Depleted_Product,TotalArea,~,~] = SingleCompressor(Feed,nS,nE,alpha,phi_F,theta_F,phi_E,theta_E,phi_S,theta_S,CompressPressure,maxint,crit,Pi);
xR_cal = Depleted_Product.xA;
Area = sum(TotalArea);
Q = StreamTable.Flowrate;
Ws = Membr.DutyComp(Q(2),CompressPressure)/0.8;
membrane_cost = 100; % EUR/m2
energy_cost = 0.09; % EUR/kWh
time = 3; %years
FinalCost = CostEstimate(Q(1),Area,Ws,time,membrane_cost,energy_cost)*100;
Penalty = (xR_cal>xR)*(xR_cal-xR)^0.5*5000;
fitness = FinalCost + Penalty ;
end

