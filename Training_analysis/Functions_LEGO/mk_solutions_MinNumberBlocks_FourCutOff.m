% find all possible solutions for a given form
% Input: form (in vector mode)

function [solutions, SOLUTIONS_BUILT, n_solutions] = mk_solutions_MinNumberBlocks_FourCutOff(required_form,length_bricks,form_element,n_grid)

SOLUTIONS_BUILT     = [];
idx_solutions_built = 1;

bricks = 1:length(length_bricks);

%% ------------------------------------------------------------------------
% find all possible solutions with the right length:
solutions_one = nchoosek(bricks,1);
solutions_one = solutions_one(sum(length_bricks(solutions_one)',2)==length(required_form),:);

solutions_two = nchoosek(bricks,2);
solutions_two = solutions_two(sum(length_bricks(solutions_two),2)==length(required_form),:);

solutions_three = nchoosek(bricks,3);
solutions_three = solutions_three(sum(length_bricks(solutions_three),2)==length(required_form),:);

solutions_four = nchoosek(bricks,4);
solutions_four = solutions_four(sum(length_bricks(solutions_four),2)==length(required_form),:);

% there are no solutions with 5 bricks or more

%% ------------------------------------------------------------------------
% See if these solutions actually work:

% -------------------------------------------------------------------------
% Solutions with 1 element:
works               = false(size(solutions_one,1),1);
suggestions_one_all = [];
good_order_one_all  = [];

for i = 1:size(solutions_one,1)
    [works(i), suggestions, good_order] = see_if_works(solutions_one(i,:),required_form,form_element,n_grid,length_bricks);
    if works(i)
        suggestions_one_all = [suggestions_one_all; suggestions];
        good_order_one_all  = [good_order_one_all; good_order];
    end
end

solutions_one = solutions_one(works,:);

for idx_sugg=1:size(suggestions_one_all,1)
    TEMP                                  = zeros(n_grid);
    TEMP(suggestions_one_all(idx_sugg,:)) = good_order_one_all(idx_sugg,:);
    
    SOLUTIONS_BUILT(:,:,idx_solutions_built) = TEMP;
    
    idx_solutions_built = idx_solutions_built + 1;
end

% -------------------------------------------------------------------------
% Solutions with 2 elements:
works               = false(size(solutions_two,1),1);
suggestions_two_all = [];
good_order_two_all  = [];

for i = 1:size(solutions_two,1)
    [works(i), suggestions, good_order]  = see_if_works(solutions_two(i,:),required_form,form_element,n_grid,length_bricks);
    if works(i)
        suggestions_two_all = [suggestions_two_all; suggestions];
        good_order_two_all  = [good_order_two_all; good_order];
    end
end

solutions_two = solutions_two(works,:);

for idx_sugg=1:size(suggestions_two_all,1)
    TEMP                                  = zeros(n_grid);
    TEMP(suggestions_two_all(idx_sugg,:)) = good_order_two_all(idx_sugg,:);
    
    SOLUTIONS_BUILT(:,:,idx_solutions_built) = TEMP;
    
    idx_solutions_built = idx_solutions_built + 1;
end

% -------------------------------------------------------------------------
% Solutions with 3 elements:
works                 = false(size(solutions_three,1),1);
suggestions_three_all = [];
good_order_three_all  = [];

for i = 1:size(solutions_three,1)
    [works(i), suggestions, good_order] = see_if_works(solutions_three(i,:),required_form,form_element,n_grid,length_bricks);
    if works(i)
        suggestions_three_all = [suggestions_three_all; suggestions];
        good_order_three_all  = [good_order_three_all; good_order];
    end
end

solutions_three = solutions_three(works,:);

for idx_sugg=1:size(suggestions_three_all,1)
    TEMP                                    = zeros(n_grid);
    TEMP(suggestions_three_all(idx_sugg,:)) = good_order_three_all(idx_sugg,:);
    
    SOLUTIONS_BUILT(:,:,idx_solutions_built) = TEMP;
    
    idx_solutions_built = idx_solutions_built + 1;
end

% -------------------------------------------------------------------------
% Solutions with 4 elements:    
works                = false(size(solutions_four,1),1);
suggestions_four_all = [];
good_order_four_all  = [];

for i = 1:size(solutions_four,1)
    [works(i), suggestions, good_order] = see_if_works(solutions_four(i,:),required_form,form_element,n_grid,length_bricks);
    if works(i)
        suggestions_four_all = [suggestions_four_all; suggestions];
        good_order_four_all  = [good_order_four_all; good_order];
    end
end

solutions_four = solutions_four(works,:);

for idx_sugg=1:size(suggestions_four_all,1)
    TEMP                                   = zeros(n_grid);
    TEMP(suggestions_four_all(idx_sugg,:)) = good_order_four_all(idx_sugg,:);
    
    SOLUTIONS_BUILT(:,:,idx_solutions_built) = TEMP;
    
    idx_solutions_built = idx_solutions_built + 1;
end

% -------------------------------------------------------------------------
solutions.one   = solutions_one;
solutions.two   = solutions_two;
solutions.three = solutions_three;
solutions.four  = solutions_four;

if isempty(SOLUTIONS_BUILT)
    n_solutions = 0;
else
    n_solutions = size(SOLUTIONS_BUILT,3);
end

end
