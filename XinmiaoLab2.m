%% example unique yellow data - fitting psych function for 0-1 data
%load example yellow hue stim and response data
%Resp 0 = reddish, 1 = greenish
experi_data = readmatrix('XinmiaoLab2Date.xls');

%sort data
hue=experi_data(:,2)
resp=experi_data(:,3)
[hueSort,I]=sort(hue)
respSort=resp(I)
experi_data=[hueSort, respSort]


%show stats for each hue stim
dataTable = table(experi_data(:,1), experi_data(:,2),...
                  'VariableNames',{'Hue', 'Resp'});
tblStats = grpstats(dataTable,{ 'Hue'},...
               {'mean' 'std' 'numel'})
tblCount = grpstats(dataTable,{ 'Hue', 'Resp'}) %notice this doesnt show every group
%computing count and proportions from table data
tblStats.FreqRed = tblStats.mean_Resp.*tblStats.numel_Resp
tblStats.FreqGreen = tblStats.numel_Resp-tblStats.FreqRed
tblStats.Prop = tblStats.FreqRed./tblStats.numel_Resp %notice same as mean_Resp since its 0-1

%-------yellow: final probit plot with CIs, threshold, etc
x = tblStats.Hue(1:9)
y = tblStats.FreqGreen(1:9)
n = tblStats.numel_Resp(1:9)
[b, d, s] = glmfit(x,[y n],'binomial','Link','probit')
[yfit, ciLO, ciHI] = glmval(b,x,'probit',s)
figure;
plot(x,y./n,'o',x,yfit,'r-')
hold on
Thresh = interp1(yfit,x, .5);
set(gca,'XLim',[min(x) max(x)]);
plot(x,(yfit-ciLO),'--b')
plot(x,(yfit+ciHI),'--b')
plot([x(1) Thresh],[.5 .5],'k--');
plot([Thresh Thresh],[.5 0],'k--');
text(Thresh,min(get(gca,'YLim')),...
    [' Unique Hue @ ' num2str(Thresh)],...
    'HorizontalAl','left',...
    'VerticalAl','bottom',...
    'Color','k','fontsize',12);
title('Unique Yellow')
xlabel('Stimulus Hue');
ylabel('Reddish <-    Proportion    -> Greenish');
legend('Measured Data','Probit fit','95% CI','Location','NorthWest')
xticks([75:3:110])

%%--------blue
x2 = tblStats.Hue(10:18)
y2 = tblStats.FreqGreen(10:18)
n2 = tblStats.numel_Resp(10:18)
[b, d, s] = glmfit(x2,[y2 n2],'binomial','Link','probit')
[y2fit, ciLO2, ciHI2] = glmval(b,x2,'probit',s)
figure;
plot(x2,y2./n2,'o',x2,y2fit,'r-')
hold on
Thresh2 = interp1(y2fit,x2, .5);
set(gca,'XLim',[min(x2) max(x2)]);
plot(x2,(y2fit-ciLO2),'--b')
plot(x2,(y2fit+ciHI2),'--b')
plot([x2(1) Thresh2],[.5 .5],'k--');
plot([Thresh2 Thresh2],[.5 0],'k--');
text(Thresh2,min(get(gca,'YLim')),...
    [' Unique Hue @ ' num2str(Thresh2)],...
    'HorizontalAl','left',...
    'VerticalAl','bottom',...
    'Color','k','fontsize',12);
title('Unique blue')
xlabel('Stimulus Hue');
ylabel('Reddish <-    Proportion    -> Greenish');
legend('Measured Data','Probit fit','95% CI','Location','NorthWest')
xticks([222:3:291])

%% search colorpatches
%%blue
blues = generateRGBSamples([60, 30, 260], 12, 30) %this will gave us
[min(blues(:,1:3)); max(blues(:,1:3))] %check gamut, range might be too big, you'll get an error!
%plot the wide range of blue samples
Hf = figure;
for i = 1:length( blues )
    subplot(5,5,i);
patch([0,1,1,0],[0,0,1,1],blues(i,1:3),'EdgeColor','none')
set(gca,'Visible','off')
text(0,.9,num2str(round(blues(i,4))),'FontSize',12);
end

MYblues = generateRGBSamples([60, 30, 260], 4, 30) %260 is center, 4*2+1=9, 260 +/-25 = 235-285 

