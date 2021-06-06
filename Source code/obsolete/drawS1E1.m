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
nE = 1;
% MATERIAL
alpha = 8.5;
Permeability = 3900; % Barrer
thickness = 150e-9; % nm 
Pi = Permeability * 3.35 * 10^-16 / thickness ; % mol/m2.s.Pa
% OPRERATIONAL CONDITION
CompressPressure = 15;
phi_F = 15^0.5;
phi_S = 15;
phi_E = 15^0.5;
A = 0.05:0.05:0.95;
B = 0.05:0.05:0.5;

for i = 1:length(A)
    theta_S = A(i)
    for j = 1:length(B)
        theta_E = B(j);
        theta_F = 1/(1+(1/theta_ov - 1)*theta_E/(1-theta_S));  
        % SOLVER
        maxint = 2000;
        crit = 1e-6;
        [StreamTable,Enriched_Product,Depleted_Product,~,esp,elops] = SingleCompressor(Feed,nS,nE,alpha,phi_F,theta_F,phi_E,theta_E,phi_S,theta_S,CompressPressure,maxint,crit,Pi);
        purity(i,j) = Depleted_Product.xB;
        offgas(i,j) = Enriched_Product.xA;
        Q = StreamTable.Flowrate;
        Recycle(i,j) = (Q(2)-Q(1))/Q(1);
    end
end

for i = 1:length(A)
    for j = 1:length(B)
        
        if purity(i,j) < 0.97
            Recycle(i,j) = NaN;
        end
        
    end
end
