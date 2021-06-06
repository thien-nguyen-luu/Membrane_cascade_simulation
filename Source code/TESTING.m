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
nS = 1;
nE = 0;
% MATERIAL
alpha = 8.5;
Permeability = 3900; % Barrer
thickness = 150e-9; % nm 
Pi = Permeability * 3.35 * 10^-16 / thickness ; % mol/m2.s.Pa
% OPRERATIONAL CONDITION
CompressPressure = 15;
phi_F = 15;
phi_S = 15;
phi_E = 0;
A = 0.1:0.1:0.9;
for i = 1:length(A)
theta_S = A(i)
theta_F = 1/((1/theta_ov - 1)*(1/(1-theta_S))+1);
theta_E = 0;
% SOLVER
maxint = 2000;
crit = 1e-6;
[StreamTable,Enriched_Product,Depleted_Product,~,esp,elops] = SingleCompressor(Feed,nS,nE,alpha,phi_F,theta_F,phi_E,theta_E,phi_S,theta_S,CompressPressure,maxint,crit,Pi);
purity(i) = Depleted_Product.xB;
offgas(i) = Depleted_Product.xB;
Q = StreamTable.Flowrate;
Recycle(i) = (Q(2)-Q(1))/Q(1);
end
yyaxis left
plot(A,purity,A,offgas,'LineWidth',2)
yyaxis right
plot(A,Recycle,'LineWidth',2)