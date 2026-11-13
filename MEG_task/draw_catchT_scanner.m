function [] = draw_catchT_scanner(stim,block)
% draw one random element in a catch trial
n_grid = 6;

screen_position_element = [0 0 -250 0 250 0 -250 250]; % middle, left, right, upper left

if block==1
    
    if stim == 1
       cgdrawsprite(stim,screen_position_element(1)-25,screen_position_element(2)+25,50,50)
       cgdrawsprite(stim,screen_position_element(1)+25,screen_position_element(2)+25,50,50)
       cgdrawsprite(stim,screen_position_element(1)-25,screen_position_element(2)-25,50,50)
    elseif stim == 2
       cgdrawsprite(stim,screen_position_element(1)-25,screen_position_element(2)-25,50,50)
       cgdrawsprite(stim,screen_position_element(1)+25,screen_position_element(2)-25,50,50)
       cgdrawsprite(stim,screen_position_element(1)+25,screen_position_element(2)+25,50,50)
    elseif stim == 3
        cgdrawsprite(stim,screen_position_element(1),screen_position_element(2),50,150)
%         cgdrawsprite(stim,screen_position_element(1),screen_position_element(2),150,50)
    elseif stim == 4
        cgdrawsprite(stim,screen_position_element(1),screen_position_element(2),150,50)
%         cgdrawsprite(stim,screen_position_element(1),screen_position_element(2),50,150)
    end
    
elseif block==2
    
    if stim(1) == 1
       cgdrawsprite(stim(1),screen_position_element(3)-25,screen_position_element(4)+25,50,50)
       cgdrawsprite(stim(1),screen_position_element(3)+25,screen_position_element(4)+25,50,50)
       cgdrawsprite(stim(1),screen_position_element(3)-25,screen_position_element(4)-25,50,50)
    elseif stim(1) == 2
       cgdrawsprite(stim(1),screen_position_element(3)-25,screen_position_element(4)-25,50,50)
       cgdrawsprite(stim(1),screen_position_element(3)+25,screen_position_element(4)-25,50,50)
       cgdrawsprite(stim(1),screen_position_element(3)+25,screen_position_element(4)+25,50,50)
    elseif stim(1) == 3
        cgdrawsprite(stim(1),screen_position_element(3),screen_position_element(4),50,150)
%         cgdrawsprite(stim(1),screen_position_element(3),screen_position_element(4),150,50)
    elseif stim(1) == 4
        cgdrawsprite(stim(1),screen_position_element(3),screen_position_element(4),150,50)
%         cgdrawsprite(stim(1),screen_position_element(3),screen_position_element(4),50,150)
    end    
    
    if stim(2) == 1
       cgdrawsprite(stim(2),screen_position_element(5)-25,screen_position_element(6)+25,50,50)
       cgdrawsprite(stim(2),screen_position_element(5)+25,screen_position_element(6)+25,50,50)
       cgdrawsprite(stim(2),screen_position_element(5)-25,screen_position_element(6)-25,50,50)
    elseif stim(2) == 2
       cgdrawsprite(stim(2),screen_position_element(5)-25,screen_position_element(6)-25,50,50)
       cgdrawsprite(stim(2),screen_position_element(5)+25,screen_position_element(6)-25,50,50)
       cgdrawsprite(stim(2),screen_position_element(5)+25,screen_position_element(6)+25,50,50)
    elseif stim(2) == 3
        cgdrawsprite(stim(2),screen_position_element(5),screen_position_element(6),50,150)
%         cgdrawsprite(stim(2),screen_position_element(5),screen_position_element(6),150,50)
    elseif stim(2) == 4
        cgdrawsprite(stim(2),screen_position_element(5),screen_position_element(6),150,50)
%         cgdrawsprite(stim(2),screen_position_element(5),screen_position_element(6),50,150)
    end      
    
elseif block==3
    
    % Upper Left
    if stim(1) == 1
       cgdrawsprite(stim(1),screen_position_element(7)-25,screen_position_element(8)+25,50,50)
       cgdrawsprite(stim(1),screen_position_element(7)+25,screen_position_element(8)+25,50,50)
       cgdrawsprite(stim(1),screen_position_element(7)-25,screen_position_element(8)-25,50,50)
    elseif stim(1) == 2
       cgdrawsprite(stim(1),screen_position_element(7)-25,screen_position_element(8)-25,50,50)
       cgdrawsprite(stim(1),screen_position_element(7)+25,screen_position_element(8)-25,50,50)
       cgdrawsprite(stim(1),screen_position_element(7)+25,screen_position_element(8)+25,50,50)
    elseif stim(1) == 3
        cgdrawsprite(stim(1),screen_position_element(7),screen_position_element(8),50,150)
%         cgdrawsprite(stim(1),screen_position_element(7),screen_position_element(8),150,50)
    elseif stim(1) == 4
        cgdrawsprite(stim(1),screen_position_element(7),screen_position_element(8),150,50)
%         cgdrawsprite(stim(1),screen_position_element(7),screen_position_element(8),50,150)
    end    
    
    % Middle
    if stim(2) == 1
       cgdrawsprite(stim(2),screen_position_element(1)-25,screen_position_element(2)+25,50,50)
       cgdrawsprite(stim(2),screen_position_element(1)+25,screen_position_element(2)+25,50,50)
       cgdrawsprite(stim(2),screen_position_element(1)-25,screen_position_element(2)-25,50,50)
    elseif stim(2) == 2
       cgdrawsprite(stim(2),screen_position_element(1)-25,screen_position_element(2)-25,50,50)
       cgdrawsprite(stim(2),screen_position_element(1)+25,screen_position_element(2)-25,50,50)
       cgdrawsprite(stim(2),screen_position_element(1)+25,screen_position_element(2)+25,50,50)
    elseif stim(2) == 3
        cgdrawsprite(stim(2),screen_position_element(1),screen_position_element(2),50,150)
%         cgdrawsprite(stim(2),screen_position_element(1),screen_position_element(2),150,50)
    elseif stim(2) == 4
        cgdrawsprite(stim(2),screen_position_element(1),screen_position_element(2),150,50)
%         cgdrawsprite(stim(2),screen_position_element(1),screen_position_element(2),50,150)
    end     
    
end

end