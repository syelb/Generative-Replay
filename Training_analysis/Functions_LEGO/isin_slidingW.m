% Is shape of Object1_input in shape of Object2_input?
function [jo, remain] = isin_slidingW(Object1_input,Object2_input,n_grid)

if nargin<3
    n_grid = 6;
end

if ~isequal(size(Object1_input),[n_grid,n_grid]) % if Object1_input is not in matrix form
    TEMP                = zeros(n_grid);
    TEMP(Object1_input) = 1;
    Object1_input       = TEMP;
end

if ~isequal(size(Object2_input),[n_grid,n_grid]) % if Object1_input is not in matrix form
    TEMP                = zeros(n_grid);
    TEMP(Object2_input) = 1;
    Object2_input       = TEMP;
end


jo     = false;
remain = [];

all_over = false;

while ~jo && ~all_over

    for h=1:size(Object2_input,3)

        for i=1:size(Object1_input,3)

            Object1 = mk_crop(Object1_input(:,:,i));
            elements_obj1 = unique(Object1(Object1~=0));
            
            Object2 = Object2_input(:,:,h);
            Object2(~ismember(Object2,elements_obj1)) = 0;

            size1 = size(Object1); size2 = size(Object2);

            if all(size1<=size2)

                for y_transl = 0:(size2(1)-size1(1))
                    for x_transl = 0:(size2(2)-size1(2))
                        if isequal(Object2((1+y_transl):(size1(1)+y_transl),(1+x_transl):(size1(2)+x_transl)),Object1)
                            jo = true;
                            remain = Object2;
                            remain((1+y_transl):(size1(1)+y_transl),(1+x_transl):(size1(2)+x_transl)) = 0; % careful that only takes first remain!
                        end
                    end
                end

            end

        end
    end
    
    all_over = true;

end


end
