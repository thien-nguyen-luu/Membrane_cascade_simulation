function [newAlpha,newPi]= EquilvalentStage(Enriched_Product,Depleted_Product,Pressure,Area,alpha)
QF = Enriched_Product.Flowrate + Depleted_Product.Flowrate;
yP = Enriched_Product.xA;
xR = Depleted_Product.xA;
theta = Enriched_Product.Flowrate / QF;
xF = theta * yP + (1-theta)*xR;
Smin = log(xR/xF*(1-theta))/log(((1-xR)/(1-xF))*(1-theta));
newAlpha = Smin*(Smin>alpha) + alpha*[1-(Smin>alpha)];
[~,W,~] = counterflow(xF,newAlpha,Pressure,theta);
newPi = W * QF / (Pressure * 1e5 * Area);
end