function [OVar,Hstruc]= XtremCulD(InVar, Invar2)

%% 01. Define Inputs
XtreVar=InVar;
PrXt=XtreVar(:,2);

paramEstsGEV=Invar2.paramEstsGEV;
kMLE = paramEstsGEV(1);        % Shape parameter
sigmaMLE = paramEstsGEV(2);    % Scale parameter
muMLE = paramEstsGEV(3);       % Location parameter

strgs=Invar2.strgs;            % string of the xaxis variable phrase


%% 02. inputs for plotting interval and grid spacing - repeat of XtremPD
lowerBnd = muMLE-sigmaMLE./kMLE;
ymax = 1.1*max(PrXt);
bins = floor(lowerBnd):1:ceil(ymax);

ygrid = linspace(lowerBnd,ymax,100);


%% 11. create cumulative distribution

[F,yi] = ecdf(PrXt);
y_cum=gevcdf(ygrid,kMLE,sigmaMLE,muMLE);

Hcd=figure;
h1=plot(ygrid,1-y_cum,'-'); % 1-y_cum
hold on;
h2=stairs(yi,1-F,'r');  % 1-F
hold off;
hCDax=gca;
xlabel(strgs);
ylabel('1- Cumulative Probability');
legend('Fitted Generalized Extreme Value CDF','Empirical CDF','location','southeast');
xlim([lowerBnd ymax]);
hCDax.YScale='log';
hCDax.XScale='log';

%% 21. OUTPUTS
Hstruc.Hpd=Hcd;
Hstruc.hCDax=hCDax;
OVar.CDVar=F;


return


