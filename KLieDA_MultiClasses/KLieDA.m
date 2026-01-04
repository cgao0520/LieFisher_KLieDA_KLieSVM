% a is the vector of KLieDA
% km1 is the class 1's mean point projected on a
% km2 is the class 2's mean point projected on a
function [acc, a, km1, km2, covCell] = KLieDA(train1,train2,train_n,test1,test2,test_n,dim,width,height,ker,d)

if(nargin < 11)
    d = 2;
end

tic

t1_n = randperm(size(train1,1));
t2_n = randperm(size(train2,1));

for i=1:train_n
    n=t1_n(i);%ceil(rand*size(train1,1));
    img = reshape(train1(n,:),width,height);
    c = genCov(img,dim);
    train_list1{i} = c;
    covCell{i}=c;
end


for i=1:train_n
    n=t2_n(i);%ceil(rand*size(train2,1));
    img = reshape(train2(n,:),width,height);
    c = genCov(img,dim);
    train_list2{i} = c;
    covCell{train_n+i}=c;
end

in_m1 = CovMean(covCell,dim,1,train_n);
in_m2 = CovMean(covCell,dim,train_n+1,train_n);
%in_mall = CovMean(covCell,dim,1,train_n*2);


M1=[];
M2=[];

%ker = 'tanh';
sig = 1000000000;
if(strcmp(ker,'polym'))
    sig = d;
end

for j=1:train_n*2
    sum = 0;
    for i=1:train_n
        sum = sum + kernel(ker, cell2mat(covCell(j)), cell2mat(covCell(i)), sig);
    end
    sum = sum / train_n;
    M1(j) = sum;
end

for j=1:train_n*2
    sum = 0;
    for i=1:train_n
        sum = sum + kernel(ker, cell2mat(covCell(j)), cell2mat(covCell(train_n+i)), sig);
    end
    sum = sum / train_n;
    M2(j) = sum;
end

%size(M1)
%size(M2)
%return;

Mt = M1-M2;
M = Mt*Mt.';

K1=[];
K2=[];

for l=1:train_n*2
    for m=1:train_n
        K1(l,m) = kernel(ker, cell2mat(covCell(l)), cell2mat(covCell(m)), sig);
    end
end

%size(K1)

for l=1:train_n*2
    for m=1:train_n
        K2(l,m) = kernel(ker, cell2mat(covCell(l)), cell2mat(covCell(train_n+m)), sig);
    end
end

%size(K2)

N = K1*(eye(train_n)-ones(train_n)/train_n)*K1.';
%size(N)
%return;

N = N + K2*(eye(train_n)-ones(train_n)/train_n)*K2.';

a = pinv(N)*(M1-M2).';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

km1 = 0;

for j=1:train_n*2
    km1 = km1 + a(j)*kernel(ker, cell2mat(covCell(j)), in_m1, sig);
end

km2 = 0;

for j=1:train_n*2
    km2 = km2 + a(j)*kernel(ker, cell2mat(covCell(j)), in_m2, sig);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

c_n = 0;
e_n = 0;

t1_n = randperm(size(test1,1));
t2_n = randperm(size(test2,1));

for i=1:test_n
    proj = 0;
    for j=1:train_n*2
        img = reshape(test1(t1_n(i),:),width,height);
        c = genCov(img,dim);
        proj = proj + a(j)*kernel(ker, cell2mat(covCell(j)), c, sig);
    end
    l1 = abs(km1-proj);
    l2 = abs(km2-proj);
    if(l1 < l2)
        c_n = c_n + 1;
    else
        e_n = e_n + 1;
    end
end


for i=1:test_n
    proj = 0;
    for j=1:train_n*2
        img = reshape(test2(t2_n(i),:),width,height);
        c = genCov(img,dim);
        proj = proj + a(j)*kernel(ker, cell2mat(covCell(j)), c, sig);
    end
    l1 = abs(km1-proj);
    l2 = abs(km2-proj);
    if(l2 < l1)
        c_n = c_n + 1;
    else
        e_n = e_n + 1;
    end
end

acc = c_n/(c_n+e_n);
s = sprintf('\tKLieDA: accuracy is %0.2f%%',c_n/(c_n+e_n)*100);
disp (s);


toc
