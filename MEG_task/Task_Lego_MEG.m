% MEG Lego task

% Ask about rightness, leftness, ontopness, and belowness in plan

clear, close all

%% which tasks?
do_task = true; % one session lasting for about 8 minutes
do_rest = false;
% -------------------------------------------------------------------------

%% set up prelim
based    = fullfile('/Users/Philipp/Dropbox/StimConstrMEG');
task_parent = fullfile(based,'Task');
task_dir    = fullfile(based,'Task','Localiser_Task_Rest');

func_dir = '/Users/Philipp/Dropbox/Functions_Lego';

cd(task_dir)

addpath(task_parent)
addpath(func_dir)
addpath(based)

addpath('/Users/Philipp/Dropbox/Cogent/Toolbox')


rand('state',sum(100*clock)); 

if do_task
    code = 'T*';
elseif do_rest
    code = 'R*';
end

% -------------------------------------------------------------------------
% subject details
% snum = []; doscan = []; testing_mode = [];
snum = 99; doscan = true;  testing_mode = true;

if isempty(snum),         snum         = input('Subject number: '); end
if isempty(doscan),       doscan       = input('Scanning? (1/0): '); end
if isempty(testing_mode), testing_mode = input('Testing? (1/0): '); end

res_dir = fullfile(task_dir,'Results',['s' num2str(snum)]);
mkdir(res_dir)

files = dir(fullfile(res_dir,[code,'.mat']));
sess = length(files)+1;

if do_task
    code = ['T' num2str(snum) num2str(sess)];
elseif do_rest
    code = ['R' num2str(snum) num2str(sess)];
end
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
if do_task

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
fixT        = 500;
pictureT    = 3500; % time to look at object
stimT       = 3500; % time to see probe stims
testT       = 1500; % time to see question about probe stims
%--------------------------------------------------------------------------

% -------------------------------------------------------------------------
% trials
n_grid       = 6; % 6x6 grid on screen
n_elements   = 4; % number of basic building blocks

length_bricks = [3 3 3 3];

% define the shape of the six stimuli
starting_point = 6;
form_element{1}  = [starting_point starting_point-1 starting_point+6-1];
form_element{2}  = [starting_point starting_point+6 starting_point+6-1];
form_element{3}  = [starting_point starting_point-1 starting_point-2];
form_element{4}  = [starting_point starting_point+6 starting_point+6+6];

% make stims, randomised order, catch trials:
block = 3; % element relation questions
[STIMS,BRICKS,order,is_correct,stim_catch_all,question_catch_all,SOLUTIONS_BUILT,relation_catch] = mk_stims_sparse(n_grid);

n_trials     = size(STIMS,3);

catch_trial  = ones(n_trials,1);

question_type_catch = [ones(n_trials/2,1);zeros(n_trials/2,1)];
question_type_catch = question_type_catch(randperm(length(question_type_catch)));
%--------------------------------------------------------------------------

% -------------------------------------------------------------------------
% calculate timing
timing = (fixT + pictureT) * n_trials;
timing = timing + (testT + stimT)* sum(catch_trial~=0);
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
% 111:152 reflect individual stims
% 101-104 reflects element relation in catch trial
% -------------------------------------------------------------------------

keynames = {' "Yes" ' ' "No" '};
block_type = 'n ELEMENT RELATION';
options_catch = {' "To the left" ' ' "On top" ' ' "To the right" ' ' "Below" '};

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
    n_trials            = 5;
%     question_type_catch = ones(n_trials,1);
%     question_type_catch = zeros(n_trials,1);
end

draw_RectPhotod(cols.black,x_pos_photodrect,y_pos_photodrect)

cgtext('Please remain still!',0,50)
cgtext('Next session starts...',0,-55)
sess_pic = cgflip(cols.background);

waitkeydown(inf,71);

if doscan, SendTrigger(trig_start);  end % the start of TASK

