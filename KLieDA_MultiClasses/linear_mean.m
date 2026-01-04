%-----------------------------------------------
%           linear mean
%-----------------------------------------------   
function l_m = linear_mean(ml, dim, n)
    avg_m=zeros(dim,dim);
    for i=1:n
        avg_m = avg_m + cell2mat(ml(i));
    end
l_m = avg_m / n;