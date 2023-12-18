function Xinmiao_gui()

% stimuli
addpath(pwd,'pictures\') %add subfolder with images to path
gd.files = dir(fullfile(pwd,'pictures/*.jpg')); %directory of image files
numSets = 7;  % Total number of sets
numImagesPerSet = [6, 6, 4, 5, 5, 5, 3];  % Example numbers for each set

gd.pairs = [];  % Empty matrix
imageIndexOffset = 0;  % Offset to account for images in previous sets

for k = 1:numSets
    M = numImagesPerSet(k);  % Number of images in the current set
    setPairs = nchoosek(1:M, 2) + imageIndexOffset;  % Generate pairs for the current set
    gd.pairs = [gd.pairs; setPairs];  % Append to the overall pairs matrix
    imageIndexOffset = imageIndexOffset + M;  % Update the offset for the next set
end

randomPairOrder = randperm(size(gd.pairs, 1));
gd.pairs = gd.pairs(randomPairOrder, :);
gd.Ntrials = length(gd.pairs); %check to make sure your Ntrials equals your total number of trials
gd.currentRound = 1; % Start with round 1
gd.totalRounds = 2;  % Total number of rounds to complete

% create and maximize figure, remove menus 
gd.Hf = figure;
set(gd.Hf,'Position',get(groot,'ScreenSize'))
set(gd.Hf,'Menubar','none')
gd.Hf.Color = [.5 .5 .5];

% create two axes in which to display images
gd.Ha(1) = axes('Position',[.05 .1 .44 .8],'Box','off');
gd.Ha(2) = axes('Position',[.51 .1 .44 .8],'Box','off');
set(gd.Ha,'Visible','off');

% create a text box for instructions
gd.Ht = uicontrol('Style','text',...
        'Units','normalized',...
        'Position',[.05 .9 .9 .08],...
        'BackgroundColor',[.5 .5 .5],...
        'FontSize',14,'FontName','Arial',...
        'String','Press S to start the experiment');
% creat picture numbers
gd.HtName1 = uicontrol('Style', 'text', ...
        'Units', 'normalized', ...
        'Position', [.05 .05 .44 .05], ...  % Adjust position as needed
        'BackgroundColor', [.5 .5 .5], ...
        'FontSize', 12, 'FontName', 'Arial', ...
        'String', '');

gd.HtName2 = uicontrol('Style', 'text', ...
        'Units', 'normalized', ...
        'Position', [.51 .05 .44 .05], ...  % Adjust position as needed
        'BackgroundColor', [.5 .5 .5], ...
        'FontSize', 12, 'FontName', 'Arial', ...
        'String', '');  
gd.trial = 1;  %current trial number
gd.obsData = zeros(0, 3); 

% assign keyboard callback (what to do when keys are pressed)
set(gd.Hf,'KeyPressFcn',@demoGuiKeys);

% store guidata
guidata(gd.Hf,gd)

end

function demoGuiKeys(HObj,EvtData)
    gd = guidata(HObj)
    if ~ishandle(gd.Hf)
        return;
    end

    switch EvtData.Key

        case 's'
            % display first trial
            gd = displayImages(gd); %this calls another subfunction (see below, what does this do?)
            gd.Ht.String = 'Choose the image you like more using left or right arrow keys';
            
        % left arrow: if selected left image
        case 'leftarrow' 
           % clear the images
           set(get(gd.Ha(1),'children'),'visible','off')
           set(get(gd.Ha(2),'children'),'visible','off') 
           
            % record the selection
            disp('leftarrow');
            % gd.obsData(gd.trial,3) = gd.Lresp; %this is pre-defined in the subfunction below
            newDataRow = [gd.pairs(gd.trial, :), gd.Lresp];  % Create a new row with three elements
            gd.obsData = [gd.obsData; newDataRow];  % Append the new row to gd.obsData
            % increment trial
            gd.trial = gd.trial+1;

            obsData = gd.obsData;
            
            % pause between stimuli
            pause(1);

            % Check for next trial or round
             if gd.trial <= gd.Ntrials
                gd = displayImages(gd);
            elseif gd.currentRound < gd.totalRounds
                % Start next round
                gd.currentRound = gd.currentRound + 1;
                gd.trial = 1;
                guidata(gd.Hf, gd);
                gd = displayImages(gd);
            else
                % or else finish up
                fileName = sprintf('mynamepairsdemo%s.xls', datestr(now,'mm-dd-yyyy HH_MM_SS')); %set a file name according to date
                writematrix(gd.obsData, fileName)    %save the data to a file
                close(HObj)
                % return
            end
        
        % right arrow: select right image
        case 'rightarrow'
            % clear the images
            set(get(gd.Ha(1),'children'),'visible','off')
            set(get(gd.Ha(2),'children'),'visible','off') 
            
            % record the selection
            disp('rightarrow');
            % gd.obsData(gd.trial,3) = gd.Rresp; %this is the only thing that changes for 'rightarrow'
            newDataRow = [gd.pairs(gd.trial, :), gd.Rresp];  % Similarly for the right arrow key
            gd.obsData = [gd.obsData; newDataRow];
            % increment trial
            gd.trial = gd.trial+1;

            obsData = gd.obsData;
            
            % pause between stimuli
            pause(1);

            % Check for next trial or round
             if gd.trial <= gd.Ntrials
                gd = displayImages(gd);
            elseif gd.currentRound < gd.totalRounds
                % Start next round
                gd.currentRound = gd.currentRound + 1;
                gd.trial = 1;
                % Reshuffle the pairs for the new round
                randomPairOrder = randperm(size(gd.pairs, 1));
                gd.pairs = gd.pairs(randomPairOrder, :);
                guidata(gd.Hf, gd);
                gd = displayImages(gd);
            else
                % finish
                fileName = sprintf('XinmiaoLab4Data.xls', datestr(now,'mm-dd-yyyy HH_MM_SS'));
                writematrix(gd.obsData, fileName)   
                close(HObj)
                % return
            end

        case 'escape'
            close(HObj)
            return
        % otherwise
            % do nothing
    end
    % Update guidata only if gd.Hf is a valid figure handle
    if ishandle(gd.Hf)
        guidata(gd.Hf, gd);
    end
end
% end of demoGuiKeys

function gd = displayImages(gd)
    % argument: 
    %   gd: struct of userdata for GUI

    % random left-right presentation
    gd.side = ceil(rand(1) * 2); % will either be 1 or 2 each trial
    if gd.side == 1    % will decide which image will be on which side
        side = [1 2];  % im1Left, im2Right
    else
        side = [2 1];  % im2Left, im1Right
    end

    % display images 
    axes(gd.Ha(1));
    imshow(gd.files(gd.pairs(gd.trial, side(1))).name); % picks one of the image pairs from 'side'
    set(gd.HtName1, 'String', gd.files(gd.pairs(gd.trial, side(1))).name); % update text label for left image

    axes(gd.Ha(2));
    imshow(gd.files(gd.pairs(gd.trial, side(2))).name); % picks the other of the image pairs from 'side'
    set(gd.HtName2, 'String', gd.files(gd.pairs(gd.trial, side(2))).name); % update text label for right image

    % pre-define responses
    gd.Lresp = gd.pairs(gd.trial, side(1)); % saves which image the observer picked if they choose 'left'
    gd.Rresp = gd.pairs(gd.trial, side(2)); % saves which image the observer picked if they choose 'right'
end
% end of displayImages

% img = imread('D:\Matlab\computational vision science homework\Lab4\trial2\Land2_10.jpg');
% correctedImg = imrotate(img, -90);           % Rotate 90 degrees to the right
% imshow(correctedImg);
% imwrite(correctedImg, 'corrected_image.jpg');
