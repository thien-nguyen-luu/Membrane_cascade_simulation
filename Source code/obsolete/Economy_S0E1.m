function Result = Economy_S0E1(purity,xF)
% THIS FUNCTION IS USING TO PLOT COST vs RECOVERY
% PRESSURE IS CONSTANT
% Enriching Staging nS = 0, nE = 1;

% FEED
QF = 1; % Feed flowrate
Feed = Stream(QF,1,xF,1-xF);
% PROCCESS STRUCTURE
nS = 0;
nE = 1;
% MATERIAL
alpha = 8.6;
Permeability = 33; % Barrer
thickness = 150e-9; % nm
Pi = Permeability * 3.35 * 10^-16 / thickness ; % mol/m2.s.Pa
% OPRERATIONAL CONDITION
CompressPressure = 15;
phi_F = sqrt(CompressPressure);
phi_S = 0;
phi_E = sqrt(CompressPressure);

% SOLVER
maxint = 2000;
crit = 1e-6;

% SOLVING BY FSOLVE
n = 50;
%A = linspace(0.8,0.2,n);
A =  0.775510204;
theta_E0_log = log10(0.0901);

for i = 1:length(A)
theta_F = A(i)

options = optimset('TolFun',1e-3,'Display','off');
theta_E_log = fsolve(@S0E1,theta_E0_log,options);
delta = S0E1(theta_E_log)
theta_E0_log = theta_E_log;

theta_S = 0;
theta_E = 10^theta_E_log;

[StreamTable,Enriched_Product,Depleted_Product,TotalArea,~,~] = SingleCompressor(Feed,nS,nE,alpha,phi_F,theta_F,phi_E,theta_E,phi_S,theta_S,CompressPressure,maxint,crit,Pi);

Purity = Enriched_Product.xA;
Recovery = (Enriched_Product.xA * Enriched_Product.Flowrate)/(Feed.xA * Feed.Flowrate);
Area = sum(TotalArea)*1;
Q = StreamTable.Flowrate;
Recycle = (Q(2)-Q(1))/Q(1);
Ws = Membr.DutyComp(Q(2),CompressPressure)/(85/100); %kW

membrane_cost = 100; % EUR/m2
energy_cost = 0.09; % EUR/kWh
time = 3; %years

FinalCost = CostEstimate(Q(1),Area,Ws,time,membrane_cost,energy_cost);


Result(i,:) = [theta_F, 10^theta_E_log,Purity,Recovery,Area,Recycle,FinalCost];
end



    function delta = S0E1(stagecutlog)
        theta_S = 0;
        theta_E = 10^stagecutlog
        [~,Enriched_Product,Depleted_Product,~,~,~] = SingleCompressor(Feed,nS,nE,alpha,phi_F,theta_F,phi_E,theta_E,phi_S,theta_S,CompressPressure,maxint,crit,Pi);
        yP = Enriched_Product.xA
        delta = yP - purity;
    end
end