%double check these choices in a plot
Hf = figure;
for i = 1:length( MYblues )
    subplot(3,3,i);
patch([0,1,1,0],[0,0,1,1],MYblues(i,1:3),'EdgeColor','none')
set(gca,'Visible','off')
text(0,.9,num2str(round(MYblues(i,4))),'FontSize',12);
end

%% yellows
yels = generateRGBSamples([75, 50, 90], 12, 30) %check gamut, range might be too big, you'll get an error!

%plot the wide range of yellow samples
Hf = figure;
for i = 1:length( yels )
    subplot(5,5,i);
patch([0,1,1,0],[0,0,1,1],yels(i,1:3),'EdgeColor','none')
set(gca,'Visible','off')
text(0,.9,num2str(round(yels(i,4))),'FontSize',12);
end

MYyels = generateRGBSamples([75, 50, 90], 4, 12.5) %90 is center, 4*2+1=9, 90 +/-12.5 = 78-103(ish) 

Hf = figure;
for i = 1:length( MYyels )
    subplot(3,3,i);
patch([0,1,1,0],[0,0,1,1],MYyels(i,1:3),'EdgeColor','none')
set(gca,'Visible','off')
text(0,.9,num2str(round(MYyels(i,4))),'FontSize',12);
end


%%green
greens = generateRGBSamples([70, 40, 165], 12, 15) %this will gave us
[min(greens(:,1:3)); max(greens(:,1:3))] %check gamut, range might be too big, you'll get an error!
%plot the wide range of blue samples
Hf = figure;
for i = 1:length( greens )
    subplot(5,5,i);
patch([0,1,1,0],[0,0,1,1],greens(i,1:3),'EdgeColor','none')
set(gca,'Visible','off')
text(0,.9,num2str(round(greens(i,4))),'FontSize',12);
end

MYgres = generateRGBSamples([70, 40, 165], 4, 15) %90 is center, 4*2+1=9, 90 +/-12.5 = 78-103(ish) 

Hf = figure;
for i = 1:length( MYgres )
    subplot(3,3,i);
patch([0,1,1,0],[0,0,1,1],MYgres(i,1:3),'EdgeColor','none')
set(gca,'Visible','off')
text(0,.9,num2str(round(MYgres(i,4))),'FontSize',12);
end

%%red
reds = generateRGBSamples([65, 55, 20], 12, 15) %this will gave us
[min(reds(:,1:3)); max(reds(:,1:3))] %check gamut, range might be too big, you'll get an error!
%plot the wide range of blue samples
Hf = figure;
for i = 1:length( reds )
    subplot(5,5,i);
patch([0,1,1,0],[0,0,1,1],reds(i,1:3),'EdgeColor','none')
set(gca,'Visible','off')
text(0,.9,num2str(round(reds(i,4))),'FontSize',12);
end

MYreds = generateRGBSamples([65, 55, 20], 4, 15) %90 is center, 4*2+1=9, 90 +/-12.5 = 78-103(ish) 

%double check these choices in a plot
Hf = figure;
for i = 1:length( MYreds )
    subplot(3,3,i);
patch([0,1,1,0],[0,0,1,1],MYreds(i,1:3),'EdgeColor','none')
set(gca,'Visible','off')
text(0,.9,num2str(round(MYreds(i,4))),'FontSize',12);
end
%% another look at your stimuli
MYbluesLAB = rgb2lab(MYblues(:,1:3));
MYyelsLAB = rgb2lab(MYyels(:,1:3));
MYgresLAB = rgb2lab(MYgres(:,1:3));
MYredsLAB = rgb2lab(MYreds(:,1:3));
figure;
scatter(MYbluesLAB(:,2),MYbluesLAB(:,3),60,MYblues(:,1:3),'filled')
hold on
scatter(MYyelsLAB(:,2),MYyelsLAB(:,3),60,MYyels(:,1:3),'filled')
scatter(MYgresLAB(:,2),MYgresLAB(:,3),60,MYgres(:,1:3),'filled')
scatter(MYredsLAB(:,2),MYredsLAB(:,3),60,MYreds(:,1:3),'filled')
axis equal
axis([ -100 100, -100 100 ]);
plot([0 0],get(gca,'YLim'),'k--');
plot(get(gca,'XLim'),[0 0],'k--');
xlabel('a*'); ylabel('b*');title('My Hues');
