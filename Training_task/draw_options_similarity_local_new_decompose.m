% draw a grid on left upper side of screen that displays required stim

if target == 1
   cgdrawsprite(target,screen_position_element(1)-25,screen_position_element(2)+25,50,50)
   cgdrawsprite(target,screen_position_element(1)+25,screen_position_element(2)+25,50,50)
   cgdrawsprite(target,screen_position_element(1)-25,screen_position_element(2)-25,50,50)
elseif target == 2
   cgdrawsprite(target,screen_position_element(1)-25,screen_position_element(2)-25,50,50)
   cgdrawsprite(target,screen_position_element(1)+25,screen_position_element(2)-25,50,50)
   cgdrawsprite(target,screen_position_element(1)+25,screen_position_element(2)+25,50,50)
elseif target == 3
    cgdrawsprite(target,screen_position_element(1),screen_position_element(2),50,150)
elseif target == 4
    cgdrawsprite(target,screen_position_element(1),screen_position_element(2),150,50)
end


if q_element == 1
   cgdrawsprite(q_element,screen_position_element(3)-25,screen_position_element(4)+25,50,50)
   cgdrawsprite(q_element,screen_position_element(3)+25,screen_position_element(4)+25,50,50)
   cgdrawsprite(q_element,screen_position_element(3)-25,screen_position_element(4)-25,50,50)
elseif q_element == 2
   cgdrawsprite(q_element,screen_position_element(3)-25,screen_position_element(4)-25,50,50)
   cgdrawsprite(q_element,screen_position_element(3)+25,screen_position_element(4)-25,50,50)
   cgdrawsprite(q_element,screen_position_element(3)+25,screen_position_element(4)+25,50,50)
elseif q_element == 3
    cgdrawsprite(q_element,screen_position_element(3),screen_position_element(4),50,150)
elseif q_element == 4
    cgdrawsprite(q_element,screen_position_element(3),screen_position_element(4),150,50)
end

cgpencol(cols.black)
cgtext(' "How does this element connect in your plan?" ',0,screen_position_element(4))


