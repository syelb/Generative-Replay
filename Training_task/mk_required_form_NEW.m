function [REQUIRED_FORM, required_form, blocks_used, starting_point] = mk_required_form_NEW(n_grid,max_blocks,starting_point,form_block)

n_stims = size(form_block,2);

% choose how many blocks and which
% blocks = randperm(n_stims); blocks = blocks(1:max_stims);
blocks = randperm(n_stims); blocks = blocks(1:randi(max_blocks-1)+1);

required_form = [form_block{blocks(1)}];

blocks_used = blocks(1);

while length(intersect(required_form,1:36))~=length(required_form) % if due to length of block out of right bound, move left
    required_form  = required_form - 6;
    starting_point = starting_point - 6;
end

%     find possible adjacent starting points, go through in random order to
%     see which one you can use
for i=2:length(blocks)
    
    % find possible adjacent starting points,
    starting_points = unique([required_form-6 required_form-1 required_form+6]);
    starting_points = starting_points(~ismember(starting_points,required_form)); 
    starting_points = starting_points(randperm(length(starting_points)));
    
    built = 0;
    for ii = 1:length(starting_points)
        if ~built
            next_block = form_block{blocks(i)}+starting_points(ii)-form_block{blocks(i)}(1);

            if length(intersect(next_block,1:36))==length(next_block) && isempty(intersect(next_block,required_form)) && length(intersect(next_block,[6 7]))~=2 && ...
                    length(intersect(next_block,[12 13]))~=2 && length(intersect(next_block,[18 19]))~=2 && length(intersect(next_block,[24 25]))~=2 && ...
                    length(intersect(next_block,[30 31]))~=2
                required_form = [required_form next_block];
                built = 1;
                
                blocks_used = [blocks_used blocks(i)];
                
            end
            
        end
        
    end
    
    
end

REQUIRED_FORM = zeros(n_grid,n_grid); REQUIRED_FORM(required_form) = 1;

end