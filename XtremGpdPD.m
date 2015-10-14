function [OVar,Hstruc]= XtremGpdPD (InVar, Invar2)
%   Other functions for the generalized Pareto, such as GPCDF, allow a
%   threshold parameter THETA.  However, GPFIT does not estimate THETA, and it
%   must be assumed known, and subtracted from X before calling GPFIT.
%
%   When K = 0 and THETA = 0, the GP is equivalent to the exponential
%   distribution.  When K > 0 and THETA = SIGMA/K, the GP is equivalent to the
%   Pareto distribution.  The mean of the GP is not finite when K >= 1, and the
%   variance is not finite when K >= 1/2.  When K >= 0, the GP has positive
%   density for X>THETA, or, when K < 0, for 0 <= (X-THETA)/SIGMA <= -1/K.

XtreVar=InVar;
strgs=Invar2.strgs;
Threshold=Invar2.Threshold;

PrXt=XtreVar(:,2);

% [paramEstsGEV,paramCIs] = gevfit(PrXt);
[paramEstsGPD,paramGpdCIs] = gpfit(PrXt-Threshold); % must subtract Thre prior to use.

kMLE      = paramEstsGPD(1);   % Shape, Tail index parameter
sigmaMLE  = paramEstsGPD(2);   % Scale parameter
  % muMLE = paramEstsGEV(3);       % Location parameter

kCI = paramGpdCIs(:,1);
sigmaCI = paramGpdCIs(:,2);
  % muCI = paramCIs(:,3);

% lowerBnd = muMLE-sigmaMLE./kMLE;
lowerBnd = 0.9* Threshold;
ymax = 1.1*max(PrXt);
incre= ceil( (ymax-lowerBnd)./45);
bins = floor(lowerBnd):incre:ceil(ymax);

%% create figure
Hpd=figure;
y_val=histc(PrXt,bins)/length(PrXt);
% plot the PD of data
h = bar(bins,y_val,'histc');
h.FaceColor = [.9 .9 .9];

% plot the GPD fit
   % Y = GPPDF(X,K,SIGMA,THETA);  tail index (shape) parameter K, scale 
   %   parameter SIGMA, and threshold (location) parameter THETA, 
   %   evaluated at the values in X.
ygrid = linspace(lowerBnd,ymax,100);
lingrid=gppdf(ygrid,kMLE,sigmaMLE,Threshold);
% lingrid=gevpdf(ygrid,kMLE,sigmaMLE,muMLE);

temp=round(log10(sum(lingrid)));
lintemp=lingrid* 10^(-temp);

line(ygrid,lintemp);

xlabel(strgs);
ylabel('Probability Density');
legend('Empirical PD','Fitted Generalized Extreme Value PD','location','northeast');
xlim([lowerBnd ymax]);


%% OUTPUTS
Hstruc.Hpd=Hpd;
OVar.paramEstsGEV=paramEstsGPD;
OVar.paramCIs=paramGpdCIs;


return

