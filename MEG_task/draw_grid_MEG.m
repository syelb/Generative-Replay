% draw a grid on left upper side of screen that displays required stim

size_out = 50;

colours_objects = [0.6 0.6 0.6;    % grey
                   0.62 0.62 0.62; % lighter grey
                   0.58 0.58 0.58; % darker grey
                   0.7 0.7 0];     % bright yellow

% x_grid_start = -size(REQUIRED_FORM,2)*25 + 25;
% y_grid_start = size(REQUIRED_FORM,1)*25 - 25;

REQUIRED_FORM = mk_recentre(REQUIRED_FORM);

size_FORM = size(mk_crop(REQUIRED_FORM));

size_x = size_FORM(2) * size_out;
size_y = size_FORM(1) * size_out;

% x_grid_start = -150 + (6-size_FORM(2))*50;
% y_grid_start =  150 + (6-size_FORM(1))*50/2;

x_grid_start = -size_x/2 + size_out/2;
y_grid_start =  size_y/2 - size_out/2 + (size(REQUIRED_FORM,1)-size_FORM(1))*size_out;

grid_pos = [[x_grid_start:50:x_grid_start+250]' [y_grid_start:-50:y_grid_start-250]'];

for grids=1:size(grid_pos,1)
    for grids2=1:size(grid_pos,1)
        if REQUIRED_FORM(grids2,grids)~=0
            cgpencol(colours_objects(REQUIRED_FORM(grids2,grids),:))
            cgrect(grid_pos(grids,1),grid_pos(grids2,2),size_out,size_out)
        end
    end
end