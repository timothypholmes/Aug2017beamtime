function APD

clear all
more off


filename = 'NIN_Soo3_0041.mda'
xx=mdaload(filename)

t=getfield(getfield(xx,'scan'),'time');
npoints=getfield(getfield(xx,'scan'),'last_point');

pos=getfield(getfield(xx,'scan'),'positioners_data');
positioner_name=getfield(getfield(getfield(xx,'scan'),'positioners'),'name');
positioner_desc=getfield(getfield(getfield(xx,'scan'),'positioners'),'description');

dets=getfield(getfield(xx,'scan'),'detectors_data');

detectorA_name=getfield(getfield(getfield(xx,'scan'),'detectors',{1}),'name');

detectorB_desc=getfield(getfield(getfield(xx,'scan'),'detectors',{5}),'description');
detectorB_units=getfield(getfield(getfield(xx,'scan'),'detectors',{5}),'unit');

figure(1);clf;
hh=plotyy(pos,dets(:,1),pos,dets(:,5));
xlabel(positioner_name)
ylabel(detectorA_name)
ylabel(hh(2),strcat(detectorB_desc,' (',detectorB_units,')'))

[numpts numdets] = size(dets);

% for i = 1:numpts
%   apd(:,i) = xx.scan.sub_scans(i).detectors_data;
%   figure(2);clf;hold on;
%   plot(apd(:,i))
%   title(['APD Trace number ' num2str(i)])
%   xlabel('Scope time base')
%   ylabel('V')
%   hold off;
%   pause(2e-1000)
% end

figure(3)
apd(:,30) = xx.scan.sub_scans(30).detectors_data;
plot(apd([3076:3651],30))

for i = 1:numpts
x1 = xx.scan.sub_scans(30).detectors_data([3076:3651]);
y1 = xx.scan.sub_scans(30).detectors_data([1:576]);
size(x1)
size(y1)
f1 = fit(x1,y1,'gauss2');
figure(4)
fit1 = plot(f1,x1,y1); 
set([fit1 fit1],'color','r')
title(['APD Trace number ' num2str(i)])
end

end