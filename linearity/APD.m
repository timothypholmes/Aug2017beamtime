function APD

clear all
more off

filename = 'NIN_Soo3_0040.mda';
xx=mdaload(filename);

t=getfield(getfield(xx,'scan'),'time');
npoints=getfield(getfield(xx,'scan'),'last_point');

pos=getfield(getfield(xx,'scan'),'positioners_data');
positioner_name=getfield(getfield(getfield(xx,'scan'),'positioners'),'name');
positioner_desc=getfield(getfield(getfield(xx,'scan'),'positioners'),'description');

dets=getfield(getfield(xx,'scan'),'detectors_data');

detectorA_name=getfield(getfield(getfield(xx,'scan'),'detectors',{1}),'name');

detectorB_desc=getfield(getfield(getfield(xx,'scan'),'detectors',{5}),'description');
detectorB_units=getfield(getfield(getfield(xx,'scan'),'detectors',{5}),'unit');

% figure(1);clf;
% hh=plotyy(pos,dets(:,1),pos,dets(:,5));
% xlabel(positioner_name)
% ylabel(detectorA_name)
% ylabel(hh(2),strcat(detectorB_desc,' (',detectorB_units,')'))

[numpts numdets] = size(dets);

for i = 1:numpts
  apd(:,i) = xx.scan.sub_scans(i).detectors_data;
  %figure(2);clf;hold on;
  %plot(apd(:,i))
%   title(['APD Trace number ' num2str(i)])
%   xlabel('Scope time base')
%   ylabel('V')
%   hold off;
%   pause(2e-1000)
end

% figure(3)
% apd(:,30) = xx.scan.sub_scans(30).detectors_data;
%plot(apd([3076:3651],[1:50]))
% figure(4)
% x2 = xx.scan.sub_scans(30).detectors_data([:]);
% y2 = xx.scan.sub_scans(30).detectors_data([1,:]);
% plot(x2,y2);

for i = 1:numpts %automatically curve fits all of the subscans for the given filename
x1 = [1:576]'; %full [1:10000]'; limited ([1:576])
y1 = xx.scan.sub_scans(i).detectors_data([1:576]); %full ([1:10000]); limited ([1:576])
size(x1)
size(y1)
f1 = fit(x1,y1,'smoothingspline');
figure(4)
fit1 = plot(x1,y1);
fit2 = plot(f1,x1,y1);
% set([fit1 fit1],'color','r')
% set([fit1 fit1],'color','b')
title(['APD Trace number ' num2str(i)])

%fprintf(f1,'Curve fit data: \n \n \n')

% f1 = fitdist(x1,'half normal'); %half normal distribution
% size(f1)
% figure(4) %curve fit plot
% hold on;
% fit1 = plot(x1,y1); 
% fit2 = plot(f1);
% set([fit1 fit1],'color','r')
% title(['APD Trace number ' num2str(i)])

end

end
