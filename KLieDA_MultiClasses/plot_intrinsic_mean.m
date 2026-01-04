%-----------------------------------------------
%           intrinsic_mean
%-----------------------------------------------  
function in_m = plot_intrinsic_mean(ml, dim, index, n, itr_n, epsilon)
    miu = cell2mat(ml(1,index));
    tuo = 1;
    y=[];
    x=[];
    delta_miu = zeros(dim);
    for j=1:itr_n
        x=[x, j];
        for k=0:n-1
            delta_miu = delta_miu + logm(inv(miu)  * cell2mat(ml(index+k)));
        end
        delta_miu = expm(delta_miu * tuo / n);
        miu_new = miu*delta_miu;
        y = [y, norm(logm(inv(miu_new)*miu))];
        miu = miu_new;
        %{
        if(norm(logm(delta_miu)) < epsilon)
            break;
        end
        %}
    end
in_m = miu;
plot(x,y,'r*-');