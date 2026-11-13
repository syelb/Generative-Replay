% draw selected items


xy_blocks = [100  50;
             100  50;
             50   150;
             150  50];

% startpos_selected_items = [-200 -25];
startpos_selected_items = [-100 -25];
x_pos = startpos_selected_items;
x_pos_all = zeros(length(selected),2);

cgpencol(cols.black)
for selected_blocks = 1:length(selected)
    
    if show_col==0
        cgpencol(cols.black)
    else
%         cgpencol(cols.blocks(colours_blocks(selected_blocks),:))
        cgpencol([0.6 0.6 0.6])
    end
    
    if selected_blocks~=which_move
        if selected(selected_blocks) == 1
%            cgrect(x_pos(1)+xy_blocks(selected(selected_blocks),1)/2,startpos_selected_items(2)+25,xy_blocks(selected(selected_blocks),1),xy_blocks(selected(selected_blocks),2)); 
%            cgrect(x_pos(1)+xy_blocks(selected(selected_blocks),1)/2-25,startpos_selected_items(2)-25,50,50)
           cgdrawsprite(selected(selected_blocks),x_pos(1)+xy_blocks(selected(selected_blocks),1)/2-25,startpos_selected_items(2)+25,50,50)
           cgdrawsprite(selected(selected_blocks),x_pos(1)+xy_blocks(selected(selected_blocks),1)/2+25,startpos_selected_items(2)+25,50,50)
           cgdrawsprite(selected(selected_blocks),x_pos(1)+xy_blocks(selected(selected_blocks),1)/2-25,startpos_selected_items(2)-25,50,50)
        elseif selected(selected_blocks) == 2
%             cgrect(x_pos(1)+xy_blocks(selected(selected_blocks),1)/2,startpos_selected_items(2)-25,xy_blocks(selected(selected_blocks),1),xy_blocks(selected(selected_blocks),2));
            cgdrawsprite(selected(selected_blocks),x_pos(1)+xy_blocks(selected(selected_blocks),1)/2-25,startpos_selected_items(2)-25,50,50)
            cgdrawsprite(selected(selected_blocks),x_pos(1)+xy_blocks(selected(selected_blocks),1)/2+25,startpos_selected_items(2)-25,50,50)
%             cgrect(x_pos(1)+xy_blocks(selected(selected_blocks),1)/2+25,startpos_selected_items(2)+25,50,50)
            cgdrawsprite(selected(selected_blocks),x_pos(1)+xy_blocks(selected(selected_blocks),1)/2+25,startpos_selected_items(2)+25,50,50)
        else
%             cgrect(x_pos(1)+xy_blocks(selected(selected_blocks),1)/2,startpos_selected_items(2),xy_blocks(selected(selected_blocks),1),xy_blocks(selected(selected_blocks),2));
            cgdrawsprite(selected(selected_blocks),x_pos(1)+xy_blocks(selected(selected_blocks),1)/2,startpos_selected_items(2),xy_blocks(selected(selected_blocks),1),xy_blocks(selected(selected_blocks),2))
        end
        x_pos_all(selected_blocks,1) = x_pos(1)+xy_blocks(selected(selected_blocks),1)/2;
        x_pos_all(selected_blocks,2) = startpos_selected_items(2);
        
        x_pos(1) = x_pos(1) + xy_blocks(selected(selected_blocks),1) + 25;
    else
        cgrect(x_new,y_new,xy_blocks(selected(selected_blocks),1),xy_blocks(selected(selected_blocks),2));
    end
end