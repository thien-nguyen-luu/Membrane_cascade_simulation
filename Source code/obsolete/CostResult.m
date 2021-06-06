function product = CostResult(X)
global nS nE xF xR yP alpha Permeability

% FEED CONDITION

theta_ov = (xF-xR)/(yP-xR);
Feed = Stream(12.4,1,xF,1-xF);

% OPTIMIZE FUNCTION
CompressPressure = X(1);

phi_F = CompressPressure^(1/(nE+1));
phi_S = ones(1,nS+(nS==0))*CompressPressure*(nS~=0);
phi_E = ones(1,nE+(nE==0))*CompressPressure^(1/(nE+1))*(nE~=0);

theta_S = X(2-(nS==0):1+nS)*(nS~=0);
theta_E = X(2+nS-(nE==0):1+nS+nE)*(nE~=0);

S = prod(1-theta_S)*(nS ~= 0)+ 1*(nS == 0);
E = prod(theta_E)*(nS ~= 0)+ 1*(nE == 0);
theta_F = 1 / (1 + (1/theta_ov - 1)*(E/S));

% MATERIAL
thickness = 150e-9; % nm 
Pi = Permeability * 3.35 * 10^-16 / thickness ; % mol/m2.s.Pa

% SOLVER
maxint = 2000;
crit = 1e-6;

% MEMBRANE SIMULATION ENGINE
[StreamTable,Enriched_Product,Depleted_Product,TotalArea,~,~] = SingleCompressor(Feed,nS,nE,alpha,phi_F,theta_F,phi_E,theta_E,phi_S,theta_S,CompressPressure,maxint,crit,Pi);

xR_cal = Depleted_Product.xA;
Area = sum(TotalArea);
Q = StreamTable.Flowrate;
Ws = Membr.DutyComp(Q(2),CompressPressure)/(80/100);
membrane_cost = 100; % EUR/m2
energy_cost = 0.09; % EUR/kWh
membrane_time = 3; %years
plant_time = 10;

MEMCOST = (Area*membrane_cost/membrane_time*plant_time)*1e-6; %Million EUR
ENGCOST = Ws * 24*365*10 * energy_cost * 1e-6;
COMPCOST = 5840*Ws^0.82 * 1e-6;

product = [xR_cal,Enriched_Product.xA,Area,Ws,MEMCOST,ENGCOST,COMPCOST,CompressPressure,theta_F,theta_S,theta_E];
end