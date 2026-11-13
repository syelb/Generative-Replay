function [x_new,y_new] = mk_new_pos(x,y,direction)
% change position of x and y according to chosen change in direction

if direction == 95  % up
    x_new = x;
    y_new = y + 25;
elseif direction == 97 % left
    x_new = x - 25;
    y_new = y;
elseif direction == 98 % right
    x_new = x + 25;
    y_new = y;
elseif direction == 100 % down
    x_new = x;
    y_new = y - 25;

end

end