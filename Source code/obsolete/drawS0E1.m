clc
clear
% DESIGN PARAMS
xF = 0.25;
xR = 0.03;
yP = 0.99;
theta_ov = (xF - xR)/(yP - xR);
% FEED
Feed = Stream(1,1,xF,1-xF);
% PROCCESS STRUCTURE
nS = 0;
nE = 1;
% MATERIAL
alpha = 8.5;
Permeability = 3900; % Barrer
thickness = 150e-9; % nm 
Pi = Permeability * 3.35 * 10^-16 / thickness ; % mol/m2.s.Pa
% OPRERATIONAL CONDITION
CompressPressure = 15;
phi_F = 15^0.5;
phi_S = 0;
phi_E = 15^0.5;
A = 0.05:0.01:0.75;
for i = 1:length(A)
theta_E = A(i)
theta_F = 1/((1/theta_ov - 1)*theta_E + 1);  
theta_S = 0;
% SOLVER
maxint = 2000;
crit = 1e-6;
[StreamTable,Enriched_Product,Depleted_Product,~,esp,elops] = SingleCompressor(Feed,nS,nE,alpha,phi_F,theta_F,phi_E,theta_E,phi_S,theta_S,CompressPressure,maxint,crit,Pi);
purity(i) = Depleted_Product.xB;
offgas(i) = Enriched_Product.xA;
Enriched_Product.Flowrate
Q = StreamTable.Flowrate;
Recycle(i) = (Q(2)-Q(1))/Q(1);
end
yyaxis left
plot(A,purity,A,offgas,[0.05 0.75],[0.97 0.97],':k','LineWidth',2)
xlabel('Enriching stage cut')
xlim([0.05,0.75])
ylabel('CH4/CO2 purity')
yyaxis right
ylabel('Recycle')
plot(A,Recycle,'LineWidth',2)