% Make pairwise sequenceness for rest and different phases during task
% GLM approach

function [] = ana_ErrorTrials_train()

    do_plot = true;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% SETUP THE MATLAB PATHS and variables
    % Paths added for this repo: training data lives in MEG_Behav/Training_MEG
    this_dir          = fileparts(mfilename('fullpath'));
    repo_root         = fileparts(this_dir);
    scan_result_path  = fullfile(repo_root,'MEG_Behav','Training_MEG');
    behav_result_path = scan_result_path;
    addpath(fullfile(this_dir,'Functions_LEGO'));   % helpers sent by Philipp
    addpath(fullfile(repo_root,'MEG_code'));         % shared helpers (mk_besideness, mk_crop, ...)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% some relevant variables
    subject = dir(fullfile(scan_result_path,'s*'));
    subject = {subject.name};
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    trial_max = 560;
         
    col   = {[0, 0.4470, 0.7410], ...       % blue
             [0.4940, 0.1840, 0.5560], ...  % purple
             [0.4660, 0.6740, 0.1880], ...  % green
             [0.6350, 0.0780, 0.1840], ...  % red
             [0.3010, 0.7450, 0.9330], ...  % cyan
             [0.9290, 0.6940, 0.1250], ...  % yellow
             [0.0000, 0.2600, 0.1500], ...  % 'british racing green'
             [0.8500, 0.3250, 0.0980], ...  % orange
             [0, 0, 0], ...                 % black
             [0.6, 0.6, 0.6]};              % grey          
    
    %% now obtain different sequenceness                    
    Corr_Trials = nan(length(subject),trial_max);
    Pred_Choice = nan(length(subject),trial_max);

    for idx_sub = 1:length(subject)   

        behav_folder   = fullfile(behav_result_path,(subject{idx_sub}));

        %%%%% get biased brick info %%%%%
        [bricks_conn,bricks_rel,bricks_conn_trial,bricks_rel_trial,~,~,...
         correct_trials_all,rt_all,stims_all,STIMS_all,relation_catch_all,pred_choice,...
         learned_adj,learned_2adj,learned_3adj,learned_4adj,...
         mistake_adj,mistake_2adj,mistake_3adj,mistake_4adj] = mk_bricks_sub_train(behav_folder); % obtain brick info of subject based on observed stims
     
        Corr_Trials(idx_sub,1:length(correct_trials_all)) = correct_trials_all;
%         
        Pred_Choice(idx_sub,1:length(pred_choice)) = pred_choice;
        
        fprintf('Subject %d of %d done.\n',idx_sub,length(subject))
        fprintf('Length data %d \n',length(correct_trials_all))
        

    end 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% do stats and plot stuff  
    if do_plot   

        % make plot of prop corr and RT over time
        % this is VERY quick and dirty - clean up!!    
        Corr_perSess        = nan(20,1,trial_max);
        Corr_perSess(:,1,:) = Corr_Trials;  
        
        Corr_perSess_noConn                  = nan(20,1,trial_max);
        Corr_perSess_noConn(:,1,:)           = Corr_Trials;
        Corr_perSess_noConn(Pred_Choice~=71) = NaN;
        
        Corr_perSess_yesConn                  = nan(20,1,trial_max);
        Corr_perSess_yesConn(:,1,:)           = Corr_Trials;
        Corr_perSess_yesConn(Pred_Choice==71) = NaN;
        
        Corr_perSess           = squeeze(mk_MeanSess(Corr_perSess,70));
        Corr_perSess_noConn    = squeeze(mk_MeanSess(Corr_perSess_noConn,70));
        Corr_perSess_yesConn   = squeeze(mk_MeanSess(Corr_perSess_yesConn,70));
        
        Corr_perSess         = Replace_NaNs_PS(Corr_perSess);
        Corr_perSess_noConn  = Replace_NaNs_PS(Corr_perSess_noConn);
        Corr_perSess_yesConn = Replace_NaNs_PS(Corr_perSess_yesConn);

        % Plot accuracy first day:
        figure, set(gcf,'color','white'), hold on        
        n_time = size(Corr_perSess,2);

        mm = nanmean(Corr_perSess,1);
        ss = nanstd(Corr_perSess,0,1)./sqrt(size(Corr_perSess,1));        
        plot(mm,'Color',col{1})
        fill([1:n_time, fliplr(1:n_time)],[mm+ss, fliplr(mm-ss)], col{1},'EdgeAlpha',0,'FaceAlpha',0.2);
        
        mm = nanmean(Corr_perSess_noConn,1);
        ss = nanstd(Corr_perSess_noConn,0,1)./sqrt(size(Corr_perSess_noConn,1));        
        plot(mm,'Color',col{2})
        fill([1:n_time, fliplr(1:n_time)],[mm+ss, fliplr(mm-ss)], col{2},'EdgeAlpha',0,'FaceAlpha',0.2);
        
        mm = nanmean(Corr_perSess_yesConn,1);
        ss = nanstd(Corr_perSess_yesConn,0,1)./sqrt(size(Corr_perSess_yesConn,1));        
        plot(mm,'Color',col{3})
        fill([1:n_time, fliplr(1:n_time)],[mm+ss, fliplr(mm-ss)], col{3},'EdgeAlpha',0,'FaceAlpha',0.2);
        
        ylabel('Proportion correct')
        xlabel('Training sessions')
        title('Performance Training')
        xlim([0.5 7.5])
        set(gca, 'XTick', [1:n_time])
        ylim([0.3,1])
        set(gca, 'YTick', [0.3:0.1:1])
        hold off

    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end