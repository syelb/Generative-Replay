% Localiser for MEG Lego task

clear, close all


%% set up prelim

based    = fullfile('E:\work\Projects_open\StimConstrMEG\Task_Scanner\StimConstrMEG');
% based       = 'C:\Users\pschwart\Desktop\StimConstrMEG';
task_parent = fullfile(based,'Task');
task_dir    = fullfile(based,'Task','Localiser_Task_Rest');

data_dir = fullfile(based,'Data');
% func_dir = 'C:\Users\pschwart\Desktop\Functions_Lego';
func_dir = 'E:\work\Projects_open\Functions_Lego';

cd(task_dir)

addpath(task_parent)
addpath(data_dir)
addpath(func_dir)
addpath(based)

rand('state',sum(100*clock)); 

code = 'L*';

% -------------------------------------------------------------------------
% subject details
snum = []; doscan = []; testing_mode = [];
% snum = 99; doscan = 1;  testing_mode = false;

if isempty(snum),         snum         = input('Subject number: '); end
if isempty(doscan),       doscan       = input('Scanning? (1/0): '); end
if isempty(testing_mode), testing_mode = input('Testing? (1/0): '); end

res_dir = fullfile(task_dir,'Results',['s' num2str(snum)]);
mkdir(res_dir)

files = dir(fullfile(res_dir,[code,'.mat']));
sess = length(files)+1;

code = ['L' num2str(snum) num2str(sess)];
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% other prelim stuff
prelim_stimconstr

x_pos_photodrect = 0;
y_pos_photodrect = -375;

PhotoDRectT = 50;
% -------------------------------------------------------------------------

%--------------------------------------------------------------------------
resolu = 3; % Screen resolution (1=640x480, 2=800x600, 3=1024x768, 4=1152x864, 5=1280x1024, 6=1600x1200)

if logical(doscan)
    config_display(1, resolu, cols.background, cols.black, 'Helvetica', 30, 32, 0);
else
    config_display(0, resolu, cols.background , cols.black, 'Helvetica', 30, 32, 0);
%     config_display(1, resolu, cols.background , cols.black, 'Helvetica', 30, 32, 0);
end

config_keyboard

config_log([code,'.log'])

start_cogent

% cgscale(12)
% -------------------------------------------------------------------------

%% Localiser task
% load feedback pix
cgloadbmp(99,fullfile(task_parent,'Wrong.bmp'));
cgloadbmp(100,fullfile(task_parent,'Correct.bmp'));

% load element pix
cgloadbmp(1,fullfile(task_parent,'Brick.bmp'));
cgloadbmp(2,fullfile(task_parent,'Steel.bmp'));
cgloadbmp(3,fullfile(task_parent,'Wood.bmp'));
cgloadbmp(4,fullfile(task_parent,'Concrete.bmp')); 
    
%--------------------------------------------------------------------------
% timings
fixT        = 1000;
stimT       = 2000; % time to see probe stims
testT       = 2000; % time to see question about probe stims
%--------------------------------------------------------------------------

% -------------------------------------------------------------------------
% trials
n_grid       = 6; % 6x6 grid on screen
n_elements   = 4; % number of basic building blocks
n_rep        = 25;

length_bricks = [3 3 3 3];

% define the shape of the six stimuli
starting_point = 6;
form_element{1}  = [starting_point starting_point-1 starting_point+6-1];
form_element{2}  = [starting_point starting_point+6 starting_point+6-1];

form_element{3}  = [starting_point starting_point-1 starting_point-2];
form_element{4}  = [starting_point starting_point+6 starting_point+6+6];

% make stims, randomised order, catch trials:
% [STIMS,BRICKS,order,is_correct,stim_catch_all,question_catch_all,SOLUTIONS_BUILT,relation_catch] = mk_stims(block,n_grid,form_element,length_bricks);

stims_use = [ones(n_rep,1); ones(n_rep,1)*2; ones(n_rep,1)*3; ones(n_rep,1)*4];
stims_use = stims_use(randperm(length(stims_use)));

n_trials     = length(stims_use);

catch_trial = [ones(round(n_trials/5),1); zeros(n_trials-round(n_trials/5),1)];
idx_catch   = randperm(length(catch_trial));
catch_trial = catch_trial(idx_catch);

catch_trial_correct = [ones(round(n_trials/10),1); zeros(n_trials-round(n_trials/10),1)];
catch_trial_correct = catch_trial_correct(idx_catch);

