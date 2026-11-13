% Training stimulus construction

clear, close all

based    = 'C:\Users\pschwart\Desktop\StimConstrMEG';
% based    = 'D:\StimConstrMEG';
task_parent = fullfile(based,'Task');
task_dir = fullfile(based,'Task','Tetris_Training_MEG_Pictures');
data_dir = fullfile(based,'Data');
func_dir = 'C:\Users\pschwart\Desktop\Functions_Lego';

cd(task_dir)
addpath(based)
addpath(data_dir)
addpath(func_dir)

% addpath(genpath(fullfile('D:','Cogent')))

rand('state',sum(100*clock));

code = 'Decompose_Tetris_subj*';

% -------------------------------------------------------------------------
% subject details
snum = []; testing_mode = [];
% snum = 99; testing_mode = true;

if isempty(snum),           snum = input('Subject number: '); end
if isempty(testing_mode),   testing_mode = input('Testing? (1/0): '); end

res_dir = fullfile(task_dir,'Results',['s' num2str(snum)]);
mkdir(res_dir)

files = dir(fullfile(res_dir,code));
sess = length(files)+1;

code = ['Decompose_Tetris_subj' num2str(snum) '_sess' num2str(sess) '_' datestr(now,30)];

scanning_day = true;
% -------------------------------------------------------------------------

%% -------------------------------------------------------------------------
% other prelim stuff
prelim_stimconstr

replacement = 0;

n_grid = 6;

n_bricks   = 6;
max_blocks = 4;

length_bricks = [3 3 3 3];

% define the shape of the six stimuli
starting_point = 18;
form_element{1}  = [starting_point starting_point-1 starting_point+6-1];
form_element{2}  = [starting_point starting_point+6 starting_point+6-1];
form_element{3}  = [starting_point starting_point-1 starting_point-2];
form_element{4}  = [starting_point starting_point+6 starting_point+6+6];

pay = 0.05; % max win per session = n_trials*pay

select_max_time = 6000;
iti             = 1000;
choiceT         = 6000;

config_display(1, 5, [0 0 0], [0 0 0], 'Helvetica', 30, 4, 0);
% config_display(0, 4, [0 0 0], [0 0 0], 'Helvetica', 30, 4, 0);
config_keyboard (100, 5, 'exclusive');
% -------------------------------------------------------------------------

%% -------------------------------------------------------------------------
% make trials

n_trials  = 70;

n_bricks = size(form_element,2);

screen_position_element = [ 0   0 -350 350]; 
screen_position_options = [-150 0  0   150 150 0 0 -150 0 -350]; 

q_type = [ones(1,n_trials/2) ones(1,n_trials/2)*2];
q_type = q_type(randperm(length(q_type)))';

keylist = [95 97 98 100 71]; % up, left, right, down or space

% make sure stims will not be sampled from the ones used in MEG:
load('basic_3FORMs_testGraph2_unique_good_rightorder')

req_form_no = nan(size(basic_3FORMs_unique_rightorder,3),9);

for idx_stim_med = 1:size(req_form_no,1)
    req_form_no(idx_stim_med,:) = find(basic_3FORMs_unique_rightorder(:,:,idx_stim_med));
end
% -------------------------------------------------------------------------

%% ------------------------------------------------------------------------
% start experiment

time_exp = (select_max_time/1000 + choiceT/1000 + iti/1000) * n_trials *1/60;
fprintf('expected time experiment: %f minutes.\n',time_exp)

if testing_mode, n_trials   = 2; end

start_cogent

cgloadbmp(99,fullfile(task_parent,'Wrong.bmp'));
cgloadbmp(100,fullfile(task_parent,'Correct.bmp'));

cgloadbmp(1,fullfile(task_parent,'Brick.bmp'));
cgloadbmp(2,fullfile(task_parent,'Steel.bmp'));
cgloadbmp(3,fullfile(task_parent,'Wood.bmp'));
cgloadbmp(4,fullfile(task_parent,'Concrete.bmp'));

cgflip(cols.background);
cgtext('Any key to start',0,0)
time_start = cgflip(cols.background);

readkeys
waitkeydown(inf);

duration_experiment = tic;

if scanning_day
%     n_trials = 15;
    n_trials = 25;
end

for trial = 1:n_trials

starting_point = n_grid:n_grid:n_grid^2; starting_point = starting_point(randi(length(starting_point)-2)+1);

stim_fine = false;

