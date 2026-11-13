 % test whether object 2 contains form of object 1
 
 function [jo, remain] = isin(form1,form2)
 
 jo = false;  % yes/no
 remain = []; % ???
 
%  form1 = [6 12 18 0 0 0 0];
%  form1 = [6 5 11 0 0 0 0];
%  form1 = [6 5 12 0 0 0 0];
%  form1 = [5 11 12 17 0 0 0 0];
%  form2 = [5 11 17 18 23 10 0 0];
 
 FORM1 = zeros(6); FORM1(form1(form1~=0)) = 1; FORM1 = FORM1(sum(FORM1,2)~=0,sum(FORM1,1)~=0);
 FORM2 = zeros(6); FORM2(form2(form2~=0)) = 1; FORM2 = FORM2(sum(FORM2,2)~=0,sum(FORM2,1)~=0);
 
 
 if all(size(FORM1)<=size(FORM2))
     
     slide = size(FORM2)-size(FORM1);
     
     for dim_x = 0:slide(2)
         for dim_y = 0:slide(1)
%              FORM2(1+dim_y:size(FORM1,1)+dim_y,1+dim_x:size(FORM1,2)+dim_x)
             if isequal(FORM1,FORM2(1+dim_y:size(FORM1,1)+dim_y,1+dim_x:size(FORM1,2)+dim_x))
                 jo = true;
                 FORM2_remain = FORM2; FORM2_remain(1+dim_y:size(FORM1,1)+dim_y,1+dim_x:size(FORM1,2)+dim_x) = 0;
                 
                 FORM2_remain = FORM2_remain(sum(FORM2_remain,2)~=0,sum(FORM2_remain,1)~=0);
                 FORM2_remain = [FORM2_remain zeros(size(FORM2_remain,1),6-size(FORM2_remain,2))];
                 FORM2_remain = [zeros(6-size(FORM2_remain,1),size(FORM2_remain,2)); FORM2_remain];
                 
                 remain = find(FORM2_remain)';
                 
             end
         end
     end
     
 end
 
 
 
%  mk_solutions_onestep(find(FORM2_remain))
 
 end