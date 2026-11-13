% This function creates extenstion of exisiting form based on individual
% bricks and ONE next element
% 
% INPUT
% n_grid          = size of grid (usually 6x6)
% form            = current form of object in vector code
% form_element    = shapes of possible next building blocks
% idx_next_elemtn = which of form_element shapes should extend current
% object
% 
% OUTPUT
% pattern = all possible extensions of current object by particular
% building block (in vector code) centered on lower left corner

function pattern = mk_pattern(n_grid,form,form_element,idx_next_element)

FORM       = zeros(n_grid);
FORM(form) = 1;

% if size(mk_crop(FORM),2)==1
%     x_translation = [0 6 12 18 24 30];
% elseif size(mk_crop(FORM),2)==2 
%     x_translation = [0 6 12 18 24];
% elseif size(mk_crop(FORM),2)==3
if size(mk_crop(FORM),2)<4
    x_translation = [0 18]; % don't need more, because next element is maximally 3 squares long!
elseif size(mk_crop(FORM),2)==4
    x_translation = [0 12];
elseif size(mk_crop(FORM),2)==5
    x_translation = [0 6];
else
    x_translation = [0];
end

% if size(mk_crop(FORM),1)==1
%     y_translation = [0 -1 -2 -3 -4 -5];
% elseif size(mk_crop(FORM),1)==2 
%     y_translation = [0 -1 -2 -3 -4];
% elseif size(mk_crop(FORM),1)==3
if size(mk_crop(FORM),1)<4
    y_translation = [0 -3];  % don't need more, because next element is maximally 3 squares high!
elseif size(mk_crop(FORM),1)==4
    y_translation = [0 -2];
elseif size(mk_crop(FORM),1)==5
    y_translation = [0 -1];
else
    y_translation = [0];
end

pattern = [];

for starting_point_x = x_translation

    for starting_point_y = y_translation

        pattern = [pattern; mk_extension_SIMALL(n_grid,form+starting_point_x+starting_point_y,form_element,idx_next_element)];

    end

end

pattern = mk_recentre_vector_code(pattern,n_grid);
pattern = unique(pattern,'rows','stable');


end