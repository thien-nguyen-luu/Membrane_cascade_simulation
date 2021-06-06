%% From Robeson plot to Cost Plot (const Pressure)
global phi xR_req xF yP_req
xF = 0.5;
xR_req = 0.02;
yP_req = 0.98;
phi = 15;
thickness = 150e-9;
QF = 12.4; % 12.4 mol/s == 1000 Nm3/h

% ROBESON PLOT FOR CO2/CH4
k1 = 1073700; 
n1 = -2.6264;
k2 = 5369140;
n2 = -2.636;

% SELECTIVITY VECTOR
alphas = logspace(log10(57),log10(1050),100);
n = length(alphas);
Area_1991 = ones(1,n);
Area_2008 = ones(1,n);
Recovery = ones(1,n);
theta0 = log10(0.001);

% ECONOMY
Membrane_Cost = 100; %EUR/m2
Electricity_Cost = 0.09; %EUR/kWh
E_consumption = Membr.DutyComp(QF,phi)/1000/0.85; % kWh/Nm3
h_operation = 3 * 365 * 24;

for i = 1:n
i
alpha = alphas(i);
Pi_1991 = k1*alpha^n1*3.35*10^-16 / thickness;
Pi_2008 = k2*alpha^n2*3.35*10^-16 / thickness;

%thetalog = fsolve(@minfunc,theta0);
thetalog = fzero(@minfunc,[theta0 log10(0.5)]);
theta = 10^thetalog;
theta0 = thetalog;
[yP,W,~] = counterflow(xF,alpha,phi,theta);
Area_1991= ((W * QF) / (phi * 1e5 * Pi_1991))/1000;
Area_2008= ((W * QF) / (phi * 1e5 * Pi_2008))/1000;

xR = (xF - theta*yP)/(1-theta);
%Recovery = ((1-xR)*(1-theta) / xF)*100;
Recovery = (yP*theta/xF)*100;
Recycle = 1;
purity = yP;

% COST
Cost_norm_1991 = Area_1991 * Membrane_Cost / h_operation + Recycle * E_consumption * Electricity_Cost;
Cost_norm_2008 = Area_2008 * Membrane_Cost / h_operation + Recycle * E_consumption * Electricity_Cost;

ResultTab_1991(i,:) = [theta,purity,Recovery,Area_1991,Recycle,phi,Cost_norm_1991];
ResultTab_2008(i,:) = [theta,purity,Recovery,Area_2008,Recycle,phi,Cost_norm_2008];
end

semilogy(ResultTab_1991(:,3),ResultTab_1991(:,7),'-b',ResultTab_1991(:,3),ResultTab_2008(:,7),'-r','LineWidth',2);
grid on


function k = minfunc(thetalog)
global xF alpha phi xR_req yP_req
theta = 10^thetalog;
[yP,~,esp] = counterflow(xF,alpha,phi,theta);
disp(esp);
xR = (xF - theta*yP)/(1-theta);
%k = xR - xR_req;
k = yP - yP_req;
end