for trial = 1:n_trials
    %----------------------------------------------------------------------
    % Fixation screen
    if trial==1

        draw_RectPhotod(cols.black,x_pos_photodrect,y_pos_photodrect)

        t0 = cgflip(cols.background); 
    end

    cgpencol(cols.black)
    cgtext('+',0,0)

    draw_RectPhotod(cols.black,x_pos_photodrect,y_pos_photodrect)

    tfix = cgflip(cols.background);

    if doscan, SendTrigger(trig_fix); end

    logstring(sprintf('Fixation at trial %d: %f', trial,tfix)); % ADDED LOGSTRING

    % waituntil(tfix*1000+fixT)
    wait(fixT)
    %--------------------------------------------------------------------------

    %--------------------------------------------------------------------------    
    % present stimulus
    REQUIRED_FORM = STIMS(:,:,trial);

    REQUIRED_FORM = [zeros(size(REQUIRED_FORM,1),ceil((n_grid-size(REQUIRED_FORM,2))/2)) REQUIRED_FORM zeros(size(REQUIRED_FORM,1),ceil((n_grid-size(REQUIRED_FORM,2))/2))];
    REQUIRED_FORM = [zeros(ceil((n_grid-size(REQUIRED_FORM,1))/2),size(REQUIRED_FORM,2)); REQUIRED_FORM; zeros(ceil((n_grid-size(REQUIRED_FORM,1))/2),size(REQUIRED_FORM,2))];

    % turn rect at bottom white for 50ms:
    draw_grid_MEG

    draw_RectPhotod(cols.white,x_pos_photodrect,y_pos_photodrect)

    tobj = cgflip(cols.background);

    % if doscan, SendTrigger(order(trial)); end % stim category
    if doscan, SendTrigger(110+order(trial)); end % stim category

    logstring(sprintf('Object at trial %d: %f', trial,tobj)); % ADDED LOGSTRING

    % waituntil(tobj*1000+PhotoDRectT)
    wait(PhotoDRectT)

    % now black again:
    draw_grid_MEG

    draw_RectPhotod(cols.black,x_pos_photodrect,y_pos_photodrect)

    trect_black = cgflip(cols.background);

    % waituntil(trect_black*1000+pictureT-PhotoDRectT)
    wait(pictureT-PhotoDRectT)
    %--------------------------------------------------------------------------

    %----------------------------------------------------------------------
    % Fixation screen

    % cgpencol(cols.greydark)
    % cgtext('+',0,0)

    draw_RectPhotod(cols.black,x_pos_photodrect,y_pos_photodrect)

    tfix_2 = cgflip(cols.background);

    if doscan, SendTrigger(trig_fix2); end

    logstring(sprintf('Fixation at trial %d: %f', trial,tfix_2)); % ADDED LOGSTRING

    % waituntil(tfix*1000+fixT)
    wait(fixT)
    %--------------------------------------------------------------------------

    %--------------------------------------------------------------------------    
    % catch trial
    correct = NaN;

    bricks = BRICKS(trial,:);

    if catch_trial(trial)==1

        correct = 0;

        key = [];

        stim_catch = stim_catch_all(trial,:);

        question_catch = options_catch{question_catch_all(trial)};

        fprintf('Bricks: %d %d %d, stim catch: %d %d, is correct: %d\n',bricks,stim_catch,is_correct(trial))

        draw_catchT_scanner(stim_catch,block);

        % turn rect at bottom white for 50ms:
        draw_RectPhotod(cols.white,x_pos_photodrect,y_pos_photodrect)

        tcatch = cgflip(cols.background);

        if doscan, SendTrigger(100+relation_catch(trial)); end

        logstring(sprintf('Catch Stim at trial %d: %f', trial,tcatch)); % ADDED LOGSTRING

        wait(PhotoDRectT)

        % Now black again:
        draw_catchT_scanner(stim_catch,block);

        draw_RectPhotod(cols.black,x_pos_photodrect,y_pos_photodrect)

        trect_black = cgflip(cols.background);

        wait(stimT-PhotoDRectT)
    %--------------------------------------------------------------------------

    %--------------------------------------------------------------------------    
    % catch question    
        draw_catchT_scanner(stim_catch,block);
        draw_catch_MEG(key,keylist,cols,question_catch,question_type_catch(trial))

        draw_RectPhotod(cols.black,x_pos_photodrect,y_pos_photodrect)
        cgpencol(cols.greydark)

        tq = cgflip(cols.background);

        if doscan, SendTrigger(trig_catch); end

        logstring(sprintf('Catch Q at trial %d: %f', trial,tcatch)); % ADDED LOGSTRING    

        readkeys
        [key, t, n] = waitkeydown(testT,keylist);

        if ~isempty(key)

            draw_catchT_scanner(stim_catch,block);

            draw_catch_MEG(key,keylist,cols,question_catch,question_type_catch(trial))

            draw_RectPhotod(cols.black,x_pos_photodrect,y_pos_photodrect)
            cgpencol(cols.greydark)

            tchoice = cgflip(cols.background);

        elseif isempty(key)

            key = 0;

            cgpencol(cols.red),cgtext('Too late',0,0)

            draw_RectPhotod(cols.black,x_pos_photodrect,y_pos_photodrect)
            cgpencol(cols.greydark)

            tchoice = cgflip(cols.background);
            if doscan, SendTrigger(trig_miss); end

        end

        rt = tchoice*1000 - tq*1000;

        if key~=0

            if (is_correct(trial) && key==keylist(1)) || (~is_correct(trial) && key==keylist(2))
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

    res.behav.required_form(trial,1:n_grid^2) = [find(REQUIRED_FORM)' zeros(1,(n_grid^2-length(find(REQUIRED_FORM)')))];
    res.behav.catch_trial(trial)              = catch_trial(trial);

    res.behav.REQUIRED_FORM(:,:,trial)   = REQUIRED_FORM;
    res.behav.SOLUTIONS_BUILT(:,:,trial) = SOLUTIONS_BUILT(:,:,trial);

    res.behav.correct(trial)  = correct;

    if catch_trial(trial)~=0
        res.tmg.tcatch(trial)             = tcatch;
        res.tmg.tchoice(trial)            = tchoice;
        res.behav.choice(trial)           = key;
        res.behav.rt(trial)               = rt;
        res.behav.stim_catch(trial,:)     = stim_catch;
        res.behav.question_catch(trial,:) = question_catch_all(trial);
        res.behav.relation_catch(trial)   = relation_catch(trial);
        fprintf('#### Correct: %d ####\n',correct)
    else
        res.tmg.tcatch(trial)             = NaN;
        res.tmg.tchoice(trial)            = NaN;
        res.behav.choice(trial)           = NaN;
        res.behav.rt(trial)               = NaN;
        res.behav.stim_catch(trial)       = NaN;
        res.behav.question_catch(trial,:) = NaN;
        res.behav.relation_catch(trial)   = NaN;
    end
    %-------------------------------------------------------------------------- 

    fprintf('#### Trial %d of %d done ####\n',trial,n_trials)

