% draw a grid on left upper side of screen that displays required stim

size_out = 50;
size_in  = 46;

x_grid_start = -500;
y_grid_start = -127;


grid_pos = [[x_grid_start:50:x_grid_start+250]' [y_grid_start:-50:y_grid_start-250]'];

for grids=1:size(grid_pos,1)
    for grids2=1:size(grid_pos,1)
        cgpencol(cols.black), cgrect(grid_pos(grids,1),grid_pos(grids2,2),size_out,size_out)
        if REQUIRED_FORM(grids2,grids)==0
            cgpencol(cols.white), cgrect(grid_pos(grids,1),grid_pos(grids2,2),size_in,size_in)
        end
    end
end

cgpencol(cols.black)
% cgrect(200,-400,sum(REQUIRED_FORM(end,:))*50,3)
cgrect(200,-400,(max(find(REQUIRED_FORM(end,:)))-min(find(REQUIRED_FORM(end,:)))+1)*50,3)

left_side_base = 200-(sum(REQUIRED_FORM(end,:))*50)/2;