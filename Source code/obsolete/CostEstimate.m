function TC = CostEstimate(QF,Area,Ws,time,membrane_cost,energy_cost)
% time = number of operating hours (year(s))
% COST ESTIMATION FUNCTION

Mem_cost = Area * membrane_cost; % EUR/m2 * m2
E_cost = energy_cost * Ws * (time * 24 * 365); % EUR/kWh * kW * h * coeff

totalGas = QF * (time * 24 * 365 * 3600) * 0.0224; 
% mol/s * s * 0.0224 Nm3/mol

TC = (Mem_cost + E_cost)/totalGas; %EUR/Nm3

end