while ~stim_fine

    [REQUIRED_FORM, required_form, blocks, starting_point] = mk_required_form_NEW(n_grid,max_blocks,starting_point,form_element);

    % [solutions, SOLUTIONS_BUILT, n_solutions] = mk_solutions_MinNumberBlocks_FourCutOff(required_form,length_bricks,form_element,n_grid)

    SOLUTIONS = zeros(n_grid);

    required_form_blocks = [];

    for idx_block=1:length(blocks)
        required_form_blocks = [required_form_blocks repmat(blocks(idx_block),1,length_bricks(blocks(idx_block)))];
    end

    SOLUTIONS(required_form) = required_form_blocks;
    SOLUTIONS = mk_recentre(SOLUTIONS);

    stim_fine = test_unique_relations(SOLUTIONS,blocks);
    
    if length(find(mk_recentre(REQUIRED_FORM))')==size(req_form_no,2)
        if ismember(find(mk_recentre(REQUIRED_FORM))',req_form_no,'rows')
            stim_fine = false;
        end
    end

end

correct = false;

selected = [];

cgflip(cols.background);
draw_grid, draw_options_new_decompose
time_stims = cgflip(cols.background);
waituntil(time + select_max_time)
%% probe plan

if q_type(trial)==1 % suggestion in possible solution
    target    = randsample(blocks,1);
    q_element = randsample(repmat(setdiff(blocks,target),1,2),1);    
elseif q_type(trial)==2 % suggestion not in possible solution
    target    = randi(n_bricks);
    if length(blocks)<3
        q_element = randsample(repmat(setdiff([1:n_bricks],[target blocks]),1,2),1);
    else
%         q_element = randsample(repmat(setdiff(blocks,target),1,2),1);
        q_element = randsample(repmat(setdiff([1:n_bricks],target),1,2),1);
    end
end

key = [];

colours_text = repmat(cols.black,5,1);

cgpencol(cols.greydark)
draw_options_similarity_local_new_decompose
draw_options_text

cgpencol(cols.black)

cgflip(cols.background);
      
clearkeys
readkeys
tic
% [key, t, n] = waitkeydown(inf,keylist);
[key, t, n] = waitkeydown(choiceT,keylist);

% up, left, right, down or space
if key == keylist(1) 
    colours_text(1,:) = cols.yellow;
elseif key == keylist(2) 
    colours_text(2,:) = cols.yellow;
elseif key == keylist(3) 
    colours_text(3,:) = cols.yellow;
elseif key == keylist(4)
    colours_text(4,:) = cols.yellow;
elseif key == keylist(5)
    colours_text(5,:) = cols.yellow;
end

draw_options_similarity_local_new_decompose
draw_options_text
tchoice = cgflip(cols.background);
    
[has_connections, how_many, which_neigh, which_rel] = find_connections(SOLUTIONS,target);

if has_connections == 0 || ~ismember(q_element,which_neigh) % does q-element go left of target element?
    pred_choice(trial) = keylist(5);
%     colours_text(5,:)  = cols.green2;
else
    idx_q = find(q_element==which_neigh); % 1==left, 2==ontop, 3==right, 4==below
    if which_rel(idx_q) == 1
        pred_choice(trial) = keylist(2);
%         colours_text(2,:)  = cols.green2;
    elseif which_rel(idx_q) == 2
        pred_choice(trial) = keylist(1);
%         colours_text(1,:)  = cols.green2;
    elseif which_rel(idx_q) == 3
        pred_choice(trial) = keylist(3);
%         colours_text(3,:)  = cols.green2;
    elseif which_rel(idx_q) == 4
        pred_choice(trial) = keylist(4);
%         colours_text(4,:)  = cols.green2;
    end
    
end

rt = toc;

waituntil(time + choiceT-(1000*rt))


%% check if correct
if ~isempty(key) && key(1)==pred_choice(trial)
    correct = true;
end

draw_options_similarity_local_new_decompose
draw_options_text
if correct
    cgdrawsprite(100,350,0)
else
    cgdrawsprite(99,350,0)
end

toutcome = cgflip(cols.background);

waituntil(time + iti)

form = zeros(max_blocks*5,1); form(1:length(required_form)) = required_form;
res_train.required_form(:,:,trial) = form;

res_train.REQUIRED_FORM(:,:,trial)    = REQUIRED_FORM;

res_train.SOLUTIONS(:,:,trial)        = SOLUTIONS;

res_train.pred_choice(trial)        = pred_choice(trial);

res_train.blocks(trial,:) = [blocks zeros(1,4-length(blocks))]; % which elements is compound based on

res_train.starting_point(trial,1) = starting_point;

res_train.correct(trial,1) = correct;

clearkeys;

end

duration_experiment = toc(duration_experiment);
fprintf('actual time experiment: %f seconds.\n',duration_experiment)

win = sum(res_train.correct)*pay; % every correct answer is worth 3p, plus bonus of 3p if in half of selection time

res_train.win = win;

cgpencol(cols.black)
cgtext(sprintf('End of Session'),0,100)
cgtext(sprintf('You have won £%g.',win),0,-100)
t_end = cgflip(cols.background);

waituntil(t_end*1000 + 4000)

stop_cogent

% -------------------------------------------------------------------------

fprintf('Win: £%f\n',win)

% -------------------------------------------------------------------------
% Save data
if ~testing_mode
    save(fullfile(res_dir,code),'res_train')
end
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% Save data
fprintf('Proportion correct: %f\n',mean(res_train.correct))

idx_trials_noSpace = res_train.pred_choice~=71;
fprintf('Proportion correct connect: %f\n',mean(res_train.correct(idx_trials_noSpace)))

idx_trials_2blocks = res_train.blocks(:,3)==0;
fprintf('Proportion correct 2 blocks: %f\n',mean(res_train.correct(idx_trials_2blocks)))

idx_trials_3blocks = (res_train.blocks(:,3)~=0&res_train.blocks(:,4)==0);
fprintf('Proportion correct 3 blocks: %f\n',mean(res_train.correct(idx_trials_3blocks)))

idx_trials_4blocks = res_train.blocks(:,4)~=0;
fprintf('Proportion correct 4 blocks: %f\n',mean(res_train.correct(idx_trials_4blocks)))
% -------------------------------------------------------------------------

