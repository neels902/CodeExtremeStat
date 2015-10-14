function [ OutData, OutStruc ] = TopExtreme( InStruc)
%TOPEXTREME Top level program that runs all other routines. 
% [oa, ob] = TopExtreme([]);

%% 01. Inputs definitions
%default plotting options
set(0,'defaultlinelinewidth',2);
set(0,'defaultaxeslinewidth',1);
set(0,'DefaultAxesFontSize',14);
set(0,'DefaultAxesTickDir','out');
%set default colourmap
set(0,'DefaultFigureColormap',hot); close;
format short g

%% 02. load correct VARS
load('OMNI_1hr_1963_2012.mat')
PL=Plasma;
Nyr=50; % number of years in data

Time =Plasma(:,1);
Bmag=Plasma(:,2);
NN =Plasma(:,3);
Vmag =Plasma(:,4);
    % Get VAR = Dynamic Pressure and vBz
[Pressure,vBB]=GetSWVar(PL);

% OutData = StormIntensity(PL,Str1);

%% 02. plot optimal log normal fits
% OutData = IntensityFit(PL,Str1);

%% 101. perform analysis on VAR = DynPressure; 1in100 -> 1in1
% choose max event in every week
block= 7 ; %   # of days to time segmentation
           %   find # of data points per day
ThresPres=floor(mp*12*1000*1000* (1*10^12)*(10^9));
% ThresPres=mp*10*1000*1000* (1*10^12);
RtnYr= 100; %  Return Year of extreme Var

Struc.block=block;
Struc.Threshold=ThresPres;
Struc.RtnYr=RtnYr;
Struc.xaxisStrg='Dynamic Pressure, [nP] (1 Week Block Maximum above threshold)';
Struc.Nyr=Nyr;

% [DynP100,Hstruc]= GevXtremVar(Pressure, Struc);
[DynP100,Hstruc]= GpdXtremVar(Pressure, Struc);
DynP100
% XtremMat= [  1,     2,    5,      10,    50,   100 ;...
%            R1MLE, R2MLE, R5MLE, R10MLE, R50MLE, R100MLE];


%% 201. perform analysis on VAR = vB ;  1in100 -> 1in1
ThresvB=15*1000* (10^-3);

Struc.Threshold=ThresvB;
Struc.xaxisStrg='Motional Electric Field,vB [mV/m] (1 Week Block Maximum above threshold)';

% [DynE100,Hstruc]= GevXtremVar(vBB, Struc);
[DynE100,Hstruc]= GpdXtremVar(vBB, Struc);
DynE100

%% 301. perform analysis on VAR = BB ;  1in100 -> 1in1
ThresvB=20;

Struc.Threshold=ThresvB;
Struc.xaxisStrg='Magnetic Field, [nT] (1 Week Block Maximum above threshold)';

BB=[Time,Bmag];
[DynB100,Hstruc]= GpdXtremVar(BB, Struc);
DynB100

%% 401. perform analysis on VAR = VV ;  1in100 -> 1in1
ThresvB=750;

Struc.Threshold=ThresvB;
Struc.xaxisStrg='Velocity, [km/s] (1 Week Block Maximum above threshold)';

VV=[Time,Vmag];
[DynV100,Hstruc]= GpdXtremVar(VV, Struc);
DynV100


%% 501. plot extreme values
xyr=DynP100(1,:);
yyr=[DynP100(2,:); ... 
     DynE100(2,:); ...
     DynB100(2,:); ...
     DynV100(2,:) ];

figure
plot(xyr,yyr,'-o');
legend('Dyn P','motion. E','|B|','|V|','location','northwest');
xlabel('Return year size of solar storm');
ylabel('various units [SI]');


%% OUTPUT
OutData=1;
OutStruc=1;


end
% 
% %% create fit to data
% Incr=1;  %
% PrXt10=round(XtreP(:,2)*Incr);   % B10=round(Bmag*Incr);
% PrXt=PrXt10./Incr;
% 
% PrfrDist=tabulate(PrXt);
% 
% figure
% h=histogram(PrXt,50);
% N = morebins(h);
% xlabel('Dyn Pressure [nP] ','FontSize',15)
% ylabel('Histogram count (number)','FontSize',15)
% 
% pd = fitdist(XtreP(:,2),'GeneralizedExtremeValue');
% x_values = linspace(10,80,101);
% y = pdf(pd,x_values);
% y = linspace(0.9,4.5,1001);
% p = evpdf(y,paramEsts(1),paramEsts(2));
% line(y,.25*length(XtreP(:,2))*p,'color','r')
% 
% %%%%% testGumbel type 1
% %%%%% testfrechet type 2
% %%%%% testweibull type 3
% 
% nbin=1;
% bins = 0:nbin:60;
% y_val=histcounts(PrXt,[bins,bins(end)+nbin])/(length(PrXt)*nbin);
% 