catch_trial         = logical(catch_trial);
catch_trial_correct = logical(catch_trial_correct);
%--------------------------------------------------------------------------

% -------------------------------------------------------------------------
% calculate timing
timing = (fixT + stimT) * n_trials + (testT+fixT)*sum(catch_trial);
timing = timing/1000; % in seconds

fprintf('Experiment will last for %f minutes \n',timing/60);
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% triggers - maximum number is 256:
trig_start  = 198;  % start of experiment
trig_end    = 199;  % end of experiment
trig_fix    = 210; % onset of fixation cross
trig_fix2   = 215; % onset of fixation cross
trig_catch  = 220; % onset of catch trial
trig_miss   = 255; % miss in catch trial
% Numbers 1:197 are reserved for stims, where
% 111:114 reflect individual elements
% 101-104 reflects element question in catch trial (as defined in options_catch)
% -------------------------------------------------------------------------

keynames = {' "Yes" ' ' "No" '};
block_type = 'n ELEMENT IDENTITY';
options_catch = {' "Bricks" ' ' "Steel" ' ' "Wood" ' ' "Concrete" '};

cgflip(cols.background);

for idx_keyname = 1:length(keynames)
    
    cgtext(['Please press button for ' keynames{idx_keyname}],0,0)
    
    cgtext(['This is a',block_type,' block'],0,-200)
    
    draw_RectPhotod(cols.black,x_pos_photodrect,y_pos_photodrect)
    
    cgflip(cols.background);
    
    [keylist(idx_keyname),~,~] = waitkeydown(inf);
    
end
%--------------------------------------------------------------------------

% -------------------------------------------------------------------------
% start experiment
if logical(testing_mode)
    n_trials    = 5; 
    catch_trial([3 5]) = 1;
end

draw_RectPhotod(cols.black,x_pos_photodrect,y_pos_photodrect)

cgtext('Please remain still!',0,50)
cgtext('Next session starts...',0,-55)
sess_pic = cgflip(cols.background);

waitkeydown(inf,71); % press space to continue

if doscan, SendTrigger(trig_start);  end % the start of TASK

for trial = 1:n_trials
%----------------------------------------------------------------------
% Fixation screen
if trial==1
    
    draw_RectPhotod(cols.black,x_pos_photodrect,y_pos_photodrect)
    
    t0 = cgflip(cols.background); 
end
cgtext('+',0,0)

cgpencol(cols.greydark)

draw_RectPhotod(cols.black,x_pos_photodrect,y_pos_photodrect)

tfix = cgflip(cols.background);

if doscan, SendTrigger(trig_fix); end

logstring(sprintf('Fixation at trial %d: %f', trial,tfix)); % ADDED LOGSTRING

wait(fixT)
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------    
% present stimulus
% cgdrawsprite(stims_use(trial),0,0,50,50)
draw_catchT_scanner(stims_use(trial),1)

% turn rect at bottom white for 50ms:
draw_RectPhotod(cols.white,x_pos_photodrect,y_pos_photodrect)

tobj = cgflip(cols.background);

if doscan, SendTrigger(110+stims_use(trial)); end % stim category

logstring(sprintf('Object at trial %d: %f', trial,tobj)); % ADDED LOGSTRING

wait(PhotoDRectT)

% now black again:
% cgdrawsprite(stims_use(trial),0,0,50,50)
draw_catchT_scanner(stims_use(trial),1)

draw_RectPhotod(cols.black,x_pos_photodrect,y_pos_photodrect)

trect_black = cgflip(cols.background);

% waituntil(trect_black*1000+pictureT-PhotoDRectT)
wait(stimT-PhotoDRectT)
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------    
% catch trial
correct = NaN;

if catch_trial(trial)
    
    % Fixation screen

    % cgpencol(cols.greydark)
    % cgtext('+',0,0)

    draw_RectPhotod(cols.black,x_pos_photodrect,y_pos_photodrect)
    cgtext('+',0,0)
    
    tfix_2 = cgflip(cols.background);

    if doscan, SendTrigger(trig_fix2); end

    logstring(sprintf('Fixation at trial %d: %f', trial,tfix_2)); % ADDED LOGSTRING

    % waituntil(tfix*1000+fixT)
    wait(fixT)    
    
    correct = 0;
    
    key = [];
    
    if catch_trial_correct(trial)
        
        question_ask = stims_use(trial);
        
    else
        
        random_wrong = setdiff([1:4],stims_use(trial));
        question_ask = randsample(random_wrong,1);
        
    end
    
    question_catch = options_catch{question_ask};
    
    fprintf('Is correct: %d\n',catch_trial_correct(trial))
    
    draw_catch_MEG(key,keylist,cols,question_catch,0)
    
    % turn rect at bottom white for 50ms:
    draw_RectPhotod(cols.white,x_pos_photodrect,y_pos_photodrect)
    
    tcatch = cgflip(cols.background);
    
