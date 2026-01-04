function ExamCovKLieDASVM_POLYM(max_d, trn1, trn2, train_n, tst1, tst2, test_n, dim,w,h)

style = {'-r*','-g^','-b+','-y.','-mo'};
acc=[];
i=1;
for d=2:max_d
    %[aa, a, km1, km2, covCell] = KLieDA(trn1,trn2,train_n,tst1,tst2,test_n,dim,w,h,'rbf');
    %acc(1,i) = aa;
    [aa, a, km1, km2, covCell] = KLieDA(trn1,trn2,train_n,tst1,tst2,test_n,dim,w,h,'polym',d);
    acc(1,i) = aa;
    [aa] = CovSVM(trn1,trn2,train_n,train_n,tst1,tst2,test_n,test_n,dim,w,h,'polym',d);
    acc(2,i) = aa/100;
    %[aa, a, km1, km2, covCell] = KLieDA(trn1,trn2,train_n,tst1,tst2,test_n,dim,w,h,'linear');
    %acc(3,i) = aa;
    %[aa, a, km1, km2, covCell] = KLieDA(trn1,trn2,train_n,tst1,tst2,test_n,dim,w,h,'tanh');
    %acc(4,i) = aa;
    %[aa, a, km1, km2, covCell] = KLieDA(trn1,trn2,train_n,tst1,tst2,test_n,dim,w,h,'sig');
    %acc(5,i) = aa;
    i=i+1;
end

hold off
for i=1:size(acc,1)
        plot(2:max_d, acc(i,:), cell2mat(style(i)));
        %accy(i)=mean(acc(i,:));
        hold on
end

l1=sprintf('KLieDA');
l2=sprintf('SVM');

legend(l1,l2);
hold off