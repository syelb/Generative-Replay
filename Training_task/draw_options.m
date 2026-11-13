% draw options to choose from

y_options = 225;

cgpencol(cols.black), cgrect(0,y_options,600,250)
cgpencol(cols.white), cgrect(0,y_options,600-4,250-4)

avail_blocks = [-200 y_options-25 50  50;  % corner element 1
                -175 y_options+25 100 50;  % corner element 1
                 -25 y_options+25 50  50;  % corner element 4
                 -50 y_options-25 100 50;  % corner element 4
                  50 y_options    50  150; % long vertical bar
                 175 y_options    150 50]; % long horizontal bar

selected_avail_blocks = zeros(size(avail_blocks,1),1);

if ~replacement
    for k=1:length(selected)
       if selected(k) == 1
           selected_avail_blocks(1:2) = 1;
       elseif selected(k) == 2
           selected_avail_blocks(3:4) = 1;
       else
           selected_avail_blocks(selected(k)+2) = 1;
       end
    end
end
             
for block=1:size(avail_blocks,1)
    if ~selected_avail_blocks(block)
        cgpencol(cols.black)
        cgrect(avail_blocks(block,1),avail_blocks(block,2),avail_blocks(block,3),avail_blocks(block,4))
        if block==1
           cgdrawsprite(1,avail_blocks(block,1),avail_blocks(block,2),50,50) 
        elseif block==2
            cgdrawsprite(1,avail_blocks(block,1)-25,avail_blocks(block,2),50,50)
            cgdrawsprite(1,avail_blocks(block,1)+25,avail_blocks(block,2),50,50)
        elseif block==3
           cgdrawsprite(2,avail_blocks(block,1),avail_blocks(block,2),50,50) 
        elseif block==4
            cgdrawsprite(2,avail_blocks(block,1)-25,avail_blocks(block,2),50,50)
            cgdrawsprite(2,avail_blocks(block,1)+25,avail_blocks(block,2),50,50)
        elseif block == 5
            cgdrawsprite(3,avail_blocks(block,1),avail_blocks(block,2),avail_blocks(block,3),avail_blocks(block,4))
        elseif block == 6
            cgdrawsprite(4,avail_blocks(block,1),avail_blocks(block,2),avail_blocks(block,3),avail_blocks(block,4))
        end
    end
end

if choice ==0
    choice = randi(size(avail_blocks,1)-4);
end

pos_cursor = [-175 -50 50 175];
% pos_cursor_use = pos_cursor;
% pos_cursor_use(selected) = [];

if ~show_col
    cgpencol(cols.green2)
    cgrect(pos_cursor(choice),y_options+100,50,5)
    cgrect(pos_cursor(choice),y_options-100,50,5)
end
% pos_cursor(selected) = [];
