% Recentre object based on vectorised position in nxn-grid

function pattern_out = mk_recentre_vector_code(pattern_in,n_grid)
% place in left bottom corner

pattern_out = zeros(size(pattern_in));



for idx_stim=1:size(pattern_in,1)
    
    STIM = zeros(n_grid);
    STIM(pattern_in(idx_stim,pattern_in(idx_stim,:)~=0)) = 1;
    STIM = mk_recentre(STIM);
    
    [~,idx_sort] = sort(pattern_in(idx_stim,pattern_in(idx_stim,:)~=0));
    
    pattern_out(idx_stim,:) = find(STIM)';
    pattern_out(idx_stim,idx_sort) = pattern_out(idx_stim,:); % preserve ordering of input pattern
end


end