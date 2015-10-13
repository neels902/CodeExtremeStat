function [O_Pres,O_vB]= GetSWVar(Plasma)
% small function to convert to useful SW parameters

Time =Plasma(:,1);
Bmag=Plasma(:,2);
NN =Plasma(:,3);
VV =Plasma(:,4);
clear Plasma

Pres= mp.*NN.*VV.*VV.*(10^12) * (10^9); % extra to convert to nP
vB= VV.* Bmag;

O_Pres=[Time,Pres];
O_vB=[Time,vB];

return


