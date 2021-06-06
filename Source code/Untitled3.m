maxStage = 3;
combinations = ListStage(maxStage);
n = length(combinations);
ResultTable = zeros(n,10+maxStage);
% REQUIREMENT
xF = 0.25;
xR = 0.03;
yP = 0.9;

% MATERIAL
alpha = 8.5;
Permeability = 3900;


% SOLVE FOR SINGLE STAGE


% SOLVE FOR MULTI STAGE
for i = 1:length(combinations)
    nSnE = combinations(i,:);
    product = mainoptim(nSnE,alpha,Permeability,xF,xR,yP);
    ResultTable(i,1:length(product)) = product;
    close all
end


finalTable = [combinations,ResultTable];

titleFiller = cell(1,maxStage);
for i = 1:maxStage
    titleFiller{i} = ['param ',num2str(i)];
end


T = array2table(finalTable,...
'VariableNames',{'nS','nE','xR','yP','Area (m2)','Duty (kW)','Membrane Cost','Energy Cost(mil EUR)','Compressor Cost','Treatment Cost (cent EUR/Nm3)','Pressure','theta_F','1','2','3'})