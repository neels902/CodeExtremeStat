function OutData = ImportOmniLongTerm (InFilename)

% Path='OMNI_1hr.cdf';
% Plasma = StormIntensity(Path);
% info = cdfinfo(Path);
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


Path= InFilename;

Dat=cdfread(Path,'Variables',{'Epoch', 'ABS_B','N','V'});
NN=max(size (Dat)); 

Tdat=Dat(:,1);
Plasma= zeros(NN,4);

Plasma(:,2)=cell2mat(Dat(:,2));
Plasma(:,3)=cell2mat(Dat(:,3));
Plasma(:,4)=cell2mat(Dat(:,4));


pos=find(Plasma(:,2) > 990 ); Plasma(pos,2)=NaN;
clear pos
pos=find(Plasma(:,3) > 990 ); Plasma(pos,3)=NaN;
clear pos
pos=find(Plasma(:,4) > 9990 ); Plasma(pos,4)=NaN;
clear pos

%% Time
Time= Plasma(:,1);

t(1,:)=todatenum(Tdat{1,1});
t(2,:)=todatenum(Tdat{2,1});
t(3,:)=todatenum(Tdat{end,1});

constRes=0;
zero_tol=1e-10; % in case of issues with 'X'==0. i.e. round-off error 
initRes=t(2)-t(1);
if (  ( initRes - t(3)/NN )  <zero_tol)
    constRes=1;
end

if constRes==1
    %increase Comp performance by not reading CDF file
    Time=t(1):(t(3)-t(1))/(NN-1):t(3);
%     Time=linspace(t(1),t(3),NN);
    Plasma(:,1)=Time';
else
    %For non-uniform time step - needs for loop.
    for ii=1:1:NN
        disp('+++++++++++++++++++')
        disp('For loop needed for Time stamps')
        disp('+++++++++++++++++++')
        Plasma(ii,1)=todatenum(Tdat{ii,1});
    end
end

%% output

OutData= Plasma;

return