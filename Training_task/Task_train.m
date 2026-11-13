% Training stimulus construction for the localiser
% This training is unbiased - no hierarchical bricks, and inherent
% structure/covariance

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

code = 'Tetris_subj*';

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

code = ['Train_Tetris_subj' num2str(snum) '_sess' num2str(sess) '_' datestr(now,30)];
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% other prelim stuff
prelim_stimconstr

replacement = 0;

n_grid = 6;

length_bricks = [3 3 3 3 3 3];

% define the shape of the six stimuli
starting_point = 6;
form_element{1}  = [starting_point starting_point-1 starting_point+6-1];
form_element{2}  = [starting_point starting_point+6 starting_point+6-1];
form_element{3}  = [starting_point starting_point-1 starting_point-2];
form_element{4}  = [starting_point starting_point+6 starting_point+6+6];

n_bricks   = length(form_element);

max_blocks = 4;

% n_trials  = 50;
n_trials  = 25;
% n_trials  = 15;

config_display(1, 5, [0 0 0], [0 0 0], 'Helvetica', 30, 4, 0);
% config_display(0, 4, [0 0 0], [0 0 0], 'Helvetica', 30, 4, 0);
config_keyboard (100, 5, 'exclusive');
% -------------------------------------------------------------------------

%% ------------------------------------------------------------------------
% start experiment
if testing_mode, n_trials   = 2; end

start_cogent

% load outcome pictures
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


%% make sure stims will not be sampled from the ones used in MEG:
load('basic_3FORMs_testGraph2_unique_good_rightorder')

req_form_no = nan(size(basic_3FORMs_unique_rightorder,3),9);

for idx_stim_med = 1:size(req_form_no,1)
    req_form_no(idx_stim_med,:) = find(basic_3FORMs_unique_rightorder(:,:,idx_stim_med));
end


%% start
for trial = 1:n_trials

% create random starting point    
starting_point = n_grid:n_grid:n_grid^2; starting_point = starting_point(randi(length(starting_point)-2)+1);

