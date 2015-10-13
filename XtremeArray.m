function [XtremePres,OStrucXP]=XtremeArray(Pressure,tau)
% take full data set and convert to max extreme values within chosen time
% interval. The Var can be any SW parameter, code written as Var=Pressure;
% and time inteval is a week.

% Pressure = data Var
% tau= block time interval eg. 7 days


temp=Pressure(1:3700,1)-Pressure(1,1);
temp2=find(temp==1); 
NperDay=temp2-1;
Num= tau* NperDay;

% find surplus data ponts at the end of the array whcih should be removed.
% ie if an extra few hours of day are provied at end of long array
ncut= rem((length(Pressure)),Num);
Pressure=Pressure(1:end-ncut,:);

Nshap=ceil(length(Pressure(:,1))./Num);
ShapePres=reshape(Pressure(:,2),[Num,Nshap]);
ShapeT=reshape(Pressure(:,1),[Num,Nshap]);
ShapeTime=ShapeT(1,:);

PresMax=nanmax(ShapePres,[],1);


%% output
XtremePres=[ShapeTime',PresMax'];
OStrucXP=1;


return

