%% datatransfer
% data = xlsread('newMichaelLab4Data.xls');
% for i = 1:size(data, 1)
%     if data(i, 1) > data(i, 2)
% 
%         temp = data(i, 1);
%         data(i, 1) = data(i, 2);
%         data(i, 2) = temp;
%     end
% end
%% data combine
% filename = 'corMIchaelData.xls'; 
% xlswrite(filename, data);
% [datasort, ~] = sortrows(data);
%  folderPath = 'D:\Matlab\computational vision science homework\Lab4\shared data';
%  files = dir(fullfile(folderPath,'*.xls'));
% combinedTable = [];
% for k = 1:length(files)
%     filePath = fullfile(folderPath, files(k).name);
%     tbl = readtable(filePath);
%     combinedTable = [combinedTable; tbl];
% end
% writetable(combinedTable, fullfile(folderPath, 'combinedData.xls'));
%%
data = xlsread('combinedData.xls');
[datasort, ~] = sortrows(data);

% % Define the row ranges for each landmark
landmark_ranges = {
    1:330,    % Landmark 1 (pictures 1 to 6)
    331:660,  % Landmark 2 (pictures 7 to 12)
    661:792,  % Landmark 3 (pictures 13 to 16)
    793:1012,  % Landmark 4 (pictures 17 to 21)
    1013:1232,  % Landmark 5 (pictures 22 to 26)
    1233:1452,  % Landmark 6 (pictures 27 to 31)
    1453:1518   % Landmark 7 (pictures 32 to 34)
};

% Number of observers for each comparison
N = 22;

% Define the actual picture numbers for each landmark
picture_numbers = [6,6,4,5,5,5,3];
num_landmarks = length(picture_numbers);
image_ranges = cell(1, num_landmarks);
start_num = 1;

for k = 1:num_landmarks
    end_num = start_num + picture_numbers(k) - 1;
    image_ranges{k} = start_num:end_num;
    start_num = end_num + 1;
end

% Process and plot data for each landmark
for k = 1:length(landmark_ranges)
    landmarkData = datasort(landmark_ranges{k}, :);
    actualPics = image_ranges{k}; % Corrected to use image_ranges
    imageMap = containers.Map(actualPics, 1:length(actualPics));
    picKeys = keys(imageMap); % Get the picture numbers as a cell array
    % Initialize the F matrix
    Fmatrix = zeros(length(actualPics), length(actualPics));
    % Fill the F matrix
    for i = 1:size(landmarkData, 1)
        if isKey(imageMap, landmarkData(i, 1)) && isKey(imageMap, landmarkData(i, 2))
            item1 = imageMap(landmarkData(i, 1));
            item2 = imageMap(landmarkData(i, 2));
            preferred = landmarkData(i, 3);
            if preferred == landmarkData(i, 1)
                Fmatrix(item1, item2) = Fmatrix(item1, item2) + 1;
            else
                Fmatrix(item2, item1) = Fmatrix(item2, item1) + 1;
            end
        end
        
    end
    % disp(['F matrix for Landmark ' num2str(k) ':']);
    % disp(Fmatrix);
    Pmatrix = Fmatrix / N;
    Pmatrix = min(max(Pmatrix, 1/(2*N)), 1 - 1/(2*N));
    Zmatrix = norminv(Pmatrix);
    Zmatrix(eye(size(Zmatrix)) > 0) = 0;
    Svalue = mean(Zmatrix, 2);
    
    % Calculate 95% confidence intervals
    CIs = 1.96 * (1 / sqrt(N * length(actualPics)));
    CIs = repmat(CIs, length(Svalue), 1);
    disp(['Scale Values and 95% Confidence Intervals for Landmark ' num2str(k) ':']);
    for imgIndex = 1:length(Svalue)
        if imgIndex <= length(actualPics)
            lowerCI = Svalue(imgIndex) - CIs(imgIndex);
            upperCI = Svalue(imgIndex) + CIs(imgIndex);
            disp(['Image ' num2str(actualPics(imgIndex)) ': Scale Value = ' num2str(Svalue(imgIndex)) ', 95% CI = (' num2str(lowerCI) ', ' num2str(upperCI) ')']);
        end
    end

  % Plotting for each landmark
    figure;
    hold on;
    title(['Image Preference Scale for Landmark #' num2str(k)]);
    xlabel('Scale Value (Z-Score)');
    
    % Plot the scale values as diamonds and the 95% CIs as horizontal lines
    for i = 1:length(Svalue)
        if i <= length(picKeys)
            % Plot the diamond marker for the scale value
            plot(Svalue(i), 0, 'd', 'MarkerSize', 15, 'MarkerFaceColor', [0 .44 .74], 'MarkerEdgeColor', [0 .44 .74]);
            % Get the original image number from the keys
            originalImageNumber = picKeys{i};
            line([Svalue(i) - CIs(i), Svalue(i) + CIs(i)], [0, 0], 'Color', 'red', 'LineWidth', 2, 'LineStyle', ':');
            % Add the text label for the image number below the diamond marker
            text(Svalue(i), -0.05, num2str(originalImageNumber), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 8);
        end
    end

    % Add a horizontal line at y = 0 if you like for reference
    line(get(gca, 'XLim'), [0 0], 'Color', 'black', 'LineStyle', '-');
    yticks([]);
    xlim([min(Svalue - CIs) - 0.1, max(Svalue + CIs) + 0.1]);
    hold off;
end