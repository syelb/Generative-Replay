
function data = Replace_NaNs_PS(data,mk_direction)

if nargin<2
    mk_direction = 2; %do along columns
end

for idx_dataPoint=1:size(data,mk_direction)
    data(isnan(data(:,idx_dataPoint)),idx_dataPoint) = nanmean(data(:,idx_dataPoint));
end