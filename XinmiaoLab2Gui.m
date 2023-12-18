function Xinmiaogui()
%setting up the experiment window
scrsz = get(0,'ScreenSize');
gd.Hf = figure('Position',[0 30 scrsz(3) scrsz(4)-95]);
set(gcf,'Color',[.5 .5 .5]);
gd.InstructText = '<<<<<< GREEN-ish              RED-ish >>>>>>'; 
gd.Ht = text(.5,.8,gd.InstructText,'HorizontalAl','center','FontSize',24);    
axis off; axis equal;  
gd.Ha = axes('Position',[.35 .3 .3 .4],'Color',[.5 .5 .5]); 
set(gd.Ha,'XColor','none','YColor','none'); 

%setup the color data
gd.blueStim = generateRGBSamples([60, 30, 260], 4, 30); %setting my blue colors 
gd.yellowStim = generateRGBSamples([75, 50, 90], 4, 12.5); %setting my yellow colors

% setup indicie
shuffled_order = randperm(18);
stim=[gd.blueStim; gd.yellowStim];
shuffled_stim = stim(shuffled_order, :);
by = [zeros(1,9) ones(1,9)];
shuffled_by = by(shuffled_order);
gd.shuffled_stim = shuffled_stim;
gd.shuffled_by = shuffled_by;
gd.i = 1;
gd.data = zeros(180,3); %making container for the data (will be 180 rows/trials x 3 columns/data values)

%initialize first color patch display
set(gd.Ha,'Color',shuffled_stim(gd.i,1:3)) %setting first patch color to be the first color, columns 1-3 (RGB)
% assign keyboard callback (what to do when keys are pressed)
set(gd.Hf,'KeyPressFcn',@myKeyPress) %tell it to look at the myKeyPress function below
% store variables in figure's GUIdata - just something you have to do
guidata(gd.Hf,gd)
end

%what happens when you press a key
function myKeyPress(HObj,EvtData)
disp(EvtData) 
gd = guidata(HObj) 

switch(EvtData.Key) 
    %left pressed: record 0 and set next patch color
    case('leftarrow')
        resp=0;
        current_index = mod(gd.i-1, 18) + 1;
        gd.data(gd.i,:) = [gd.shuffled_by(current_index), gd.shuffled_stim(current_index,4), resp];
        
        %change patch color
        gd.i = gd.i + 1; %increase trial index + 1
        if gd.i < 181 
           set(gd.Ha,'Color',[.5 .5 .5]);
           pause(1)
           set(gd.Ha,'Color',gd.shuffled_stim(mod(gd.i-1,18)+1,1:3))
        else 
            disp ('done!'); 
            disp(gd.data); 
            close(HObj)   
            return
        end
        
    %right pressed: record 0 and set next patch color 
    case('rightarrow')
        resp=1;
        current_index = mod(gd.i-1, 18) + 1;
        gd.data(gd.i,:) = [gd.shuffled_by(current_index), gd.shuffled_stim(current_index,4), resp];
        %change patch color
        gd.i = gd.i + 1; 
        if gd.i < 181
            set(gd.Ha,'Color',[.5 .5 .5]);
            pause(1)
            set(gd.Ha,'Color',gd.shuffled_stim(mod(gd.i-1,18)+1,1:3))
            
        else
            disp ('done!');
            disp(gd.data);
            xlswrite('XinmiaoLab2Date.xls', gd.data);
            close(HObj)
            return
        end
end
guidata(HObj,gd)
end