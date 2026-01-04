%-----------------------------------------------
%           intrinsic_mean
%-----------------------------------------------  
function in_m = intrinsic_mean(ml, dim, index, n, itr_n, epsilon)
    miu = cell2mat(ml(1,index));
    tuo = 1;
    delta_miu = zeros(dim);
    for j=1:itr_n
        for k=0:n-1
            delta_miu = delta_miu + logm(inv(miu)  * cell2mat(ml(index+k)));
        end
        delta_miu = expm(delta_miu * tuo / n);
        miu = miu*delta_miu;
        if(norm(logm(delta_miu)) < epsilon)
            break;
        end
    end
in_m = miu;