function [  ] = draw_catch_MEG(key,keylist,cols,question_catch,y)

if nargin<5
    y = -200;
end

screen_position_options = [-150 0  0   150 150 0 0 -150 0 -350]; 


cgpencol(cols.black)
cgtext(question_catch,0,y)

if isempty(key)
    cgpencol(cols.black), cgtext('Yes',-200,y)
    cgpencol(cols.black), cgtext('No',200,y)
elseif key == keylist(1) 
    cgpencol(cols.green2),   cgtext('Yes',-200,y)
    cgpencol(cols.black), cgtext('No',200,y)
elseif key == keylist(2) 
    cgpencol(cols.black), cgtext('Yes',-200,y)
    cgpencol(cols.green2),   cgtext('No',200,y)
end
    



end