% XinmiaoZhangScript.m: CVS Homework 2 Assignment
% 9 - 12 - 2023

%%Question 1：Data file input and plotting
%1a read the file MacbethColorChecker.xls into a variable
opts = detectImportOptions('MacbethColorChecker.xls');
preview('MacbethColorChecker.xls',opts)
%1b
% Read the data from the Excel file
data = xlsread('MacbethColorChecker.xls');
% extract wavelengths from the data
wl = data(3:end, 1);
% extract reflectance data for the 24 patches
MCCref = data(3:end, 2:25);
%1c create a variable MeanRef
MeanRef = mean(MCCref);
%1d plot MeanRef
figure;
plot(MeanRef, '-o', 'LineWidth', 1.5, 'MarkerSize', 6);
title('Average Reflectance for the 24 Patches');
xlabel('Patch Number');
ylabel('Average Reflectance');
grid on;
[sortedValues, sortedIndices] = sort(MeanRef, 'descend');
highestPatches = sortedIndices(1:3);
disp(['The patches with the 3 highest average reflectance values are: ', num2str(highestPatches)])
%19, 20, 16 have the highest average, because they are lighter in color
%1e create a variable yel
row570nm = find(wl == 570);
yel = MCCref(row570nm, :);
%1f plot the reflectance at wavelength 570 nm
% Create a new figure
figure;
plot(yel, '-o', 'LineWidth', 1.5, 'MarkerSize', 6);
title('Reflectance at 570 nm for the 24 Patches');
xlabel('Patch Number');
ylabel('Reflectance at 570 nm');
grid on;
% For bonus: Identify patches with the 4 highest values at 570 nm
[sortedYelValues, sortedYelIndices] = sort(yel, 'descend');
highestYelPatches = sortedYelIndices(1:4);
% Display the patches with the 4 highest values in the command window
disp(['The patches with the 4 highest reflectance values at 570 nm are: ', num2str(highestYelPatches)])

%%Question 2: image reading, data, and plotting
%2a read the image file MCC24.jpg 
imgSRGB = imread('MCC24.jpg');
%2b display the image from the data in imgSRGB
figure; 
imshow(imgSRGB);
title('MCC24 Image');
%c display an achromatic image from only the B channel data in imgSRGB
% extract the blue channel from imgSRGB
B = imgSRGB(:, :, 3);
% create an achromatic image using only the B channel data
achromatic_img = cat(3, B, B, B); % Concatenate B channel data to R, G, and B channels
% display the achromatic image
figure; % Create a new figure window
imshow(achromatic_img);
title('Achromatic Image from B Channel');
%d convert the data in imgSRGB to XYZ in a new variable called imgXYZ
imgXYZ = rgb2xyz(imgSRGB);
%e display an achromatic image from only the Y dimension in imgXYZ
Y = imgXYZ(:, :, 2); % extract the Y channel from imgXYZ
Y_normalized = Y / max(Y(:));
achromatic_Y = cat(3, Y_normalized, Y_normalized, Y_normalized);
figure; % Create a new figure window
imshow(achromatic_Y);
title('Achromatic Image from Y Dimension');
% 16,19,20 look the lightest. 
% Compared with Question1, 
% 16 also showed high reflectance values in the `MeanRef` plot, which explains its high luminance.
% 19 hasthe highest average reflectance, which aligns with it being one of the lightest patches in the luminance image.
% 20 was among the patches with higher reflectance values, making it appear lighter in the luminance image.
