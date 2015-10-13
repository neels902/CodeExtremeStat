function OutData = StormIntensity(Plasma, InStruc)
%
% OutData = StormIntensity


% Plasma = StormIntensity(Path);
% Input=1;
% OutData = StormIntensity (Input);
% 
%
%structure of MFI data:
%     'Epoch_1800'    [1x2 double]    [438313]    'epoch'     'T/'    'Full'
%     'ABS_B1800'     [1x2 double]    [438313]    'single'    'T/'    'Full'
%     'N1800'         [1x2 double]    [438313]    'single'    'T/'    'Full'
%     'V1800'         [1x2 double]    [438313]    'single'    'T/'    'Full'
%     'ABS_B'         [1x2 double]    [438313]    'single'    'T/'    'Full'
%     'N'             [1x2 double]    [438313]    'single'    'T/'    'Full'
%     'V'             [1x2 double]    [438313]    'single'    'T/'    'Full'
%     'Epoch'         [1x2 double]    [438313]    'epoch'     'T/'    'Full'

% temp=Input;
%%
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

%% create distribution quantity
BBfreqDist = tabulate(BB);  % [unique value ; # ; %] 
% y = zeros(size(BB));
% for i = 1:length(BB)
% y(i) = sum(BB==BB(i));
% end

Bdiscret= BBfreqDist(:,1);
Bfreq= BBfreqDist(:,2)./Nyr;

%% plot B-field frequency distribution
H1=figure;
H_fig1=subplot(2,1,1);
axP1=stairs(Bdiscret,Bfreq);
ax1=gca; af1=gcf;
hold on
set(ax1,'Yscale','log');
ylabel('PDF (number / yr)','FontSize',15)
xlabel('|B| field over 1963-2012 (nT) ','FontSize',15)

H_fig2=subplot(2,1,2);
axP2=stairs(Bdiscret,Bfreq);
ax2=gca; af2=gcf;
set(ax2,'Xscale','log');
set(ax2,'Yscale','log');
ylabel('PDF (number / yr)','FontSize',15)
xlabel('|B| field over 1963-2012 (nT) ','FontSize',15)
%xlabel('Plasma Density over 1963-2012 (nT) ','FontSize',15)
set(ax2,'XLim',[1 100]);
% set(ax2,'XLim',[250 3000]);


%% plot each solar cycle
% 1957-1966

% 1967-1977
[a,I]=min(abs(datenum([1967,1,1,0,0,0])-Time));
[a,I2]=min(abs(datenum([1978,1,1,0,0,0])-Time));
Nyr2=10; % number of year in solar cycle

Bshort=BB(I:I2);
BBfreqDistShort = tabulate(Bshort);
BdisShort= BBfreqDistShort(:,1);
BfreqShort= BBfreqDistShort(:,2)./Nyr2;

figure(af1)
hold on
axP3=stairs(ax1,BdisShort,BfreqShort,'Linewidth',0.7);
axP3.Color=[0.6,0.6,0.6];

figure(af2)
hold on
axP4=stairs(ax2,BdisShort,BfreqShort,'Linewidth',0.7);
axP4.Color=[0.6,0.6,0.6];
legend('All Data','1967-1977')


%% REPEAT FOR VELOCITY


%% discretise B field to 0.1nT increment
Incr=1;  % default is 10 for B-field ; 50 for NN ; 1 for VV
V10=round(VV*Incr);   % B10=round(Bmag*Incr);
VV=V10./Incr;

%% create distribution quantity
VVfreqDist = tabulate(VV);  % [unique value ; # ; %] 
% y = zeros(size(BB));
% for i = 1:length(BB)
% y(i) = sum(BB==BB(i));
% end

Vdiscret= VVfreqDist(:,1);
Vfreq= VVfreqDist(:,2)./Nyr;

%% plot VELOCITY frequency distribution
H2=figure;
H2_fig1=subplot(2,1,1);
axP1=stairs(Vdiscret,Vfreq);
ax3=gca; af3=gcf;
hold on
set(ax3,'Yscale','log');
ylabel('Cumulative(number / yr)','FontSize',15)
xlabel('|V| field over 1963-2012 (nT) ','FontSize',15)

H_fig2=subplot(2,1,2);
axP2=stairs(Vdiscret,Vfreq);
ax4=gca; af4=gcf;
hold on
set(ax4,'Xscale','log');
set(ax4,'Yscale','log');
ylabel('Cumulative(number / yr)','FontSize',15)
xlabel('|V| field over 1963-2012 (nT) ','FontSize',15)
%xlabel('Plasma Density over 1963-2012 (nT) ','FontSize',15)
set(ax4,'XLim',[250 3000]);
% set(ax2,'XLim',[250 3000]);


%% plot each solar cycle
% 1957-1966

% 1967-1977
[a,Iv]=min(abs(datenum([1967,1,1,0,0,0])-Time));
[a,Iv2]=min(abs(datenum([1978,1,1,0,0,0])-Time));
Nyr2=10; % number of year in solar cycle

Vshort=VV(Iv:Iv2);
VVfreqDistShort = tabulate(Vshort);
VdisShort= VVfreqDistShort(:,1);
VfreqShort= VVfreqDistShort(:,2)./Nyr2;

figure(af1)
hold on
axP3=stairs(ax3,VdisShort,VfreqShort,'Linewidth',0.7);
axP3.Color=[0.6,0.6,0.6];

figure(af2)
hold on
axP4=stairs(ax4,VdisShort,VfreqShort,'Linewidth',0.7);
axP4.Color=[0.6,0.6,0.6];
legend('All Data','1967-1977')












%% find extreme CME window 

%[a,dd]=max(BB);
%
% alternative to the maximum value
[temp,dd]=min(abs(BBfreqDist(end-3,1)-BB));
%
%
[temp,ee]=min(abs(BBfreqDist(:,1)-BB(dd)));



% datevec(Time(dd))   
Bwind=BB(dd-6:dd+12);
Vwind=VV(dd-6:dd+12);
Twind=Time(dd-9:dd+9);

for ii=1:1:length(Bwind)
   [temp,cc]=min(abs(BBfreqDist(:,1)-Bwind(ii)));
   axCME(ii)=plot(ax1,Bdiscret(cc),Bfreq(cc),'o','MarkerSize',10,'MarkerFaceColor',[0.6,0,0]); % [.49 1 .63]
   axCME2(ii)=plot(ax2,Bdiscret(cc),Bfreq(cc),'o','MarkerSize',10,'MarkerFaceColor',[0.6,0,0]); % [.49 1 .63]

   [temp,vc]=min(abs(VVfreqDist(:,1)-Vwind(ii)));
   axCME3(ii)=plot(ax3,Vdiscret(vc),Vfreq(vc),'o','MarkerSize',10,'MarkerFaceColor',[0.6,0,0]); % [.49 1 .63]
   axCME4(ii)=plot(ax4,Vdiscret(vc),Vfreq(vc),'o','MarkerSize',10,'MarkerFaceColor',[0.6,0,0]); % [.49 1 .63]
end

axCMEMax(1)=plot(ax1,Bdiscret(ee),Bfreq(ee),'s','MarkerSize',14,'MarkerFaceColor',[.49 1 .63]); % 
axCMEMax(2)=plot(ax2,Bdiscret(ee),Bfreq(ee),'s','MarkerSize',14,'MarkerFaceColor',[.49 1 .63]); % 

axCMEMax2(1)=plot(ax3,Vdiscret(ee),Vfreq(ee),'s','MarkerSize',14,'MarkerFaceColor',[.49 1 .63]); % 
axCMEMax2(2)=plot(ax4,Vdiscret(ee),Vfreq(ee),'s','MarkerSize',14,'MarkerFaceColor',[.49 1 .63]); % 


%% Lognormal optimised fitting

pd = fitdist(BB,'Lognormal');
% [parmhat,parmci] = lognfit(data);



%% output




OutData= 1;

return



