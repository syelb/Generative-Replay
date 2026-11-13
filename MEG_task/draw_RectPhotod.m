function [  ] = DrawRectPhotod(colour,x,y)

size_rect_x = 1500;
size_rect_y = 25;

cgpencol(colour)
cgrect(x,y,size_rect_x,size_rect_y)


end