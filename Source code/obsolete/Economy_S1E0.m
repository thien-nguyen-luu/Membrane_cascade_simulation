function Result = Economy_S1E0(purity,xF)
% THIS FUNCTION IS USING TO PLOT COST vs RECOVERY
% PRESSURE IS CONSTANT
% Stripping Staging nS = 1, nE = 0;

% FEED
QF = 1; % Feed flowrate
Feed = Stream(QF,1,xF,1-xF);
% PROCCESS STRUCTURE
nS = 1;
nE = 0;
% MATERIAL
alpha = 8.6;
Permeability = 33; % Barrer
thickness = 150e-9; % nm
Pi = Permeability * 3.35 * 10^-16 / thickness ; % mol/m2.s.Pa
% OPRERATIONAL CONDITION
CompressPressure = 15;
phi_F = CompressPressure;
phi_S = CompressPressure;
phi_E = 0;

% SOLVER
maxint = 2000;
crit = 1e-6;

% SOLVING BY FSOLVE
n = 12;
%A = linspace(0.65,0.1,n);
A = 0.05;
theta_S0_log = log10(0.7417);

for i = 1:length(A)
theta_F = A(i)

options = optimset('TolFun',1e-6,'Display','off');
theta_S_log = fsolve(@S1E0,theta_S0_log,options);
delta = S1E0(theta_S_log)
theta_S0_log = theta_S_log;

theta_S = 10^theta_S_log;
theta_E = 0;

[StreamTable,Enriched_Product,Depleted_Product,TotalArea,~,~] = SingleCompressor(Feed,nS,nE,alpha,phi_F,theta_F,phi_E,theta_E,phi_S,theta_S,CompressPressure,maxint,crit,Pi);

Purity = Depleted_Product.xA;
Recovery = (Depleted_Product.xB * Depleted_Product.Flowrate)/(Feed.xB * Feed.Flowrate);
Area = sum(TotalArea)*1.0;
Q = StreamTable.Flowrate;
Recycle = (Q(2)-Q(1))/Q(1);
Ws = Membr.DutyComp(Q(2),CompressPressure)/(85/100); %kW

membrane_cost = 100; % EUR/m2
energy_cost = 0.09; % EUR/kWh
time = 3; %years

FinalCost = CostEstimate(Q(1),Area,Ws,time,membrane_cost,energy_cost);


Result(i,:) = [theta_F, 10^theta_S_log,Purity,Recovery,Area,Recycle,FinalCost];
end



    function delta = S1E0(stagecutlog)
        theta_S = 10^stagecutlog;
        theta_E = 0;
        [~,Enriched_Product,Depleted_Product,~,~,~] = SingleCompressor(Feed,nS,nE,alpha,phi_F,theta_F,phi_E,theta_E,phi_S,theta_S,CompressPressure,maxint,crit,Pi);
        xR = Depleted_Product.xA;
        delta = xR - purity;
    end
end