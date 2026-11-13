
function [STIMs,bricks,order,is_correct,stim_catch,question_catch,SOLUTIONS_BUILT,relation_catch] = mk_stims_sparse(n_grid) 

if nargin < 1
    n_grid = 6;
end

load('basic_3FORMs_sparse_unique_good_rightorder')
% load('basic_3FORMs_sparse2_unique_good_rightorder')
% load('basic_3FORMs_sparse3_unique_good_rightorder')
% load('basic_3FORMs_sparse4_unique_good_rightorder')

% make stims
n_rep = 4;
stim_order = repmat([1:size(basic_3FORMs_unique_rightorder,3)]',n_rep,1);
basic_3FORMs = basic_3FORMs_unique_rightorder(:,:,stim_order);


for idx_stim=1:size(basic_3FORMs,3)
    
    stim = basic_3FORMs(:,:,idx_stim);
    stim(stim~=0) = 1;
    STIMs(:,:,idx_stim) = stim;
    
    bricks(idx_stim,:) = unique(basic_3FORMs(:,:,idx_stim));
    
end


bricks(:,1) = [];

% sorted such that element in middle is actually middle element and first relation is besideness:
for idx_stim=1:size(basic_3FORMs,3)
    
    PART1 = basic_3FORMs(:,:,idx_stim);
    PART1(PART1==bricks(idx_stim,1)) = 0;
    
    PART2 = basic_3FORMs(:,:,idx_stim);
    PART2(PART2==bricks(idx_stim,2)) = 0;
    
    PART3 = basic_3FORMs(:,:,idx_stim);
    PART3(PART3==bricks(idx_stim,3)) = 0;
      
    % order bricks such that first two are connected via besideness and
    % second two via ontopess, and middle column is the stimulus in middle
    bricks_order = [mk_ontopness(PART3)+mk_ontopness(PART2)  mk_ontopness(PART1)+mk_ontopness(PART3)   mk_ontopness(PART1)+mk_ontopness(PART2);
                    mk_besideness(PART3)+mk_besideness(PART2) mk_besideness(PART1)+mk_besideness(PART3) mk_besideness(PART1)+mk_besideness(PART2)];
                
    bricks_order = [find(~bricks_order(1,:)&bricks_order(2,:)) find(bricks_order(1,:)&bricks_order(2,:)) find(bricks_order(1,:)&~bricks_order(2,:))];
    
    bricks(idx_stim,:) = bricks(idx_stim,bricks_order);
    
end       
      
n_trials = size(bricks,1);

SOLUTIONS_BUILT = basic_3FORMs;

is_correct   = [zeros(n_trials/2,1); ones(n_trials/2,1)];
is_correct   = is_correct(randperm(length(is_correct)));

question_catch = zeros(n_trials,1);

% relation_catch = zeros(n_trials,1);
relation_catch = [ones(n_trials/4,1); ones(n_trials/4,1)*2; ones(n_trials/4,1)*3; ones(n_trials/4,1)*4];
relation_catch = relation_catch(randperm(length(relation_catch)));


%% plot stims:
map = [1 1 1; 
       linspace(0,1,10-1)' ones(10-1,1)*0.5    linspace(1,0,10-1)'];

figure
for idx_stim=1:length(basic_3FORMs_unique_rightorder)
   subplot(6,9,idx_stim)
   imagesc(basic_3FORMs_unique_rightorder(:,:,idx_stim)+1,[1 5])
   colormap(map)
end

%% make trials new:
% order of relations: {' "To the left" ' ' "On top" ' ' "To the right" ' ' "Below" '}; 
% i.e. 1==left, 2==ontop, 3==right, 4==below

stim_catch     = zeros(n_trials,2);

for idx_trial=1:n_trials
    
   if relation_catch(idx_trial)==1 || relation_catch(idx_trial)==3 % if relation is left or right
       
       stim_catch(idx_trial,:) = bricks(idx_trial,1:2); % pick the bricks that are connected via besideness
       
   elseif relation_catch(idx_trial)==2 || relation_catch(idx_trial)==4 % if relation is pn top or below
       
       stim_catch(idx_trial,:) = bricks(idx_trial,2:3); % pick the bricks that are connected via ontopness
       
   end
   
   % now check which one is right and which one is left - stim_catch(1)
   % will be top left corner; i.e. question will be "how does stim_catch(1)
   % connect to stim_catch(2)?"
   SOL_PART = zeros(n_grid);
   SOL_PART(SOLUTIONS_BUILT(:,:,idx_trial)==stim_catch(idx_trial,1))=stim_catch(idx_trial,1);
   SOL_PART(SOLUTIONS_BUILT(:,:,idx_trial)==stim_catch(idx_trial,2))=stim_catch(idx_trial,2);
    
   
   [~, ~, ~, which_rel] = find_connections(SOL_PART,stim_catch(idx_trial,1));  % NEIGHBOUR is 1==left, 2==ontop, 3==right, 4==below
   
   % reshuffle to make sure correct element relation is evoked if necessary
   if which_rel==relation_catch(idx_trial) % if actually neighbour has desired relational properties
       stim_catch(idx_trial,:) = [stim_catch(idx_trial,2) stim_catch(idx_trial,1)]; % swap question
   end
   
    if is_correct(idx_trial)==0
        avail_rel = setdiff(1:4,relation_catch(idx_trial));
        question_catch(idx_trial) = randsample(avail_rel,1);
    elseif is_correct(idx_trial)==1
        question_catch(idx_trial) = relation_catch(idx_trial);
    end   
    
end

%% check stims:
% map = [1 1 1; 
%        linspace(0,1,10-1)' ones(10-1,1)*0.5    linspace(1,0,10-1)'];
% 
% % irrelevent element will be blue, evoked relation is relation of orange
% % stim to brown stim:
% figure,set(gcf,'color','white')
% for idx_stim=1:length(basic_3FORMs_unique_rightorder)
%    subplot(6,12,idx_stim)
%    stim_test = basic_3FORMs_unique_rightorder(:,:,idx_stim);
% %    stim_test(stim_test==stim_catch(idx_stim,1)) = 8;
% %    stim_test(stim_test==stim_catch(idx_stim,2)) = 5;
% %    stim_test(stim_test<5&stim_test>0) = 1;
%    imagesc(stim_test+1,[1 8])
%    yticks([])
%    xticks([])
%    colormap(map)
% end

%% shuffle trials
order = randperm(size(STIMs,3));

STIMs           = STIMs(:,:,order);
SOLUTIONS_BUILT = SOLUTIONS_BUILT(:,:,order);
bricks          = bricks(order,:);
stim_catch      = stim_catch(order,:);
question_catch  = question_catch(order,:);
relation_catch  = relation_catch(order,:);
is_correct      = is_correct(order);

% assign back stim identity of added stims because order will serve as
% trigger for object identity later
order = stim_order(order);

end