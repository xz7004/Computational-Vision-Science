cvs_dispdata = load('cvs_lab3_dispdata.mat');
rgb = cvs_dispdata.rgb;
xyz = cvs_dispdata.xyz;
% display model parameters: black (flare), matrix, LUT (EOTF)
%% Question 1: Where are the black and white display values located (which rows of rgb)? What are the black and white XYZ tristimulus values?
kindex = find(all(rgb==0,2));%black index: find all rgbs = [0 0 0]
kXYZ1 = xyz(kindex,:);
disp(kXYZ1);
kXYZ = mean(xyz(kindex,:)); %mean of black XYZ measurements, quality of lights
windex = find(all(rgb==255,2)); %white index: find all rgbs = [255 255 255]
wXYZ1 = xyz(windex,:); %white XYZ white point of display
disp(wXYZ1);
wXYZ = mean(xyz(windex,:))  %mean of white XYZ measurements
%% Question 2: What is the primary matrix of the display? 
% What do these numbers indicate (where do the values in the rows and columns come from, and what do they mean)?
pindex(1,1)= find(all(rgb==[255 0 0],2)); %primary measurement red
pindex(2,1)= find(all(rgb==[0 255 0],2)); %green
pindex(3,1)= find(all(rgb==[0 0 255],2)); %blue
%pindex = [29; 58; 87] %primary index: find rgb = [255 0 0; 0 255 0; 0 0 255] you have to find the rows corresponding to these in rgb
xyz2 = xyz - repmat(kXYZ,length(xyz),1); %removing black from rest of measurements
M = xyz2(pindex,:)'; %primary matrix 列是redgreenblue 行是xyz
disp(M);
%% Question 3: Use the neutral(gray) ramp and primary matrix to create EOTF curves (transform input RGB [0-255] to linear RGB [0-1], 
% then interpolate from measured values to full 0-255 range). Plot the EOTF curves. 
% These are your 3x1D LUTs. 
%create EOTF curves from gray-ramp data
grayRGB = ( M \ xyz2(157:208,:)' )'; %you have to make sure the index (88:116) matches your gray ramp data (all RGB equally increasing from 0-255)
%above is the same as RGBlin = inv(M) * XYZramp - XYZk from course slides
LUT = interp1(rgb(157:208,1),grayRGB,(0:255)'); %interpolate to span full 0-255 range
%plot EOTF  - these are your 3x1D LUTs
figure;
plot([0:255],LUT) ;
xlabel('Digital Code Value');
ylabel('RGBlin');
title('EOTF'); %y轴是线性RGB
xlim([0 255]); 
ylim([0 1]);
%% question 4: Now use these to run a whole forward model for the ‘verification’ colors: 
% RGB[0-255] -> linRGB[0-1] via LUT -> XYZpred via primaryMatrix (+blackXYZ). 
% You will end up with predicted XYZ values for the verification colors. What do these mean (or why do we want these)?
%run whole forward model for "verification" colors - colors after the ramps
RGB = rgb(209:end,:); %RGB inputs for verification colors
XYZ = xyz(209:end,:); %measured XYZ for verification colors
RGBlin=zeros(size(RGB)); 
for i = 1:3           %convert to linearRGB
    RGBlin(:,i) = LUT((RGB(:,i)+1),i);
end
XYZest = ( M * RGBlin' )' + kXYZ;    %use matrix to predict XYZ (add black/flare back)
%% question 5: Quantify the colorimetric error between the measured and predicted XYZs of these colors using deltaE00. 
% Create a histogram of the color differences and report the overall mean, min, and max color difference. 
% How well does your model fit the display measurements (would this be a good model to use for color-critical tasks)?
%calculate error in deltaE00 between measured and predicted XYZs
%XYZn = xyz(ones(length(lambda),1),cie.cmf,cie.illD65); %set XYZn
XYZn = [95.0438;100;108.8368]' ; %just leave this (whitepoint XYZ for D65 - this is needed for function 'lab')    
error = deltaE00(lab(XYZ',XYZn),lab(XYZest',XYZn)); %using function 'lab' to convert XYZ to LAB
meanDE=mean(error); %mean, min, and max DE
minDE=min(error);
maxDE=max(error);
DE_number = [meanDE,minDE,maxDE];
%disp
%plot the DE error between measured and predicted XYZ
figure;
hist(error,35);
hold on
plot([meanDE meanDE],get(gca,'YLim'),'r--');
text(meanDE*1.05,max(get(gca,'YLim'))*0.8,...
    ['Mean \DeltaE^*_{00} = ' num2str(meanDE)],...
    'HorizontalAl','left',...
    'VerticalAl','bottom',...
    'Color','r');
xlabel('DeltaE');
ylabel('freq');
%% question 6: Create a new variable consisting of the following XYZ values: 
% These are 6 new colors (in XYZ) that you want to accurately display on the monitor. 
% Run a ‘reverse model’ that will give the predicted RGB inputs [0-255] for these colors for the display. What are the RGB inputs you get?
XYZ1=[ 62.54 41.95 7.94 108 7 11 ;95 88 79 114 8 22;21 64 63 121 8 3]';
XYZ2=XYZ1-kXYZ;
RGBlinest = (inv(M) * XYZ2' )' 
for i = 1:6
[~,idx(i,:)]=min(abs(RGBlinest(i,:)-LUT)) ;
end
RGBest = idx-1;
disp(RGBest);
%% question 7: Using the code provided with the in-class demo as a starting point, make the following plots (4 separate plots) 
% in xy chromaticity space (remember xyz[chromaticity coordinates] is different than XYZ[tristimulus values]):
data = xlsread('StdObsFuncs.xls'); 
% a. Plot the spectral locus using the StdObsFuncs.xls data. What does this spectral locus represent?
wl = data(:,1); 
cmf2 = data(:,2:4);
sl_xy(:,1) = cmf2(:,1)./(cmf2(:,1)+cmf2(:,2)+cmf2(:,3)); %computing x
sl_xy(:,2) = cmf2(:,2)./(cmf2(:,1)+cmf2(:,2)+cmf2(:,3)); %computing y
figure
plot(sl_xy(:,1),sl_xy(:,2),'k');
axis equal;
% b. Plot the measured xy chromaticity coordinates of the display’s primaries. What do these points represent? 
% If you were to draw a triangle connecting them, what does the triangle represent?
%xy of all measured XYZ colors
allcolors=xyz2rgb(xyz./100);
all_xy(:,1) = (xyz(:,1)./(xyz(:,1)+xyz(:,2)+xyz(:,3)))
all_xy(:,2) = (xyz(:,2)./(xyz(:,1)+xyz(:,2)+xyz(:,3)))
prim_xy = all_xy([pindex],:);
prim_xy(4,:)=prim_xy(1,:);
primcolors=allcolors([pindex],:);
primcolors(4,:)=primcolors(1,:); %
primcolors = min(max(primcolors,0),1) ;
slRGB = xyz2rgb(cmf2); 
slRGB = min(max(slRGB,0),1) ;
figure
hold on
box on
for i = 2:length(wl)
 plot(sl_xy([i-1 i],1),sl_xy([i-1 i],2),'Color',slRGB(i,:));
end
plot(prim_xy(:,1),prim_xy(:,2),'-k'); %gamut
for ii = 1:length(prim_xy)
 plot(prim_xy(ii,1),prim_xy(ii,2),'Color',primcolors(ii,:),'Marker','.','MarkerSize',20);
end
xlabel('x'); ylabel('y');
axis equal
axis([0 .8 0 .9]);
grid on
set(gca,'Color',[.9 .9 .9],'GridColor','w','GridAlpha',1);
title('Primary Chromaticity');
set(gca,'TickDir','out');
set(gca,'FontSize',12);
% c. Plot the measured xy chromaticity coordinates of the primary ramps (the individual R, G, and B ramps).
ramp_xy = all_xy([1:156],:);
rampcolors=allcolors([1:156],:);
rampcolors = min(max(rampcolors,0),1) ;
figure
hold on
box on
for i = 2:length(wl)
 plot(sl_xy([i-1 i],1),sl_xy([i-1 i],2),'Color',slRGB(i,:));
end
plot(prim_xy(:,1),prim_xy(:,2),'-k'); %gamut
for i2 = 1:length(ramp_xy)
 plot(ramp_xy(i2,1),ramp_xy(i2,2),'Color',rampcolors(i2,:),'Marker','x','MarkerSize',5);
end
xlabel('x'); ylabel('y');
axis equal
axis([0 .8 0 .9]);
grid on
set(gca,'Color',[.9 .9 .9],'GridColor','w','GridAlpha',1);
title('Ramp Chromaticity');
set(gca,'TickDir','out');
set(gca,'FontSize',12);
% d. Plot the measured xy chromaticity coordinates of all the verification colors. 
ver_xy = all_xy([209:333],:);
vercolors=allcolors([209:333],:);
vercolors = min(max(vercolors,0),1) ;
figure
hold on
box on
for i = 2:length(wl)
 plot(sl_xy([i-1 i],1),sl_xy([i-1 i],2),'Color',slRGB(i,:));
end
plot(prim_xy(:,1),prim_xy(:,2),'-k'); %gamut
for ii = 1:length(ver_xy)
 plot(ver_xy(ii,1),ver_xy(ii,2),'Color',vercolors(ii,:),'Marker','x','MarkerSize',5);
end
xlabel('x'); ylabel('y');
axis equal
axis([0 .8 0 .9]);
grid on
set(gca,'Color',[.9 .9 .9],'GridColor','w','GridAlpha',1);
title('Verification Chromaticity');
set(gca,'TickDir','out');
set(gca,'FontSize',12);
%% question 8: Finally you will take your own measurements of a display 
% (your monitor or someone else’s. This can also be done in a group – e.g., everyone taking measurements of one person’s monitor). 
% Please coordinate with the TA to arrange a time to come in, and have them help setup the CR-250, drivers, and code needed to take measurements. 
% You can use ‘monitorMeasureLoop.m’ and the ‘shorter version’ (106 colors) of the rgb array to make your measurements.
%% b: For this new display data, complete all of the steps necessary to determine how well your 
% new measurements can be used to create a new color display model:
xinmiao_dispdata = load('MyMeasurements106.mat');
myrgb = xinmiao_dispdata.rgb;
myxyz = xinmiao_dispdata.measXYZ;
%% i. Create black, white, and primary matrixes.
mykindex = find(all(myrgb==0,2));
mykXYZ1 = myxyz(mykindex,:);
disp(mykXYZ1);
mykXYZ = mean(myxyz(mykindex,:)); 
mywindex = find(all(myrgb==255,2)); 
mywXYZ1 = myxyz(mywindex,:); 
disp(mywXYZ1);
mywXYZ = mean(myxyz(mywindex,:)); 
mypindex(1,1) = find(all(myrgb == [255 0 0], 2), 1);
mypindex(2,1) = find(all(myrgb == [0 255 0], 2), 1);
mypindex(3,1) = find(all(myrgb == [0 0 255], 2), 1);
myxyz2 = myxyz - repmat(mykXYZ,length(myxyz),1); 
myM = myxyz2(mypindex,:)'; 
disp(myM);
%% ii. Create EOTF/LUT from gray ramp measurements.
mygrayRGB = ( myM \ myxyz2(5:22,:)' )'; 
myLUT = interp1(myrgb(5:22,1),mygrayRGB,(0:255)'); 
figure;
plot([0:255],LUT) ;
xlabel('Digital Code Value');
ylabel('RGBlin');
title('My EOTF'); 
xlim([0 255]); 
ylim([0 1]);
%% iii. Run forward model to get XYZpred for the verification colors.
myRGB = myrgb(77:end,:); 
myXYZ = myxyz(77:end,:); 
myRGBlin=zeros(size(myRGB)); 
for i = 1:3           %convert to linearRGB
    myRGBlin(:,i) = myLUT((myRGB(:,i)+1),i);
end
myXYZest = ( myM * myRGBlin' )' + mykXYZ;  
%% iv. Calc DE colorimetric difference between measured and predicted XYZ
myXYZ1=[ 62.54 41.95 7.94 108 7 11 ;95 88 79 114 8 22;21 64 63 121 8 3]';
myXYZ2=myXYZ1-mykXYZ;
myRGBlinest = (inv(myM) * myXYZ2' )' 
for i = 1:6
[~,idx(i,:)]=min(abs(myRGBlinest(i,:)-myLUT)) ;
end
myRGBest = idx-1;
disp(myRGBest);
%% v. Create a histogram of DEs, calculate Mean/Min/Max DE, and provide your assessment of your model.
XYZn = [95.0438;100;108.8368]' ; %just leave this (whitepoint XYZ for D65 - this is needed for function 'lab')    
myerror = deltaE00(lab(myXYZ',XYZn),lab(myXYZest',XYZn)); %using function 'lab' to convert XYZ to LAB
mymeanDE=mean(myerror); %mean, min, and max DE
myminDE=min(myerror);
mymaxDE=max(myerror);
myDE_number = [mymeanDE, myminDE, mymaxDE];
%plot the DE error between measured and predicted XYZ
figure;
hist(myerror,35);
hold on
plot([mymeanDE mymeanDE],get(gca,'YLim'),'r--');
text(mymeanDE*1.05,max(get(gca,'YLim'))*0.8,...
    ['Mean \DeltaE^*_{00} = ' num2str(mymeanDE)],...
    'HorizontalAl','left',...
    'VerticalAl','bottom',...
    'Color','r');
xlabel('myDeltaE');
ylabel('freq');
%% c. Create a plot for this new display data: it should contain 1) the spectral locus, 
% 2) the xy chromaticity coordinates of the display’s primaries, 3) a triangle connecting them.
myallcolors=xyz2rgb(myxyz./100);
myall_xy(:,1) = (myxyz(:,1)./(myxyz(:,1)+myxyz(:,2)+myxyz(:,3)))
myall_xy(:,2) = (myxyz(:,2)./(myxyz(:,1)+myxyz(:,2)+myxyz(:,3)))
myprim_xy = myall_xy([mypindex],:);
myprim_xy(4,:)=myprim_xy(1,:);
myprimcolors=myallcolors([mypindex],:);
myprimcolors(4,:)=myprimcolors(1,:); %
myprimcolors = min(max(myprimcolors,0),1) ;
myslRGB = xyz2rgb(cmf2); 
myslRGB = min(max(myslRGB,0),1) ;
figure
hold on
box on
for i = 2:length(wl)
 plot(sl_xy([i-1 i],1),sl_xy([i-1 i],2),'Color',myslRGB(i,:));
end
plot(myprim_xy(:,1),myprim_xy(:,2),'-k'); %gamut
for i2 = 1:length(myprim_xy)
 plot(myprim_xy(i2,1),myprim_xy(i2,2),'Color',myprimcolors(i2,:),'Marker','.','MarkerSize',20);
end
xlabel('x'); ylabel('y');
axis equal
axis([0 .8 0 .9]);
grid on
set(gca,'Color',[.9 .9 .9],'GridColor','w','GridAlpha',1);
title('Primary Chromaticity');
set(gca,'TickDir','out');
set(gca,'FontSize',12);

