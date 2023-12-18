%%XinmiaoLab 1
%9/27/2023
%These are the reference colors we will be using to test the Helmholtz-Kohlrausch
%effect
refCols = [0.475	0.475	0.475
0.038	0.454	0.967
0.653	0.428	0.079
0.101	0.551	0.105
0.051	0.528	0.54
0.83	0.068	0.834
0.483	0.494	0.08
0.94	0.095	0.067
];

%display the colors
figure;
set(gcf,'color',[.45 .45 .45]);
dispIm=zeros(50,50,3);
for i = 1:length( refCols )
    dispIm(:,:,1) = refCols(i,1);
    dispIm(:,:,2) = refCols(i,2);
    dispIm(:,:,3) = refCols(i,3);
    subplot(2,4,i);
    imshow(dispIm)
end
%Which ones look brightest?

%convert to XYZ to check luminance (remember Y is relative luminance)
refColsXYZ = rgb2xyz(refCols); 

%check this in a plot
figure; 
b=bar(refColsXYZ(:,2),'FaceColor','flat'); ylim([0 1]); ylabel('Y relative luminance') %plotting Y luminance
b.CData=refCols; %setting bar colors to match patch colors
%don't rember how to do sth, but how to find
%check this in image
figure;
dispIm=zeros(50,50,1);
for i = 1:length( refColsXYZ )
    dispIm(:,:,1) = refColsXYZ(i,1);
    dispIm(:,:,2) = refColsXYZ(i,2);
    dispIm(:,:,3) = refColsXYZ(i,3);
    subplot(2,4,i);
    imshow(dispIm(:,:,2)) %just plotting the Y channel - remember this is basically a heatmap of that single channel
end

%What about saturation (chroma)?
refColsLAB = rgb2lab(refCols);
refColsCHROMA = sqrt( (refColsLAB(:,2).^2) + (refColsLAB(:,3).^2) );
figure; 
b=bar(refColsCHROMA(:,1),'FaceColor','flat'); ylim([0 110]); ylabel('C* Chroma') %plotting C* Chroma
b.CData=refCols; %setting bar colors to match patch colors


%go to brightnessMatching GUI

%% data from LAB1%%
%What does the ouput mean? What do you have to do?
%下载每个人的表格
%1. read in excel data (combine from all observers)
folder = 'D:\Matlab\computational vision science homework\Lab1'; 
flist = dir('*xls')                   %read all .xls files from directory读所有的文件
allDat = [];                                %make blank array
for i = 1:length(flist)                     %loop to read in all data
    dat{i} = readmatrix(flist(i).name);     %storing all data from file
    allDat = [allDat; dat{i}];              %adding data to previous iteration
end
    
% each row is 1 trial
%col 1 = background color (1=white, 2=black, 3=midgray)
bgCols = [1 1 1; 0 0 0; .45 .45 .45];
%col 2 = reference color (1-8)
refCols = [0.475	0.475	0.475;0.038	0.454	0.967;0.653	0.428	0.079;0.101	0.551	0.105;0.051	0.528	0.54;0.83	0.068	0.834;0.483	0.494	0.08;0.94	0.095	0.067];
%col 3 = brightness-matches, responses, DV (1-41).
sampCols = repmat((0:.025:1)',1,3);


%% 2. map the data index (keys) to meaningful units (Y luminance and C* chroma)
    
%convert reference colors and samp to XYZ (to get luminance Y)
refColsXYZ = rgb2xyz(refCols);
sampColsXYZ = rgb2xyz(sampCols);
bgColsXYZ = rgb2xyz(bgCols);

%also convert to lab to calc C* (Chroma)
refColsLAB = rgb2lab(refCols); %get L* lightness, a* red-green, b* yellow-blue
refColsC = sqrt( (refColsLAB(:,2).^2) + (refColsLAB(:,3).^2) ); % C* = sqrt (a*^2 + b*^2)

% look-up Y of matches, add it as additional column to allDat
allDat(:,4) = sampColsXYZ(allDat(:,3),2) %go through col3 of allDat(match data), match that value to col2 of sampColsXYZ(Y of match)

% look-up Y of ref, add it as additional column to allDat
allDat(:,5) = refColsXYZ(allDat(:,2),2)  %go through col2 of allDat(ref idenfifier), match that value to col2 of refColsXYZ(Y of reference)

% compute Ymatch/Yref, add it as additional column to allDat
allDat(:,6) = allDat(:,4) ./ allDat(:,5) %to get Luminance Ratio




%% 3. plots

% exploratory boxplots  
%***needs Statistics and Machine Learning Toolbox
figure
boxplot(allDat(:,4),allDat(:,[2 1])) % plots groups by stimulus, background
ylabel('Luminance of matches')

figure
boxplot(allDat(:,6),allDat(:,[2 1]))
ylabel('Luminance ratio (Ymatch/Yref) of matches')
    
        
%% better labels
hueNames = {'Gry' 'Bl' 'Or' 'Gr' 'Tl' 'Ma' 'Yl' 'Rd'}'; %specifying the names of the hues
bgNames = {'White' 'Black' 'Gray'}';    

figure
plot([0.5 27.5],[1 1],'k--'); %making horizontal dotted line across '1' of y axis
hold on;   %saving the figure to add to in
boxplot(allDat(:,6),{ hueNames(allDat(:,2)) bgNames(allDat(:,1)) },... %making the boxpot
        'factorgap',[2 0],'colors',repelem(refCols,3,1),... %addng colors - repeating colors from data
        'boxstyle','filled','outliersize',2)
ylabel('Luminance ratio (Ymatch/Yref) of matches')     
        
%% SORTED better by color
% orig was order of stim hue
huePos = [1 5 7 3 4 2 8 6]; %now sorted by Chroma

figure
plot([0.5 27.5],[1 1],'k--'); 
hold on;
boxplot(allDat(:,6),{ hueNames(allDat(:,2)) bgNames(allDat(:,1)) },...
        'factorgap',[2 0],'colors',repelem(refCols(huePos,:),3,1),...
        'boxstyle','filled','outliersize',2,...
        'position', [1:3 16:18 10:12 13:15 4:6 22:24 7:9 19:21])
ylabel('Luminance ratio (Ymatch/Yref) of matches')        
        
%% statistics of groups
dataTable = table(allDat(:,6), hueNames(allDat(:,2)), bgNames(allDat(:,1)),...
                  'VariableNames',{'LumRatio', 'Hue', 'BG'});
tblStats = grpstats(dataTable,{ 'Hue' 'BG' },...
               {'mean' 'std' 'numel'})

%% plot Luminance Ratio against Chroma 

%look-up C* of ref, add it as additional column to allDat
allDat(:,7) = refColsC(allDat(:,2),1) %go through col2 of allDat(ref identifier), match that value to col1 of refColsC(C* of reference)

%plot
figure
scatter(allDat(:,7),allDat(:,6))
lsline
xlabel('C* Chroma of reference')
ylabel('Luminance ratio (Ymatch/Yref) of matches')
%do something to fancy this one up!!!

        
