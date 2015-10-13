function OutData = IntensityFit (Plasma, InStruc)

% creat best fit lognormal curves.

%% Inputs
Nyr=InStruc.Nyr; % number of years in data
Time =Plasma(:,1);
Bmag=Plasma(:,2);
NN =Plasma(:,3);
VV =Plasma(:,4);
clear Plasma


%% discretise B field to 0.1nT increment
Incr=10;  % default is 10 for B-field ; 50 for NN ; 1 for VV
B10=round(Bmag*Incr);   % B10=round(Bmag*Incr);
BB=B10./Incr;

BBfreqDist = tabulate(BB);
test=nansum(BBfreqDist(:,2));
%% 
pd = fitdist(BB,'Lognormal');
Y = pdf(BBfreqDist(:,1), pd.mu,pd.sigma).* test;


%Y = lognpdf(BB,pd.mu,pd.sigma)


out=1;

return