% create a stimulus that will not be used in MEG
stim_no  = true;
while stim_no
    
    [REQUIRED_FORM, required_form, blocks, starting_point] = mk_required_form_NEW(n_grid,max_blocks,starting_point,form_element);
    
    if length(find(mk_recentre(REQUIRED_FORM))')==size(req_form_no,2)
        if ~ismember(find(mk_recentre(REQUIRED_FORM))',req_form_no,'rows')
            stim_no = false;
        end
    end
    
end

ACTUAL_FORM = zeros(size(REQUIRED_FORM));
INFO_FORM   = zeros(size(REQUIRED_FORM));

stop     = 0;
skip     = 0;
give_up  = 0;
choice   = 0;
selected = [];

which_move = 0;
show_col   = 0;

wrong = 0; correct = 0;
bonus = 0;

building_time  = 0;
selection_time = 0;

cgflip(cols.background);
draw_grid
draw_options
cgflip(cols.background);

%% make selection
tic
while stop==0
    readkeys
    [key, t, n] = getkeydown;
    
    if key==97 % left
        if choice~=1
            choice = choice - 1;
        else
            choice = length(pos_cursor);
        end
        draw_grid,draw_options,draw_selection
        cgflip(cols.background);
    elseif key==98 % right
        if choice~=length(pos_cursor) 
            choice = choice + 1; 
        else
            choice = 1;
        end
        draw_grid,draw_options,draw_selection
        cgflip(cols.background);
    elseif key==59 % enter
        if ~replacement
            if ~ismember(choice,selected)
                selected = [selected, choice];
            end
        else
            selected = [selected, choice];
        end
        draw_grid,draw_options,draw_selection
        cgflip(cols.background);
    elseif key==55 % BackSpace, clear selection
        selected = [];
        draw_grid,draw_options,draw_selection
        cgflip(cols.background);
    elseif key==71 % space = confirm selection if not empty
        if ~isempty(selected), stop = 1; end % stop only if selection isn't empty
    elseif key==60 % left control
        stop = 1;
        skip = 1;
    elseif key==52 % Esc
        stop = 1;
        stop_cogent
    end

end
selection_time = toc;

if ~skip
%% show colours
show_col       = 1;
colours_blocks = randperm(length(cols.blocks)); colours_blocks = colours_blocks(1:length(selected));

draw_grid,draw_options,draw_selection
cgflip(cols.background);

%% move around

moved            = zeros(length(selected),1);
pos_moved        = zeros(length(selected),4);
pos_moved_assess = [];
moved_order      = [];
pos_colours      = zeros(length(selected),3);


tic
while length(find(moved)) < length(selected) && give_up == 0
    
start_over     = 0;
 
avail_for_move = find(~moved);
    
if length(avail_for_move) == 1
    which_move = randsample([avail_for_move avail_for_move],1);        % which_move is an index
%     which_move = randsample([avail_for_move avail_for_move]);        % which_move is an index
else
    which_move = randsample(avail_for_move,1);                         % which_move is an index
%     which_move = randsample(avail_for_move);                         % which_move is an index
end

x_new = x_pos_all(which_move,1);
y_new = x_pos_all(which_move,2);

selected_for_move = 0;

draw_grid,draw_options,draw_moved_selection
cgflip(cols.background);

while selected_for_move == 0 && give_up == 0  && start_over == 0
    readkeys
    [key, t, n] = getkeydown;
    
    if key==97 % left
        if which_move~=min(avail_for_move)
            which_move = avail_for_move(find(avail_for_move==which_move)-1);
        end
        x_new = x_pos_all(which_move,1);
        y_new = x_pos_all(which_move,2);
        draw_grid,draw_options,draw_moved_selection
        cgflip(cols.background);
    elseif key==98 % right
        if which_move~=max(avail_for_move)
            which_move = avail_for_move(find(avail_for_move==which_move)+1);
        end
        x_new = x_pos_all(which_move,1);
        y_new = x_pos_all(which_move,2);
        draw_grid,draw_options,draw_moved_selection
        cgflip(cols.background);
    elseif key==55 % BackSpace, clear moved items
        moved            = zeros(length(selected),1);
        pos_moved        = zeros(length(selected),4);
        pos_moved_assess = [];
        draw_grid,draw_options,draw_moved_selection
        cgflip(cols.background);
        start_over = 1;
    elseif key==59 % enter
        selected_for_move = 1;
    elseif key==60 % left ctrl
        give_up = 1;
    end
end

move_on = 0;

x_new = x_pos_all(which_move,1);
y_new = x_pos_all(which_move,2);

draw_grid,draw_options,draw_moved_selection
cgflip(cols.background);

while move_on == 0 && give_up == 0 && start_over == 0
    readkeys
    [key, t, n] = getkeydown;
    
    if key==95 % up
        [x_new,y_new] = mk_new_pos(x_new,y_new,95);
        draw_grid,draw_options,draw_moved_selection
        cgflip(cols.background);
    elseif key==97 % left
        [x_new,y_new] = mk_new_pos(x_new,y_new,97);
        draw_grid,draw_options,draw_moved_selection
        cgflip(cols.background);
    elseif key==98 % right
        [x_new,y_new] = mk_new_pos(x_new,y_new,98);
        draw_grid,draw_options,draw_moved_selection
        cgflip(cols.background);
    elseif key==100 % down
        [x_new,y_new] = mk_new_pos(x_new,y_new,100);
        draw_grid,draw_options,draw_moved_selection
        cgflip(cols.background);
    elseif key==59 % enter
        move_on      = 1;
        moved(which_move)          = which_move;
        if selected(which_move) == 1
           pos_moved(which_move,:) = [x_new y_new xy_blocks(selected(which_move),1) xy_blocks(selected(which_move),2)];
           pos_moved_assess        = [pos_moved_assess; x_new y_new+25 xy_blocks(selected(which_move),1) xy_blocks(selected(which_move),2)];
           pos_moved_assess        = [pos_moved_assess; x_new-25 y_new-25 50 50];
           moved_order             = [moved_order; selected(which_move); selected(which_move)];
        elseif selected(which_move) == 2
           pos_moved(which_move,:) = [x_new y_new xy_blocks(selected(which_move),1) xy_blocks(selected(which_move),2)];
           pos_moved_assess        = [pos_moved_assess; x_new y_new-25 xy_blocks(selected(which_move),1) xy_blocks(selected(which_move),2)];
           pos_moved_assess        = [pos_moved_assess; x_new+25 y_new+25 50 50];
           moved_order             = [moved_order; selected(which_move); selected(which_move)];
        else
           pos_moved(which_move,:) = [x_new y_new xy_blocks(selected(which_move),1) xy_blocks(selected(which_move),2)];
           pos_moved_assess        = [pos_moved_assess; x_new y_new xy_blocks(selected(which_move),1) xy_blocks(selected(which_move),2)];
           moved_order             = [moved_order; selected(which_move)];
        end
    elseif key==55 % BackSpace, clear moved items
        moved            = zeros(length(selected),1);
        pos_moved        = zeros(length(selected),4);
        pos_moved_assess = [];
        moved_order      = [];
        draw_grid,draw_options,draw_moved_selection
        cgflip(cols.background)
        start_over = 1;
    elseif key==60 % left ctrl
        give_up = 1;
    end
end

end
building_time = toc;

% end

%% check if correct
if ~give_up
    [~,idx] = sort(pos_moved_assess(:,1)); % sort just the first column
    sorted_pos_moved_x = pos_moved_assess(idx,:);

    [~,idy] = sort(pos_moved_assess(:,2)); % sort just the first column
    sorted_pos_moved_y = pos_moved_assess(idy,:);

    length_built = sum(length_bricks(selected));
    
    [ACTUAL_FORM, INFO_FORM, violation] = mk_actual_form(pos_moved_assess,ACTUAL_FORM,pos_colours,REQUIRED_FORM,length_built,moved_order);
    
end

if isequal(ACTUAL_FORM(:,sum(ACTUAL_FORM)~=0),REQUIRED_FORM(:,sum(REQUIRED_FORM)~=0)) && violation==0 && give_up == 0 && sum(length_bricks(selected))==length(required_form)
    draw_grid,draw_options,draw_moved_selection
    cgdrawsprite(100,200,0)
    toutcome = cgflip(cols.background);
    correct = 1;
else
    wrong = 1;
    draw_grid,draw_options,draw_moved_selection
    cgdrawsprite(99,200,0)
    toutcome = cgflip(cols.background);
end

else
    draw_grid,draw_options
    cgpencol(cols.black),cgtext('Trial skipped.',0,0)
    toutcome = cgflip(cols.background);

end

% waituntil(toutcome*1000 + 1000)
wait(1000)
% waitkeydown(inf)

form = zeros(max_blocks*4,1); form(1:length(find(ACTUAL_FORM))) = find(ACTUAL_FORM);
res_train.actual_form(:,:,trial) = form;

if sum(size(ACTUAL_FORM)) > n_grid*2
    ACTUAL_FORM = NaN(size(REQUIRED_FORM));
    INFO_FORM = NaN(size(REQUIRED_FORM));
end

res_train.ACTUAL_FORM(:,:,trial)      = ACTUAL_FORM;

res_train.INFO_FORM(:,:,trial)        = INFO_FORM;

form = zeros(max_blocks*4,1); form(1:length(required_form)) = required_form;
res_train.required_form(:,:,trial) = form;

res_train.REQUIRED_FORM(:,:,trial)    = REQUIRED_FORM;

bricks_used = zeros(max_blocks,1); bricks_used(1:length(blocks)) = blocks; % bricks used by algorithm to build required form
res_train.blocks_used(trial,:)        = bricks_used;

res_train.starting_point(trial) = starting_point;

bricks_selected = zeros(n_bricks,1); bricks_selected(1:length(selected)) = selected;
res_train.bricks_selected(trial,:) = bricks_selected;

colours_selected = zeros(n_bricks,1); if ~skip, colours_selected(1:length(colours_blocks)) = colours_blocks; end
res_train.colours_selected(trial,:) = colours_selected;

res_train.correct(trial) = correct;

res_train.give_up(trial) = give_up;

res_train.skip(trial) = skip;

if ~skip && ~give_up
    res_train.moved_order{trial} = moved_order;
    res_train.pos_moved_assess{trial} = pos_moved_assess;
else
    res_train.moved_order{trial} = [];
    res_train.pos_moved_assess{trial} = [];
end

res_train.selection_time(trial) = selection_time;

res_train.building_time(trial) = building_time;

clearkeys;

end

stop_cogent
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% Save data
if ~testing_mode
    save(fullfile(res_dir,code),'res_train')
end
% -------------------------------------------------------------------------