function ExamCovMNIST(iter_n, trn1, trn2, train_n, tst1, tst2, test_n, dim)

style = {'-r*','-g^','-b+','-y.','-mo'};

for i=1:iter_n
    [alg, acc] = CovLieFisher(trn1,trn2,train_n,tst1,tst2,test_n,dim,28,28);
    sz = size(acc);
    for j=1:sz
        a(j,i)=acc(j);
    end
    alg
    acc
end

hold off
for i=1:sz
    for j=1:iter_n
        plot(j,a(i,j), cell2mat(style(i)));
        hold on
    end
end