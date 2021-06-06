clc
clear
% global
global yP

% Initial value of stage cut
initial = [0.9,0.9];
lowerbound = [0.1,0.1];
upperbound = [0.9,0.9];

n = 0.3:0.05:0.95;
n = [n,0.99];
for i = 1:length(n)
    
    yP = n(i)

    % Set nondefault solver options
    options2 = optimoptions('patternsearch','InitialMeshSize',0.3,'Display','off',...
        'PlotFcn',{'psplotbestf','psplotmeshsize'});

    % Solve
    [solution,objectiveValue] = patternsearch(@objfunc_s0e2,initial,[],[],[],[],...
        lowerbound,upperbound,[],options2);

    close all
    result(i,:) = choose(solution,'s0e2');
    initial = solution;
end

function y = choose(X,names)
    global yP
    xF = 0.25;
    xR = 0.03;
    theta_ov = (xF - xR)/(yP - xR);
    switch names
        case 's1e0' 
            theta_F = 1/(((1/theta_ov -1)*(1/(1-X)))+1);
        case {'s0e1'}
            theta_F = 1/(1+(1/theta_ov - 1)*X);
        case {'s0e2'}
            theta_F = 1 / (1 + (1/theta_ov - 1)*X(1)*X(2));
        case {'s1e1'}
            theta_F = 1 / (1 + (1/theta_ov - 1)*X(2)/(1-X(1)));
        otherwise
            warning('Unexpected structure')
    end
    y = [theta_F,X];
end