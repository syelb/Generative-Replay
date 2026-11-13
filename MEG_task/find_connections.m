% This function finds whether a particular element within a FORM has
% neighbours, and if so how many and which stimuli
% Input:
% FORM is form in matrix code with solutions
% element is a non-zero entry of FORM

function [has_connections, how_many, which_neigh, which_rel] = find_connections(FORM,element)

has_connections = false;
how_many        = 0;
which_neigh     = [];
which_rel       = []; % 1==left, 2==ontop, 3==right, 4==below

[i,j] = ind2sub(size(FORM),find(FORM==element));

neighbours = [i+1 j; i-1 j; i j+1; i j-1];
relation_neighbours = [ones(length(i),1)*4; ones(length(i),1)*2; ones(length(i),1)*3; ones(length(i),1)*1]; % move below/ontop/right/left

idx_remove = any(neighbours==0|neighbours==7,2);
neighbours(idx_remove,:)          = [];
relation_neighbours(idx_remove,:) = [];

[neighbours, ia] = unique(neighbours,'rows','stable');
relation_neighbours = relation_neighbours(ia,:);

idx_remove = ismember(neighbours,[i j],'rows');
neighbours(idx_remove,:) = [];
relation_neighbours(idx_remove,:) = [];

if any(FORM(sub2ind(size(FORM),neighbours(:,1),neighbours(:,2)))~=0)
    has_connections = true;
    
    which_neigh = FORM(sub2ind(size(FORM),neighbours(:,1),neighbours(:,2)));
    
    which_rel   = relation_neighbours(which_neigh~=0);
    which_neigh = which_neigh(which_neigh~=0);
    
    how_many = length(which_neigh);
    
    which_output = unique([which_neigh which_rel],'rows','stable');

    which_neigh = which_output(:,1)';
    which_rel   = which_output(:,2)';    
end

end