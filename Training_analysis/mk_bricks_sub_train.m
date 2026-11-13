% obtain brick info of subject based on observed stims
function [bricks_conn,bricks_rel,bricks_conn_trial,bricks_rel_trial,bricks_conn_Q,...
          bricks_rel_Q,correct_trials_all,rt_all,stims_all,STIMS_all,relation_catch_all,pred_choice,...
          learned_adj,learned_2adj,learned_3adj,learned_4adj,...
          mistake_adj,mistake_2adj,mistake_3adj,mistake_4adj] = mk_bricks_sub_train(behav_folder)

    bricks_conn_Q = [];
    bricks_rel_Q  = [];
      
    behav_files    = dir(fullfile(behav_folder,'Decompose_Tetris_subj*.mat'));

    correct_trials_all = [];

    STIMS_all = [];
    rt_all    = [];
    
    stims_all = [];
    
    pred_choice     = [];
    relation_catch_all = [];
    
    learned_adj = zeros(4,4);
    
    learned_2adj = zeros(4,4);
    learned_3adj = zeros(4,4);
    learned_4adj = zeros(4,4);
    
    mistake_adj  = zeros(4);
    mistake_2adj = zeros(4);
    mistake_3adj = zeros(4);
    mistake_4adj = zeros(4);

    for idx_sess = 1:length(behav_files)-1

        load(fullfile(behav_folder,behav_files(idx_sess).name))

        correct_trials_all = [correct_trials_all res_train.correct'];

        STIMS_all = cat(3,STIMS_all,res_train.SOLUTIONS);

%         rt_all = [rt_all; res.behav.rt'];
        
        pred_choice = [pred_choice res_train.pred_choice];
        % 71 = space
        % 95 - Up
        % 97 - Left
        % 98 - Right
        % 100 - Down
        
%         relation_catch_all = [relation_catch_all; res.behav.relation_catch'];
        
%         stims_all = [stims_all; res.order];

    end  

    %%%%% now obtain unique stims and then get brick ordering %%%%%
    [n,m,p] = size(STIMS_all);
    a = reshape(STIMS_all,n,[],1);
    b = reshape(a(:),n*m,[])';
    c = unique(b,'rows','stable')';
    STIMS_unique = reshape(c,n,m,[]);

    % obtain summary for all unique stims shown
    
    % there are two ways of ordering the stims:
    bricks_conn = zeros(size(STIMS_unique,3),3); % Element connected to middle via besideness | middle Element | Element connected to middle via ontopness
    bricks_rel  = zeros(size(STIMS_unique,3),4); % left element | ontop element | right element | below element
    
    for idx_stim=1:size(STIMS_unique,3)

        STIMS_obj = STIMS_unique(:,:,idx_stim);

        bricks = unique(STIMS_obj); bricks(1) = []; % get rid of zero
        
        if length(bricks)==3

            PART_no1 = STIMS_obj(:,:,1); PART_no1(PART_no1==bricks(1)) = 0;

            PART_no2 = STIMS_obj(:,:,1); PART_no2(PART_no2==bricks(2)) = 0;

            PART_no3 = STIMS_obj(:,:,1); PART_no3(PART_no3==bricks(3)) = 0;

            % order bricks such that first two are connected via besideness and second two via ontopess, and middle column is the stimulus in middle
            % isolate parts that contain brick 1 | brick 2 | brick 3, see if they contain ontopness; besideness
            bricks_order = [mk_ontopness(PART_no3)+mk_ontopness(PART_no2)  mk_ontopness(PART_no1)+mk_ontopness(PART_no3)   mk_ontopness(PART_no1)+mk_ontopness(PART_no2);
                            mk_besideness(PART_no3)+mk_besideness(PART_no2) mk_besideness(PART_no1)+mk_besideness(PART_no3) mk_besideness(PART_no1)+mk_besideness(PART_no2)];

            bricks_order = [find(~bricks_order(1,:)&bricks_order(2,:)) find(bricks_order(1,:)&bricks_order(2,:)) find(bricks_order(1,:)&~bricks_order(2,:))];

            bricks_conn(idx_stim,:) = bricks(bricks_order)';  

            if mk_ontopness(PART_no1)
                [~,~,bricks_rel(idx_stim,2),bricks_rel(idx_stim,4)] = mk_ontopness(PART_no1);
            elseif mk_ontopness(PART_no2)
                [~,~,bricks_rel(idx_stim,2),bricks_rel(idx_stim,4)] = mk_ontopness(PART_no2);
            elseif mk_ontopness(PART_no3)
                [~,~,bricks_rel(idx_stim,2),bricks_rel(idx_stim,4)] = mk_ontopness(PART_no3);
            end

            if mk_besideness(PART_no1)
                [~,~,bricks_rel(idx_stim,1),bricks_rel(idx_stim,3)] = mk_besideness(PART_no1);
            elseif mk_besideness(PART_no2)
                [~,~,bricks_rel(idx_stim,1),bricks_rel(idx_stim,3)] = mk_besideness(PART_no2);
            elseif mk_besideness(PART_no3)
                [~,~,bricks_rel(idx_stim,1),bricks_rel(idx_stim,3)] = mk_besideness(PART_no3);
            end   
        
        elseif length(bricks)==2
            
            if mk_ontopness(STIMS_obj)
                [~,~,bricks_rel(idx_stim,2),bricks_rel(idx_stim,4)] = mk_ontopness(STIMS_obj);                
                bricks_conn(idx_stim,:) = [0 bricks'];
            elseif mk_besideness(STIMS_obj)
                [~,~,bricks_rel(idx_stim,1),bricks_rel(idx_stim,3)] = mk_besideness(STIMS_obj);
                bricks_conn(idx_stim,:) = [bricks' 0];  
            end
                        
        end

    end
    
    % obtain summary for all stims per trial shown
    
    % there are two ways of ordering the stims:
    bricks_conn_trial = zeros(size(STIMS_all,3),3); % Element connected to middle via besideness | middle Element | Element connected to middle via ontopness
    bricks_rel_trial  = zeros(size(STIMS_all,3),4); % left element | ontop element | right element | below element
    
    for idx_stim=1:size(STIMS_all,3)

        STIMS_obj = STIMS_all(:,:,idx_stim);

        bricks = unique(STIMS_obj); bricks(1) = []; % get rid of zero
        
        if length(bricks)==3
            
            bricks_order = mk_brick_order_3pieces(STIMS_obj(:,:,1),bricks);

%             PART_no1 = STIMS_obj(:,:,1); PART_no1(PART_no1==bricks(1)) = 0;
% 
%             PART_no2 = STIMS_obj(:,:,1); PART_no2(PART_no2==bricks(2)) = 0;
% 
%             PART_no3 = STIMS_obj(:,:,1); PART_no3(PART_no3==bricks(3)) = 0;
% 
%             % order bricks such that first two are connected via besideness and second two via ontopess, and middle column is the stimulus in middle
%             % isolate parts that contain brick 1 | brick 2 | brick 3, see if they contain ontopness; besideness
%             bricks_order = [mk_ontopness(PART_no3)+mk_ontopness(PART_no2)  mk_ontopness(PART_no1)+mk_ontopness(PART_no3)   mk_ontopness(PART_no1)+mk_ontopness(PART_no2);
%                             mk_besideness(PART_no3)+mk_besideness(PART_no2) mk_besideness(PART_no1)+mk_besideness(PART_no3) mk_besideness(PART_no1)+mk_besideness(PART_no2)];
% 
%             bricks_order = [find(~bricks_order(1,:)&bricks_order(2,:)) find(bricks_order(1,:)&bricks_order(2,:)) find(bricks_order(1,:)&~bricks_order(2,:))];

            bricks_conn_trial(idx_stim,:) = bricks(bricks_order)';  

            if mk_ontopness(PART_no1)
                [~,~,bricks_rel_trial(idx_stim,2),bricks_rel_trial(idx_stim,4)] = mk_ontopness(PART_no1);
            elseif mk_ontopness(PART_no2)
                [~,~,bricks_rel_trial(idx_stim,2),bricks_rel_trial(idx_stim,4)] = mk_ontopness(PART_no2);
            elseif mk_ontopness(PART_no3)
                [~,~,bricks_rel_trial(idx_stim,2),bricks_rel_trial(idx_stim,4)] = mk_ontopness(PART_no3);
            end

            if mk_besideness(PART_no1)
                [~,~,bricks_rel_trial(idx_stim,1),bricks_rel_trial(idx_stim,3)] = mk_besideness(PART_no1);
            elseif mk_besideness(PART_no2)
                [~,~,bricks_rel_trial(idx_stim,1),bricks_rel_trial(idx_stim,3)] = mk_besideness(PART_no2);
            elseif mk_besideness(PART_no3)
                [~,~,bricks_rel_trial(idx_stim,1),bricks_rel_trial(idx_stim,3)] = mk_besideness(PART_no3);
            end 
            
            learned_adj(bricks_conn_trial(idx_stim,1),bricks_conn_trial(idx_stim,2)) = learned_adj(bricks_conn_trial(idx_stim,1),bricks_conn_trial(idx_stim,2)) + 1;
            learned_adj(bricks_conn_trial(idx_stim,2),bricks_conn_trial(idx_stim,1)) = learned_adj(bricks_conn_trial(idx_stim,2),bricks_conn_trial(idx_stim,1)) + 1;
            learned_adj(bricks_conn_trial(idx_stim,2),bricks_conn_trial(idx_stim,3)) = learned_adj(bricks_conn_trial(idx_stim,2),bricks_conn_trial(idx_stim,3)) + 1;
            learned_adj(bricks_conn_trial(idx_stim,3),bricks_conn_trial(idx_stim,2)) = learned_adj(bricks_conn_trial(idx_stim,3),bricks_conn_trial(idx_stim,2)) + 1;
            
            learned_3adj(bricks_conn_trial(idx_stim,1),bricks_conn_trial(idx_stim,2)) = learned_3adj(bricks_conn_trial(idx_stim,1),bricks_conn_trial(idx_stim,2)) + 1;
            learned_3adj(bricks_conn_trial(idx_stim,2),bricks_conn_trial(idx_stim,1)) = learned_3adj(bricks_conn_trial(idx_stim,2),bricks_conn_trial(idx_stim,1)) + 1;
            learned_3adj(bricks_conn_trial(idx_stim,2),bricks_conn_trial(idx_stim,3)) = learned_3adj(bricks_conn_trial(idx_stim,2),bricks_conn_trial(idx_stim,3)) + 1;
            learned_3adj(bricks_conn_trial(idx_stim,3),bricks_conn_trial(idx_stim,2)) = learned_3adj(bricks_conn_trial(idx_stim,3),bricks_conn_trial(idx_stim,2)) + 1;
            
            if correct_trials_all(idx_stim)==0
                mistake_adj(bricks_conn_trial(idx_stim,1),bricks_conn_trial(idx_stim,2)) = mistake_adj(bricks_conn_trial(idx_stim,1),bricks_conn_trial(idx_stim,2)) + 1;
                mistake_adj(bricks_conn_trial(idx_stim,2),bricks_conn_trial(idx_stim,1)) = mistake_adj(bricks_conn_trial(idx_stim,2),bricks_conn_trial(idx_stim,1)) + 1;
                mistake_adj(bricks_conn_trial(idx_stim,2),bricks_conn_trial(idx_stim,3)) = mistake_adj(bricks_conn_trial(idx_stim,2),bricks_conn_trial(idx_stim,3)) + 1;
                mistake_adj(bricks_conn_trial(idx_stim,3),bricks_conn_trial(idx_stim,2)) = mistake_adj(bricks_conn_trial(idx_stim,3),bricks_conn_trial(idx_stim,2)) + 1;

                mistake_3adj(bricks_conn_trial(idx_stim,1),bricks_conn_trial(idx_stim,2)) = mistake_3adj(bricks_conn_trial(idx_stim,1),bricks_conn_trial(idx_stim,2)) + 1;
                mistake_3adj(bricks_conn_trial(idx_stim,2),bricks_conn_trial(idx_stim,1)) = mistake_3adj(bricks_conn_trial(idx_stim,2),bricks_conn_trial(idx_stim,1)) + 1;
                mistake_3adj(bricks_conn_trial(idx_stim,2),bricks_conn_trial(idx_stim,3)) = mistake_3adj(bricks_conn_trial(idx_stim,2),bricks_conn_trial(idx_stim,3)) + 1;
                mistake_3adj(bricks_conn_trial(idx_stim,3),bricks_conn_trial(idx_stim,2)) = mistake_3adj(bricks_conn_trial(idx_stim,3),bricks_conn_trial(idx_stim,2)) + 1;
            end
            
        elseif length(bricks)==2
            
            if mk_ontopness(STIMS_obj)
                [~,~,bricks_rel_trial(idx_stim,2),bricks_rel_trial(idx_stim,4)] = mk_ontopness(STIMS_obj);                
                bricks_conn_trial(idx_stim,:) = [0 bricks'];
            elseif mk_besideness(STIMS_obj)
                [~,~,bricks_rel_trial(idx_stim,1),bricks_rel_trial(idx_stim,3)] = mk_besideness(STIMS_obj);
                bricks_conn_trial(idx_stim,:) = [bricks' 0];  
            end
            
            learned_adj(bricks(1),bricks(2)) = learned_adj(bricks(1),bricks(2)) + 1;
            learned_adj(bricks(2),bricks(1)) = learned_adj(bricks(2),bricks(1)) + 1;
            
            learned_2adj(bricks(1),bricks(2)) = learned_2adj(bricks(1),bricks(2)) + 1;
            learned_2adj(bricks(2),bricks(1)) = learned_2adj(bricks(2),bricks(1)) + 1;
            
            if correct_trials_all(idx_stim)==0
                mistake_adj(bricks(1),bricks(2)) = mistake_adj(bricks(1),bricks(2)) + 1;
                mistake_adj(bricks(2),bricks(1)) = mistake_adj(bricks(2),bricks(1)) + 1;

                mistake_2adj(bricks(1),bricks(2)) = mistake_2adj(bricks(1),bricks(2)) + 1;
                mistake_2adj(bricks(2),bricks(1)) = mistake_2adj(bricks(2),bricks(1)) + 1;
            end
            
            
        elseif length(bricks)==4
            
            for idx_1BB = 1:3
                
                for idx_2BB = (idx_1BB+1):4
                
                    bricks_absent = setdiff(1:4,[idx_1BB idx_2BB]);
                    
                    PART_noX = STIMS_obj(:,:,1); 
                    PART_noX(PART_noX==bricks_absent(1)) = 0;
                    PART_noX(PART_noX==bricks_absent(2)) = 0;

                    if mk_ontopness(PART_noX) || mk_besideness(PART_noX)
                        learned_adj(idx_1BB,idx_2BB) = learned_adj(idx_1BB,idx_2BB) + 1;
                        learned_adj(idx_2BB,idx_1BB) = learned_adj(idx_2BB,idx_1BB) + 1;
                        
                        learned_4adj(idx_1BB,idx_2BB) = learned_4adj(idx_1BB,idx_2BB) + 1;
                        learned_4adj(idx_2BB,idx_1BB) = learned_4adj(idx_2BB,idx_1BB) + 1;
                        
                        if correct_trials_all(idx_stim)==0
                            mistake_adj(idx_1BB,idx_2BB) = mistake_adj(idx_1BB,idx_2BB) + 1;
                            mistake_adj(idx_2BB,idx_1BB) = mistake_adj(idx_2BB,idx_1BB) + 1;

                            mistake_4adj(idx_1BB,idx_2BB) = mistake_4adj(idx_1BB,idx_2BB) + 1;
                            mistake_4adj(idx_2BB,idx_1BB) = mistake_4adj(idx_2BB,idx_1BB) + 1;
                        end
                        
                    end
                
                end
                
            end
        
        end
        
%         if all(bricks_conn_trial(idx_stim,:)==0)
%            error('something wrong') 
%         end
         
    end    

end