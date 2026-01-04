function [acc] = CovSVM(train1,train2,train_n1,train_n2,test1,test2,test_n1,test_n2,dim,width,height,ker,d)

if(nargin < 13)
    d = 2;
end

tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TRAIN

sig = 1000000000;
if(strcmp(ker,'polym'))
    sig = d;
end

t1_n = randperm(size(train1,1));
t2_n = randperm(size(train2,1));

for i=1:train_n1
    n=t1_n(i);
    img = reshape(train1(n,:),width,height);
    c = genCov(img,dim);
    %train_list1{i} = c;
    covCell{i}=c;
end

for i=1:train_n2
    n=t2_n(i);
    img = reshape(train2(n,:),width,height);
    c = genCov(img,dim);
    %train_list2{i} = c;
    covCell{train_n1+i}=c;
end

Ktrn=[];
for i=1:train_n1+train_n2
    ci = cell2mat(covCell(i));
    for j=i:train_n1+train_n2
        cj = cell2mat(covCell(j));
        Ktrn(i,j) = kernel(ker,ci,cj,sig);
        if(j ~= i)
            Ktrn(j,i) = Ktrn(i,j);
        end
    end
end


l1 = ones(train_n1,1);
l2 = ones(train_n2,1)-2;
labl = [l1;l2];

Ktrn = [(1:train_n1+train_n2)',Ktrn];

model = svmtrain(labl, Ktrn, '-t 4');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TEST

%clear covCell;

t1_n = randperm(size(test1,1));
t2_n = randperm(size(test2,1));

for i=1:test_n1
    n=t1_n(i);
    img = reshape(test1(n,:),width,height);
    c = genCov(img,dim);
    %test_list1{i} = c;
    tcovCell{i}=c;
end

for i=1:test_n2
    n=t2_n(i);
    img = reshape(test2(n,:),width,height);
    c = genCov(img,dim);
    %test_list2{i} = c;
    tcovCell{test_n1+i}=c;
end

Ktst=[];
for i=1:test_n1+test_n2
    ci = cell2mat(tcovCell(i));
    for j=1:train_n1+train_n2
        cj = cell2mat(covCell(j));
        Ktst(i,j) = kernel(ker,ci,cj,sig);
    end
end

l1 = ones(test_n1,1);
l2 = ones(test_n2,1)-2;
tlabl = [l1;l2];

Ktst = [(1:test_n1+test_n2)',Ktst];

[predict_label_P1, accuracy_P1, dec_values_P1] = svmpredict(tlabl, Ktst, model);
acc = accuracy_P1(1);
toc