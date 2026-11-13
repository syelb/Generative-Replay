% Test if compound can be found in a given solution

function [x, which_solutions, noElements_solutions] = findReadyMadeinPattern(pattern,brick_compound,SOLUTIONS_BUILT_ALL,Solutions_ReadyMade)

x = zeros(size(brick_compound,2),1);

which_solutions      = [];
noElements_solutions = [];

form2 = find(pattern)';

for idx_brick_compound = 1:size(brick_compound,2)
    
    [jo, ~] = isin(brick_compound{idx_brick_compound},form2);
    
    if jo
        noElements_solutions = [];
        for ii = 1:size(SOLUTIONS_BUILT_ALL,3)
            noElements_solutions = [noElements_solutions sum(unique(SOLUTIONS_BUILT_ALL(:,:,ii))~=0)];
            if logical(findReadyMadeinPattern_slide(SOLUTIONS_BUILT_ALL(:,:,ii),Solutions_ReadyMade{idx_brick_compound}))
                x(idx_brick_compound) = x(idx_brick_compound) + 1;
                which_solutions = [which_solutions ii];
            end
        end
    end
    
end



end