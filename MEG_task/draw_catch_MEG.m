function [  ] = draw_catch_MEG(key,keylist,cols,question_catch,question_type_catch,y)

if nargin<5
    y = -200;
    question_type_catch = 1;
elseif nargin<6
    y = -200;
end

options_catch = {' "To the left" ' ' "On top" ' ' "To the right" ' ' "Below" '};
screen_position_options = [-100 0  0 100  100 0  0 -100]; 


cgpencol(cols.black)

if question_type_catch==1
    cgtext(question_catch,0,y)
elseif question_type_catch==0
    if strcmp(question_catch,options_catch{1})
        cgtext('?',screen_position_options(1),screen_position_options(2)) 
    elseif strcmp(question_catch,options_catch{2})
        cgtext('?',screen_position_options(3),screen_position_options(4)) 
    elseif strcmp(question_catch,options_catch{3})
        cgtext('?',screen_position_options(5),screen_position_options(6)) 
    elseif strcmp(question_catch,options_catch{4})
        cgtext('?',screen_position_options(7),screen_position_options(8)) 
    end
end

if isempty(key)
    cgpencol(cols.black), cgtext('Yes',-200,y)
    cgpencol(cols.black), cgtext('No',200,y)
elseif key == keylist(1) 
    % cgpencol(cols.green2),   cgtext('Yes',-200,y)
    cgpencol(cols.yellow),   cgtext('Yes',-200,y)
    cgpencol(cols.black), cgtext('No',200,y)
elseif key == keylist(2) 
    cgpencol(cols.black), cgtext('Yes',-200,y)
    % cgpencol(cols.green2),   cgtext('No',200,y)
    cgpencol(cols.yellow),   cgtext('No',200,y)
end
    



end