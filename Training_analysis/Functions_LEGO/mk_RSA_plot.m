%% function to make RSA plots
function [] = mk_RSA_plot(all_stim_code,r,SOLUTIONS)         
        
    figure,set(gcf,'color','white')

    n_stims       = length(all_stim_code)+1;

    plot_count = 2;
    for idx_1=1:n_stims
        for idx_2=1:n_stims

            subplot(n_stims,n_stims,plot_count)

            if idx_1==1

                if idx_2<n_stims

                    STIM = SOLUTIONS{all_stim_code(idx_2)};

                    imagesc(STIM+1,[1 10]), set(gca, 'XTickLabel', []), set(gca, 'YTickLabel', [])
%                     colormap(map)

                    plot_count = plot_count+1;
                end

            elseif idx_2==1                                       

                STIM = SOLUTIONS{all_stim_code(idx_1-1)};

                imagesc(STIM+1,[1 10]), set(gca, 'XTickLabel', []), set(gca, 'YTickLabel', [])
%                 colormap(map)

                plot_count = plot_count+1;

            elseif idx_1~=1 && idx_2~=1

                if ~isnan(r(idx_1-1,idx_2-1))
                    if isequal(unique(r),[0 1]')
                        imagesc(r(idx_1-1,idx_2-1),[0 1]), set(gca, 'XTickLabel', []), set(gca, 'YTickLabel', [])
%                         colormap(map)
                    elseif min(min(r))>=0 && max(max(r))<=1
                        imagesc(r(idx_1-1,idx_2-1)*10,[0 10]), set(gca, 'XTickLabel', []), set(gca, 'YTickLabel', [])
%                         colormap(map2)
                    else
                        imagesc(r(idx_1-1,idx_2-1)+2,[1 10]), set(gca, 'XTickLabel', []), set(gca, 'YTickLabel', [])
                    end
                else
                    imagesc(1,[1 10]), set(gca, 'XTickLabel', []), set(gca, 'YTickLabel', [])
                end

                plot_count = plot_count+1;
            end

        end

        fprintf('Stim %d of %d done.\n',idx_1,n_stims-1)

    end

end