end

res.order              = order;
res.keylist            = keylist;

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

res.tmg.sess_pic       = sess_pic;
res.tmg.t0             = t0;
res.tmg.end_pic        = localiser_outro;

% -------------------------------------------------------------------------
% Save data
if ~testing_mode
    
    save(fullfile(res_dir,code),'res')

    copyfile(fullfile(task_dir,[code '.log']),fullfile(res_dir,[code '.log']))
    delete(fullfile(task_dir,[code '.log']))
    
end

end
% -------------------------------------------------------------------------


%% Resting after localiser
if do_rest
    
if testing_mode
    restT = 3000; % 3 seconds
else
%     restT = 300000; % 5 minutes
    restT = 240000; % 4 minutes
end
    
% -------------------------------------------------------------------------
% triggers:
trig_start       = 197;  % start of experiment (resting)
trig_start_rest  = 198; % start of rest period
trig_end_rest    = 199; % end of rest period
% -------------------------------------------------------------------------
draw_RectPhotod(cols.black,x_pos_photodrect,y_pos_photodrect)

cgflip(cols.background);

draw_RectPhotod(cols.black,x_pos_photodrect,y_pos_photodrect)

cgtext('Now please take a rest for 4 minutes.',0,150)
cgtext('We will let you know when the time is up.',0,50)
cgtext('Please remain still throughout the whole time!!',0,-50)
cgtext('Next session starts...',0,-150)
rest_intro = cgflip(cols.background);

waitkeydown(inf);

if doscan, SendTrigger(trig_start); end % the start of TASK

%----------------------------------------------------------------------
% Fixation screen for resting period
cgpencol(cols.black)
cgtext('+',0,0)

%--------------------------------------------------------------------------
% turn rect at bottom white for 50ms
draw_RectPhotod(cols.white,x_pos_photodrect,y_pos_photodrect)

t_rest = cgflip(cols.background);

logstring(sprintf('Start of rest: %f', t_rest)); % ADDED LOGSTRING

waituntil(t_rest*1000+PhotoDRectT)
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% now black again
cgpencol(cols.black)
cgtext('+',0,0)

draw_RectPhotod(cols.black,x_pos_photodrect,y_pos_photodrect)

trect_black = cgflip(cols.background);

waituntil(trect_black*1000+restT-PhotoDRectT)
%--------------------------------------------------------------------------

if doscan, SendTrigger(trig_end_rest); end % End of Resting

cgpencol(cols.black)

draw_RectPhotod(cols.white,x_pos_photodrect,y_pos_photodrect)
cgpencol(cols.black)
cgtext('End of resting session',0,50)
cgtext('Thank you',0,-50)
resting_outro = cgflip(cols.background);
waituntil(resting_outro*1000+PhotoDRectT)

draw_RectPhotod(cols.black,x_pos_photodrect,y_pos_photodrect)
cgtext('End of resting session',0,50)
cgtext('Thank you',0,-50)
trect_black = cgflip(cols.background);

waitkeydown(4000);

logstring(sprintf('End of rest: %f', resting_outro)); % ADDED LOGSTRING

resting.tmg.rest_intro      = rest_intro;
resting.tmg.t_rest          = t_rest;
resting.tmg.resting_outro   = resting_outro;

% -------------------------------------------------------------------------
% Save data
if ~testing_mode
    save(fullfile(res_dir,code),'resting')

    copyfile(fullfile(task_dir,[code '.log']),fullfile(res_dir,[code '.log']))
    delete(fullfile(task_dir,[code '.log']))
end

end
% -------------------------------------------------------------------------

%% the end
stop_cogent
% -------------------------------------------------------------------------
