

function [all_relations_unique] = test_unique_relations(SOLUTIONS,blocks)

all_relations_unique = true;

two_el_comb = nchoosek(blocks,2);

for idx_two_el = 1:size(two_el_comb,1)
    
    SOLUTIONS_temp = zeros(size(SOLUTIONS));
    
    SOLUTIONS_temp(find(SOLUTIONS==two_el_comb(idx_two_el,1))) = two_el_comb(idx_two_el,1);
    SOLUTIONS_temp(find(SOLUTIONS==two_el_comb(idx_two_el,2))) = two_el_comb(idx_two_el,2);
    
    if mk_ontopness(SOLUTIONS_temp) && mk_besideness(SOLUTIONS_temp)
        all_relations_unique = false;
    end
    
end


end