%     if doscan, SendTrigger(100+stims_use(trial)); end
    if doscan, SendTrigger(100+question_ask); end

    logstring(sprintf('Catch Stim at trial %d: %f', trial,tcatch)); % ADDED LOGSTRING
    
    wait(PhotoDRectT)
    
    % Now black again:
    draw_catch_MEG(key,keylist,cols,question_catch,0)
    
    draw_RectPhotod(cols.black,x_pos_photodrect,y_pos_photodrect)
    
    trect_black = cgflip(cols.background);

    % Get response
    
    readkeys
    [key, t, n] = waitkeydown(testT,keylist);
    
    if ~isempty(key)
        
        draw_catch_MEG(key,keylist,cols,question_catch,0)
        
        draw_RectPhotod(cols.black,x_pos_photodrect,y_pos_photodrect)
        
        tchoice = cgflip(cols.background);
        
    elseif isempty(key)
        
        key = 0;
        
        cgpencol(cols.red),cgtext('Too late',0,0)
        
        draw_RectPhotod(cols.black,x_pos_photodrect,y_pos_photodrect)
        
        tchoice = cgflip(cols.background);
        if doscan, SendTrigger(trig_miss); end
        
    end
    
    rt = tchoice*1000 - tcatch*1000;
    
    if key~=0
            
        if (catch_trial_correct(trial) && key==keylist(1)) || (~catch_trial_correct(trial) && key==keylist(2))
            correct = 1; 
        end

    end

    if key == 0
        wait(500)
    else
        wait(testT-rt + 500)
    end
    
    logstring(sprintf('Respose to catch Q at trial %d: %f', trial,tchoice)); % ADDED LOGSTRING
    logstring(sprintf('RT and choice to catch Q at trial %d: %f, %d', trial,rt/1000,key)); % ADDED LOGSTRING
    
end
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------    
% save data
res.tmg.tfix(trial)       = tfix;
res.tmg.tobj(trial)       = tobj;

res.behav.catch_trial(trial) = catch_trial(trial);

res.behav.correct(trial)  = correct;

if catch_trial(trial)
    res.tmg.tcatch(trial)             = tcatch;
    res.tmg.tchoice(trial)            = tchoice;
    res.behav.choice(trial)           = key;
    res.behav.rt(trial)               = rt;
    res.behav.question_catch(trial,:) = question_ask;
    fprintf('#### Correct: %d ####\n',correct)
else
    res.tmg.tcatch(trial)             = NaN;
    res.tmg.tchoice(trial)            = NaN;
    res.behav.choice(trial)           = NaN;
    res.behav.rt(trial)               = NaN;
    res.behav.question_catch(trial,:) = NaN;
end
%-------------------------------------------------------------------------- 

fprintf('#### Trial %d of %d done ####\n',trial,n_trials)

end

res.behav.stims_use = stims_use;
res.tmg.sess_pic    = sess_pic;
res.tmg.t0          = t0;
res.keylist         = keylist;

% res.behav.correct_overall    = mean(res.behav.correct(~isnan(res.behav.correct)));
%-------------------------------------------------------------------------- 
draw_RectPhotod(cols.black,x_pos_photodrect,y_pos_photodrect)

cgtext('End of session',0,50)
cgtext('Thank you',0,-50)
localiser_outro = cgflip(cols.background);

if doscan, SendTrigger(trig_end);  end % the end of TASK


fprintf('#### Percent correct: %f ####\n',mean(res.behav.correct(~isnan(res.behav.correct))))

waitkeydown(4000);
% -------------------------------------------------------------------------

res.tmg.end_pic        = localiser_outro;

% -------------------------------------------------------------------------
% Save data
if ~testing_mode
    save(fullfile(res_dir,code),'res')

    copyfile(fullfile(task_dir,[code '.log']),fullfile(res_dir,[code '.log']))
    delete(fullfile(task_dir,[code '.log']))
end
% -------------------------------------------------------------------------


%% the end
stop_cogent
% -------------------------------------------------------------------------
