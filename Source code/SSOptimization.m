function products = SSOptimization(k,n,xF,xR,yP)
nS = 0;
nE = 0;

lb = [5,2];
ub = [60,1000];

% OPTIMIZATION
% Set nondefault solver options
options = optimoptions('patternsearch','InitialMeshSize',0.3,'Display','off',...
    'PlotFcn',{'psplotbestf','psplotmeshsize'},'UseParallel',false);

% Solve
[solution,~] = patternsearch(@SSobjfunc,lb,[],[],[],[],...
    lb,ub,[],options);

products = SSCostResult(solution);

function fitness = SSobjfunc(X)
    global Feed maxint crit
    % FEED CONDITION
    Feed = Stream(12.4,1,xF,1-xF);
    
    % OPTIMIZE FUNCTION
    CompressPressure = X(1);

    phi_F = CompressPressure;
    phi_S = 0;
    phi_E = 0;

    theta_S = 0;
    theta_E = 0;
    theta_F = (xF-xR)/(yP-xR);
    
    % MATERIAL
    alpha = X(2);
    Permeability = k*alpha^n; % Barrer
    thickness = 150e-9; % nm 
    Pi = Permeability * 3.35 * 10^-16 / thickness ; % mol/m2.s.Pa

    % SOLVER
    maxint = 2000;
    crit = 1e-6;
    
    % MEMBRANE SIMULATION ENGINE
    [StreamTable,~,Depleted_Product,TotalArea,~,~] = SingleCompressor(Feed,nS,nE,alpha,phi_F,theta_F,phi_E,theta_E,phi_S,theta_S,CompressPressure,maxint,crit,Pi);

    xR_cal = Depleted_Product.xA;
    Area = sum(TotalArea);
    Q = StreamTable.Flowrate;
    Ws = Membr.DutyComp(Q(2),CompressPressure)/(80/100);
    membrane_cost = 100; % EUR/m2
    energy_cost = 0.09; % EUR/kWh
    membrane_time = 3; %years
    plant_time = 10;

    MEMCOST = (Area*membrane_cost/membrane_time*plant_time)/(1000*10*24*365)*100; %Million EUR
    ENGCOST = Ws * 24*365*10 * energy_cost /(1000*10*24*365)*100;
    COMPCOST = 5840*Ws^0.82 /(1000*10*24*365)*100;

    TC = (MEMCOST + ENGCOST + COMPCOST);
    Penalty = (xR_cal>xR)*(xR_cal-xR)^0.5*5000;
    fitness = TC + Penalty ;
end

function product = SSCostResult(X)
    global Feed maxint crit
    % OPTIMIZE FUNCTION
    CompressPressure = X(1);

    phi_F = CompressPressure;
    phi_S = 0;
    phi_E = 0;

    theta_S = 0;
    theta_E = 0;
    theta_F = (xF-xR)/(yP-xR);
    
    % MATERIAL
    alpha = X(2);
    Permeability = k*alpha^n; % Barrer
    thickness = 150e-9; % nm 
    Pi = Permeability * 3.35 * 10^-16 / thickness ; % mol/m2.s.Pa    
    
    
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

    MEMCOST = (Area*membrane_cost/membrane_time*plant_time)/(1000*10*24*365)*100; %Million EUR
    ENGCOST = Ws * 24*365*10 * energy_cost /(1000*10*24*365)*100;
    COMPCOST = 5840*Ws^0.82 /(1000*10*24*365)*100;

    TC = (MEMCOST + ENGCOST + COMPCOST);

    product = [xR_cal,Enriched_Product.xA,Area,Ws,MEMCOST,ENGCOST,COMPCOST,TC,CompressPressure,theta_F,theta_S,theta_E];

end
end