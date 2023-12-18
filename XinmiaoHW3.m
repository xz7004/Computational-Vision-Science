%%10/28/2023 HW3
% Load the data from the .mat file
load('BrightnessMatchingData.mat');
%% Question 1
%grey
grayREF= BMdataTable(BMdataTable.REFcol==1,[2,3]);
y=table2array(grayREF(:,2)); 
testval = 1; 
[h,p,ci,stats] = ttest(y,testval); % one-sample t-test
m=mean(y); % calculate mean, standard error and se=stats.sd/sqrt(length(y));
d = (m - testval)/stats.sd;
%plot 
figure
bar(m);
hold on
set(gca,'FontSize',12)
plot([get(gca,'Xlim')],[testval testval],'k--') ;
errorbar(m,stats.sd,'k.') %set error bar
xticklabels('Gray');
ylabel('luminance ratio');

%blue
blueREF= BMdataTable(BMdataTable.REFcol==2,[2,3]);
y=table2array(blueREF(:,2));
testval = 1;
[h,p,ci,stats] = ttest(y,testval) ;
m=mean(y);
se=stats.sd/sqrt(length(y));
d = (m - testval)/stats.sd;
%plot
figure
bar(m);
hold on
set(gca,'FontSize',12);
plot([get(gca,'Xlim')],[testval testval],'k--');
errorbar(m,stats.sd,'k.');
xticklabels('Blue');
ylabel('luminance ratio');

%% Question2:
%blue&magenta
blue= BMdataTable(BMdataTable.REFcol==2,[2,3]);
magenta= BMdataTable(BMdataTable.REFcol==6,[2,3]);
y1=table2array(blue(:,2));
y2=table2array(magenta(:,2));
[h,p,ci,stats] = ttest(y1,y2); 
m1=mean(y1);
m2=mean(y2);
se1=std(y1)/sqrt(length(y1)); 
se2=std(y2)/sqrt(length(y2)); 
d=(m1 - m2)/stats.sd;
%plot
figure
bar([m1 m2]);
hold on
errorbar([m1 m2],[std(y1) std(y2)],'k.')  % error bar ({'blue', 'magenta'})
xlabel('Reference color blue&magenta ');
ylabel('Luminance ratio'); 
set(gca,'FontSize',12);

%blue&red
red= BMdataTable(BMdataTable.REFcol==8,[2,3]);
redData = BMdataTable(BMdataTable{:,2} == 8, 3);
y1=table2array(blue(:,2)); y3=table2array(red(:,2));
[h,p,ci,stats] = ttest(y1,y3); m1=mean(y1);
m3=mean(y3);
se1=std(y1)/sqrt(length(y1)); 
se3=std(y3)/sqrt(length(y3)); 
d=(m1 - m3)/stats.sd;
%plot
figure
bar([m1 m3]);
hold on
errorbar([m1 m3],[std(y1) std(y3)],'k.')  % error bar ({'blue', 'magenta'})
xlabel('Reference color blue&red');
ylabel('Luminance ratio');
set(gca,'FontSize',12);

%% Question3:
[p,tbl,stats,terms] = anovan(BMdataTable.LumRat,[BMdataTable.REFcol,BMdataTable.BGcol],'model','interaction','varnames',{'REFcol','BGcol'});

%% Question4:
%a
figure
[p,c,m]=multcompare(stats,'Dimension',2);     
hold on
set(gca,'FontSize',12);

%b
figure
[p,c,m]=multcompare(stats,'Dimension',1);     
hold on
set(gca,'FontSize',12);

