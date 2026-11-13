% extend object by next building block
% input:
% n_grid = size of grid
% pattern = current object
% form_block = cell containing forms of basic building blocks
% next_element = which element as specified in form_block should extend
% current object
% 
% output:
% pattern contains new objects, each row is a possible extension

function pattern = mk_extension_SIMALL(n_grid,pattern,form_block,next_element)

temp = [];

top_row    = linspace(1,n_grid*(n_grid-1)+1,n_grid);
bottom_row = linspace(n_grid,n_grid^2,n_grid);

left_colum  = 1:n_grid;
right_colum = n_grid*(n_grid-1)+1:n_grid^2;

for i=1:size(pattern,1)
    
    start = pattern(i,:);
    
    % determine adjacent points to current pattern:
    x_neg = start-n_grid;
    x_pos = start+n_grid;
    
    y_pos = start-1;
    y_pos = y_pos(~ismember(y_pos,bottom_row)); % don't cross horizontal border
    
    y_neg = start+1;
    y_neg = y_neg(~ismember(y_neg,top_row)); % don't cross horizontal border
    
    next_points = unique([x_neg x_pos y_pos y_neg]);
    
    next_points = next_points(~ismember(next_points,start));
    next_points = next_points(ismember(next_points,1:n_grid^2));
    
    % determine x/y translations of next_element to make it fit an adjacent point
    translations = [];

    for idx_size_nextel=1:length(form_block{next_element})
        translations = [translations next_points-form_block{next_element}(idx_size_nextel)];
    end
    
    % now see if this creates a reasonable new object
    for idx_transl=1:length(translations)
         
        if isempty(intersect(start,form_block{next_element}+translations(idx_transl))) && ...           % No intersection between form 1 and 2
           ~isempty(intersect(form_block{next_element}+translations(idx_transl),next_points)) && ...    % New form intersects with some adjacent point
            (isempty(intersect(form_block{next_element}+translations(idx_transl),top_row)) || ... 
             isempty(intersect(form_block{next_element}+translations(idx_transl),bottom_row))) && ...    % make sure new element does not flip around x-axis
            (isempty(intersect(form_block{next_element}+translations(idx_transl),left_colum)) || ...
            isempty(intersect(form_block{next_element}+translations(idx_transl),right_colum)))          % make sure new element does not flip around y-axis
            
            new_thing = [start form_block{next_element}+translations(idx_transl)];
            
            if length(intersect(new_thing,1:n_grid^2))==length(new_thing)                       % make sure new thing is in grid
                
                TEMP = zeros(n_grid); 
                TEMP(new_thing) = 1; 
                [row, col] = find(TEMP);
                
                if max(row)-min(row) < n_grid && max(col)-min(col) < n_grid % check if size of pattern exceeds actual grid size (i.e. 6);

                    temp = [temp; new_thing];

                end
            
            end
        end
    end

    temp = unique(temp,'rows');

end


pattern = temp;

end