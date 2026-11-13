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

