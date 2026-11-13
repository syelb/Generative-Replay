
function bricks_order = mk_brick_order_3pieces(STIMS_obj,bricks)

PART_no1 = STIMS_obj(:,:,1); PART_no1(PART_no1==bricks(1)) = 0;

PART_no2 = STIMS_obj(:,:,1); PART_no2(PART_no2==bricks(2)) = 0;

PART_no3 = STIMS_obj(:,:,1); PART_no3(PART_no3==bricks(3)) = 0;

% order bricks such that first two are connected via besideness and second two via ontopess, and middle column is the stimulus in middle
% isolate parts that contain brick 1 | brick 2 | brick 3, see if they contain ontopness; besideness
bricks_order = [mk_ontopness(PART_no3)+mk_ontopness(PART_no2)  mk_ontopness(PART_no1)+mk_ontopness(PART_no3)   mk_ontopness(PART_no1)+mk_ontopness(PART_no2);
                mk_besideness(PART_no3)+mk_besideness(PART_no2) mk_besideness(PART_no1)+mk_besideness(PART_no3) mk_besideness(PART_no1)+mk_besideness(PART_no2)];

bricks_order = [find(~bricks_order(1,:)&bricks_order(2,:)) find(bricks_order(1,:)&bricks_order(2,:)) find(bricks_order(1,:)&~bricks_order(2,:))];

end