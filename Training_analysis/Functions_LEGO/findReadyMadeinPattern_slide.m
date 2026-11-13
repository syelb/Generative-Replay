% Test if compound can be found in a given solution
% With sliding window

function x = findReadyMadeinPattern_slide(Object_test,Solutions_ReadyMade)

if iscell(Solutions_ReadyMade)
    
    x = false(size(Solutions_ReadyMade,2),1);
    
    for compound = 1:size(Solutions_ReadyMade,2)
    
        works = false(size(Solutions_ReadyMade{compound},3),1);

        for solutions_compound = 1:size(Solutions_ReadyMade{compound},3)
            works(solutions_compound) = isin_slidingW(Solutions_ReadyMade{compound}(:,:,solutions_compound),Object_test);
        end

        if any(works)
            x(compound) = true;
        end
    
    end
    
else
    
    x = false;
    
    works = false(size(Solutions_ReadyMade,3),1);

    for solutions_compound = 1:size(Solutions_ReadyMade,3)
        works(solutions_compound) = isin_slidingW(Solutions_ReadyMade(:,:,solutions_compound),Object_test);
    end

    if any(works)
        x = true;
    end

end




end