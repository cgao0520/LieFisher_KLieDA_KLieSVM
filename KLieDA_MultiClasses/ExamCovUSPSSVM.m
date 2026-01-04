function ExamCovUSPSSVM(iter_n, trn1, trn2, train_n, tst1, tst2, test_n, dim,w,h)

style = {'-r*','-g^','-b+','-y.','-mo'};
acc=[];
for i=1:iter_n
    [aa] = CovSVM(trn1,trn2,train_n,train_n,tst1,tst2,test_n,test_n,dim,w,h,'rbf');
    acc(1,i) = aa;
    [aa] = CovSVM(trn1,trn2,train_n,train_n,tst1,tst2,test_n,test_n,dim,w,h,'polym');
    acc(2,i) = aa;
    [aa] = CovSVM(trn1,trn2,train_n,train_n,tst1,tst2,test_n,test_n,dim,w,h,'linear');
    acc(3,i) = aa;
    [aa] = CovSVM(trn1,trn2,train_n,train_n,tst1,tst2,test_n,test_n,dim,w,h,'tanh');
    acc(4,i) = aa;
    [aa] = CovSVM(trn1,trn2,train_n,train_n,tst1,tst2,test_n,test_n,dim,w,h,'sig');
    acc(5,i) = aa;
end

hold off
for i=1:size(acc,1)
        plot(1:iter_n, acc(i,:), cell2mat(style(i)));
        accy(i)=mean(acc(i,:));
        hold on
end

l1=sprintf('rbf: %0.2f%%',accy(1));
l2=sprintf('poly: %0.2f%%',accy(2));
l3=sprintf('linear: %0.2f%%',accy(3));
l4=sprintf('tanh: %0.2f%%',accy(4));
l5=sprintf('sig: %0.2f%%',accy(5));

legend(l1,l2,l3,l4,l5);
hold off