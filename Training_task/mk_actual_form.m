function [ACTUAL_FORM, INFO_FORM, violation] = mk_actual_form(pos_moved,ACTUAL_FORM,pos_colours,REQUIRED_FORM,length_built,moved_order)

INFO_FORM = ACTUAL_FORM;

[~,id] = sort(pos_moved(:,2)); % sort just the first column
pos_moved = pos_moved(id,:);

moved_order = moved_order(id);

pos_moved_new = [pos_moved(:,1)-pos_moved(:,3)/2 pos_moved(:,1)+pos_moved(:,3)/2 pos_moved(:,2)-pos_moved(:,4)/2 pos_moved(:,2)+pos_moved(:,4)/2]; % from-to on x, from-to on y


% find out if several blocks start at bottom, if so put one at most left
% first
min_x = min(pos_moved_new(:,3)); id_min_x = find(pos_moved_new(:,3)==min_x);
[~,id] = sort(pos_moved_new(pos_moved_new(:,3)==min_x,1)); % sort just the first column

temp = pos_moved_new;
temp_moved = moved_order;

for i=1:length(id_min_x)
    pos_moved_new(id_min_x(i),:) = temp(id_min_x(id(i)),:);
    moved_order(id_min_x(i),:) = temp_moved(id_min_x(id(i)),:);
end

% pos_moved_new(pos_moved_new(:,3)==min_x,:) = pos_moved_new(id,:);

max_right = pos_moved_new(1,1)+5*50;


% first column: row in ACTUAL_FORM where block starts
% second column: length of block along y
% third column: column in ACTUAL_FORM where block starts PROBLEM
% fourth column: length of block along x
pos_moved_new2= [6+(-400-pos_moved_new(:,3))/50 (pos_moved_new(:,4)-pos_moved_new(:,3)-50)/50 6-(max_right-pos_moved_new(:,1))/50 (pos_moved_new(:,2)-pos_moved_new(:,1)-50)/50];

pos_moved_new2(:,3) = pos_moved_new2(:,3) + find(REQUIRED_FORM(end,:),1,'first')-1;

for i = 1:size(pos_moved_new,1)
    if (pos_moved_new2(i,1)>0)&&(pos_moved_new2(i,1)-pos_moved_new2(i,2)>0)&&(pos_moved_new2(i,3)>0)&&(pos_moved_new2(i,3)+pos_moved_new2(i,4)>0)
        ACTUAL_FORM(pos_moved_new2(i,1):-1:pos_moved_new2(i,1)-pos_moved_new2(i,2),pos_moved_new2(i,3):1:pos_moved_new2(i,3)+pos_moved_new2(i,4))=1;
        INFO_FORM(pos_moved_new2(i,1):-1:pos_moved_new2(i,1)-pos_moved_new2(i,2),pos_moved_new2(i,3):1:pos_moved_new2(i,3)+pos_moved_new2(i,4))=moved_order(i);
    end
end

violation = 0;



end