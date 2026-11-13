% draw selected items


xy_blocks = [100  50;
             100  50;
             50   150;
             150  50];

startpos_selected_items = [-300 -25];

cgpencol(cols.black)
for selected_blocks = 1:length(selected)
    
    if show_col==0
        cgpencol(cols.black)
    else
%         cgpencol(cols.blocks(colours_blocks(selected_blocks),:))
        cgpencol([0.6 0.6 0.6])
    end
    
    if ismember(selected_blocks,moved)
%         cgpencol(cols.blocks(colours_blocks(selected_blocks),:))
        cgpencol([0.6 0.6 0.6])
        if selected(selected_blocks) == 1
%            cgrect(pos_moved(selected_blocks,1),pos_moved(selected_blocks,2)+25,xy_blocks(selected(selected_blocks),1),xy_blocks(selected(selected_blocks),2));
           cgdrawsprite(selected(selected_blocks),pos_moved(selected_blocks,1)-25,pos_moved(selected_blocks,2)+25,50,50)
           cgdrawsprite(selected(selected_blocks),pos_moved(selected_blocks,1)+25,pos_moved(selected_blocks,2)+25,50,50)
%            cgrect(pos_moved(selected_blocks,1)-25,pos_moved(selected_blocks,2)-25,50,50)
           cgdrawsprite(selected(selected_blocks),pos_moved(selected_blocks,1)-25,pos_moved(selected_blocks,2)-25,50,50)
        elseif selected(selected_blocks) == 2
%             cgrect(pos_moved(selected_blocks,1),pos_moved(selected_blocks,2)-25,xy_blocks(selected(selected_blocks),1),xy_blocks(selected(selected_blocks),2));
            cgdrawsprite(selected(selected_blocks),pos_moved(selected_blocks,1)-25,pos_moved(selected_blocks,2)-25,50,50)
            cgdrawsprite(selected(selected_blocks),pos_moved(selected_blocks,1)+25,pos_moved(selected_blocks,2)-25,50,50)
%             cgrect(pos_moved(selected_blocks,1)+25,pos_moved(selected_blocks,2)+25,50,50)
            cgdrawsprite(selected(selected_blocks),pos_moved(selected_blocks,1)+25,pos_moved(selected_blocks,2)+25,50,50)
        else
%             cgrect(pos_moved(selected_blocks,1),pos_moved(selected_blocks,2),xy_blocks(selected(selected_blocks),1),xy_blocks(selected(selected_blocks),2));
            cgdrawsprite(selected(selected_blocks),pos_moved(selected_blocks,1),pos_moved(selected_blocks,2),xy_blocks(selected(selected_blocks),1),xy_blocks(selected(selected_blocks),2))
        end
    elseif selected_blocks~=which_move
%         cgpencol(cols.blocks(colours_blocks(selected_blocks),:))
        cgpencol([0.6 0.6 0.6])
        if selected(selected_blocks) == 1
%            cgrect(x_pos_all(selected_blocks,1),startpos_selected_items(2)+25,xy_blocks(selected(selected_blocks),1),xy_blocks(selected(selected_blocks),2));
           cgdrawsprite(selected(selected_blocks),x_pos_all(selected_blocks,1)-25,startpos_selected_items(2)+25,50,50)
           cgdrawsprite(selected(selected_blocks),x_pos_all(selected_blocks,1)+25,startpos_selected_items(2)+25,50,50)           
%            cgrect(x_pos_all(selected_blocks,1)-25,startpos_selected_items(2)-25,50,50)
           cgdrawsprite(selected(selected_blocks),x_pos_all(selected_blocks,1)-25,startpos_selected_items(2)-25,50,50)
        elseif selected(selected_blocks) == 2
%             cgrect(x_pos_all(selected_blocks,1),startpos_selected_items(2)-25,xy_blocks(selected(selected_blocks),1),xy_blocks(selected(selected_blocks),2));
            cgdrawsprite(selected(selected_blocks),x_pos_all(selected_blocks,1)-25,startpos_selected_items(2)-25,50,50)
            cgdrawsprite(selected(selected_blocks),x_pos_all(selected_blocks,1)+25,startpos_selected_items(2)-25,50,50)
%             cgrect(x_pos_all(selected_blocks,1)+25,startpos_selected_items(2)+25,50,50)
            cgdrawsprite(selected(selected_blocks),x_pos_all(selected_blocks,1)+25,startpos_selected_items(2)+25,50,50)
        else
%             cgrect(x_pos_all(selected_blocks,1),startpos_selected_items(2),xy_blocks(selected(selected_blocks),1),xy_blocks(selected(selected_blocks),2));
            cgdrawsprite(selected(selected_blocks),x_pos_all(selected_blocks,1),startpos_selected_items(2),xy_blocks(selected(selected_blocks),1),xy_blocks(selected(selected_blocks),2))
        end
    else

    % make frame around selected one:    
    mk_frame = 6;
    if selected_for_move
        cgpencol(cols.white)
    else
        cgpencol(cols.green2)
    end
    if selected(selected_blocks) == 1
       cgrect(x_new,y_new+25,xy_blocks(selected(selected_blocks),1)+mk_frame,xy_blocks(selected(selected_blocks),2)+mk_frame);
       cgrect(x_new-25,y_new-25,50+mk_frame,50+mk_frame)
    elseif selected(selected_blocks) == 2
        cgrect(x_new,y_new-25,xy_blocks(selected(selected_blocks),1)+mk_frame,xy_blocks(selected(selected_blocks),2)+mk_frame);
        cgrect(x_new+25,y_new+25,50+mk_frame,50+mk_frame)
%             cgdrawsprite(selected(selected_blocks),x_new+25,y_new+25,50,50)
    else
        cgrect(x_new,y_new,xy_blocks(selected(selected_blocks),1)+mk_frame,xy_blocks(selected(selected_blocks),2)+mk_frame);
    end        

%         cgpencol(cols.blocks(colours_blocks(selected_blocks),:))
    cgpencol([0.6 0.6 0.6])
%         cgpencol(cols.blocks(colours_blocks(1),:))
    if selected(selected_blocks) == 1
%        cgrect(x_new,y_new+25,xy_blocks(selected(selected_blocks),1),xy_blocks(selected(selected_blocks),2));
%        cgrect(x_new-25,y_new-25,50,50)
       cgdrawsprite(selected(selected_blocks),x_new-25,y_new+25,50,50)
       cgdrawsprite(selected(selected_blocks),x_new+25,y_new+25,50,50)
       cgdrawsprite(selected(selected_blocks),x_new-25,y_new-25,50,50)
    elseif selected(selected_blocks) == 2
%             cgrect(x_new,y_new-25,xy_blocks(selected(selected_blocks),1),xy_blocks(selected(selected_blocks),2));
        cgdrawsprite(selected(selected_blocks),x_new-25,y_new-25,50,50)
        cgdrawsprite(selected(selected_blocks),x_new+25,y_new-25,50,50)
        cgdrawsprite(selected(selected_blocks),x_new+25,y_new+25,50,50)
    else
%         cgrect(x_new,y_new,xy_blocks(selected(selected_blocks),1),xy_blocks(selected(selected_blocks),2));
        cgdrawsprite(selected(selected_blocks),x_new,y_new,xy_blocks(selected(selected_blocks),1),xy_blocks(selected(selected_blocks),2))
    end
    % end make frame around selected one:

        
        
    end
end