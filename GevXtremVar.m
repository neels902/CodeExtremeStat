function [XtremVal,Str] = GevXtremVar(InVar, InStr)

%% 01. define inputs
Var=InVar;                %  Solar Wind Variable of full duration [Time,Var]

block=InStr.block;        %   # of days to time segmentation
Threshold=InStr.Threshold;%   Threshold value of Var for Xtreme Analysis
RtnYr= InStr.RtnYr;       %  Return Year of extreme Var
strgs=InStr.xaxisStrg;     % string of the Xaxis variable
Nyr= InStr.Nyr;           % # of years in the raw data set

%% 10. find peak extreme array with define block interval 
%- process remove autocorrelation
[XtremeVar,OStrucXP]=XtremeArray(Var,block);

%% 11. Threshold the array to find large values only
temp=find(XtremeVar(:,2)>Threshold);
XtreVar=XtremeVar(temp,:);

%% 20. PD create fit to data - generalised Extreme Value dist. : GOOD FIT
       % type II, or Frechet seems the best fit

PDStr.strgs=strgs;
[FitVal,HStrPD]= XtremPD(XtreVar,PDStr);
paramEstsGEV=FitVal.paramEstsGEV;
paramCIs=FitVal.paramCIs;

%% 21. define the optimised GEV parameters
kMLE = paramEstsGEV(1);        % Shape parameter
sigmaMLE = paramEstsGEV(2);    % Scale parameter
muMLE = paramEstsGEV(3);       % Location parameter

kCI = paramCIs(:,1);           % uncertainty in the values
sigmaCI = paramCIs(:,2);
muCI = paramCIs(:,3);


%% 30. create Cumulative fit to data - GEV distribution

CulStr.paramEstsGEV=paramEstsGEV;
CulStr.strgs=strgs;
[CDVar,HStrCD]= XtremCulD(XtreVar,CulStr);




%% 40.1 return year extreme prediction: 1in 250 year
rtnTime= 250 ./ Nyr ; % time in years divide by total years in data set
% rtnTime= RtnYr(1) ; 

XtrmBlockNum100= round((rtnTime*365.25)./block);
R250MLE = gevinv(1-1./XtrmBlockNum100,kMLE,sigmaMLE,muMLE);

%% 40. return year extreme prediction: 1in 100 year
rtnTime= 100 ./ Nyr ; % time in years divide by total years in data set
% rtnTime= RtnYr(1) ; 

XtrmBlockNum100= round((rtnTime*365.25)./block);
R100MLE = gevinv(1-1./XtrmBlockNum100,kMLE,sigmaMLE,muMLE);

%% 41. return year extreme prediction: 1 in 50 year
rtnTime= 50 ./ Nyr ; % time in years
XtrmBlockNum50= round((rtnTime*365.25)./block);
R50MLE = gevinv(1-1./XtrmBlockNum50,kMLE,sigmaMLE,muMLE);

%% 42. return year extreme prediction: 1 in 10 year
rtnTime= 10 ./Nyr ; % time in years
XtrmBlockNum2= round((rtnTime*365.25)./block);
R10MLE = gevinv(1-1./XtrmBlockNum2,kMLE,sigmaMLE,muMLE);

%% 43. return year extreme prediction: 1 in 5 year
rtnTime= 5 ./Nyr ; % time in years
XtrmBlockNum2= round((rtnTime*365.25)./block);
R5MLE = gevinv(1-1./XtrmBlockNum2,kMLE,sigmaMLE,muMLE);

%% 44. return year extreme prediction: 1 in 2 year
rtnTime= 2 ./Nyr ; % time in years
XtrmBlockNum2= round((rtnTime*365.25)./block);
R2MLE = gevinv(1-1./XtrmBlockNum2,kMLE,sigmaMLE,muMLE);

%% 45. return year extreme prediction: 1 in 1 year
rtnTime= 1 ./ Nyr ; % time in years
XtrmBlockNum1= round((rtnTime*365.25)./block);
R1MLE = gevinv(1-1./XtrmBlockNum1,kMLE,sigmaMLE,muMLE);



%% 50. collate rtn year values

XtremMat=[  1,     2,     5,     10,     50,     100,    250;...
          R1MLE, R2MLE, R5MLE, R10MLE, R50MLE, R100MLE, R250MLE];

%% 60. uncertainty analysis


% nllCritVal2 = gevlike([kMLE,sigmaMLE,muMLE],PrXt) + .5*chi2inv(.95,1);
% 
% nllCritVal1 = gevlike([kMLE,sigmaMLE,muMLE],PrXt) + .5*chi2inv(.95,1);

%% 70. OUTPUTS.

XtremVal=XtremMat;
Str= 'temp: extrem uncertatinty values + more in future editions';


return
