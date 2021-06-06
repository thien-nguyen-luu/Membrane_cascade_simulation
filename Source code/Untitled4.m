clc
clear
% DESIGN PARAMS
xF = 0.5;
% FEED
Feed = Stream(1,1,xF,1-xF);
% PROCCESS STRUCTURE
nS = 1;
nE = 0;
% MATERIAL
alpha = 8;
Permeability = 3200; % Barrer
thickness = 150e-9; % nm 
Pi = Permeability * 3.35 * 10^-16 / thickness ; % mol/m2.s.Pa
% OPRERATIONAL CONDITION
CompressPressure = 15;
phi_F = 15;
phi_S = 15;
phi_E = 0;

theta_S = [0.1,0.4,0.6,0.8];
theta_F = [0.1,0.4,0.6,0.8];
theta_E = 0;
% SOLVER
maxint = 2000;
crit = 1e-6;
for i = 1:length(theta_F)
    for j = 1:length(theta_S)
        [~,Enriched_Product,Depleted_Product,TotalArea,~,~] = SingleCompressor(Feed,nS,nE,alpha,phi_F,theta_F(i),phi_E,theta_E,phi_S,theta_S(j),CompressPressure,maxint,crit,Pi);

        [newAlpha(i,j),newPi(i,j)]= EquilvalentStage(Enriched_Product,Depleted_Product,CompressPressure,sum(TotalArea),alpha);
    end
end