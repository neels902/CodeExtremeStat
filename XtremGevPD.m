function [OVar,Hstruc]= XtremGevPD(InVar, Invar2)

XtreVar=InVar;
strgs=Invar2.strgs;

PrXt=XtreVar(:,2);

[paramEstsGEV,paramCIs] = gevfit(PrXt);
% [paramEstsGPD,paramGpdCIs] = gpfit(PrXt);
kMLE = paramEstsGEV(1);        % Shape parameter
sigmaMLE = paramEstsGEV(2);    % Scale parameter
muMLE = paramEstsGEV(3);       % Location parameter

kCI = paramCIs(:,1);
sigmaCI = paramCIs(:,2);
muCI = paramCIs(:,3);

lowerBnd = muMLE-sigmaMLE./kMLE;
ymax = 1.1*max(PrXt);
incre= floor(ymax-lowerBnd)./45;
bins = floor(lowerBnd):incre:ceil(ymax);

%% create figure
Hpd=figure;
y_val=histc(PrXt,bins)/length(PrXt);
% plot the PD of data
h = bar(bins,y_val,'histc');
h.FaceColor = [.9 .9 .9];

% plot the GEV fit
ygrid = linspace(lowerBnd,ymax,100);
lingrid=gevpdf(ygrid,kMLE,sigmaMLE,muMLE);

temp=round(log10(sum(lingrid)));
lintemp=lingrid* 10^(-temp);

line(ygrid,lintemp);

xlabel(strgs);
ylabel('Probability Density');
legend('Empirical PD','Fitted Generalized Extreme Value PD','location','northeast');
xlim([lowerBnd ymax]);


%% OUTPUTS
Hstruc.Hpd=Hpd;
OVar.paramEstsGEV=paramEstsGEV;
OVar.paramCIs=paramCIs;


return