function [O_Pres,O_vB]= GetSWVar(Plasma)
% small function to convert to useful SW parameters

Time =Plasma(:,1);
Bmag=Plasma(:,2);
NN =Plasma(:,3);
VV =Plasma(:,4);
clear Plasma

% documentation of the units used:
% http://omniweb.gsfc.nasa.gov/html/ow_data.html

% should be (2.0/10**6) * Np*V**2  : when Na/Np is unknown
Pres= mp.*NN.*VV.*VV.*(10^12) .* (10^9); % extra to convert to nP

% should be -vv * Bz * 10^-3
vB= VV.* Bmag .* (10^-3);  % extra to convert to mV/m  [10^-6 to SI then 10^3]

O_Pres=[Time,Pres];
O_vB=[Time,vB];

return


