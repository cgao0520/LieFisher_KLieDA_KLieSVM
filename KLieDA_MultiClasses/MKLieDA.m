% a is the vector of KLieDA
% km1 is the class 1's mean point projected on a
% km2 is the class 2's mean point projected on a
function [acc, a, km1, km2, covCell] = MKLieDA(train1,train2,train3,train4,train5,train6,train7,train8,train9,train0,train_n,test1,test2,test3,test4,test5,test6,test7,test8,test9,test0,test_n,dim,width,height,ker,d)

if(nargin < 11)
    d = 2;
end

tic

t1_n = randperm(size(train1,1));
t2_n = randperm(size(train2,1));
t3_n = randperm(size(train3,1));
t4_n = randperm(size(train4,1));
t5_n = randperm(size(train5,1));
t6_n = randperm(size(train6,1));
t7_n = randperm(size(train7,1));
t8_n = randperm(size(train8,1));
t9_n = randperm(size(train9,1));
t0_n = randperm(size(train0,1));

%%%1
for i=1:train_n
    n=t1_n(i);
    img = reshape(train1(n,:),width,height);
    c = genCov(img,dim);
    train_list1{i} = c;
    covCell{i}=c;
end
%%%2
for i=1:train_n
    n=t2_n(i);
    img = reshape(train2(n,:),width,height);
    c = genCov(img,dim);
    train_list2{i} = c;
    covCell{train_n+i}=c;
end
%%%3
for i=1:train_n
    n=t3_n(i);
    img = reshape(train3(n,:),width,height);
    c = genCov(img,dim);
    train_list3{i} = c;
    covCell{train_n*2+i}=c;
end
%%%4
for i=1:train_n
    n=t4_n(i);
    img = reshape(train4(n,:),width,height);
    c = genCov(img,dim);
    train_list4{i} = c;
    covCell{train_n*3+i}=c;
end
%%%5
for i=1:train_n
    n=t5_n(i);
    img = reshape(train5(n,:),width,height);
    c = genCov(img,dim);
    train_list5{i} = c;
    covCell{train_n*4+i}=c;
end
%%%6
for i=1:train_n
    n=t6_n(i);
    img = reshape(train6(n,:),width,height);
    c = genCov(img,dim);
    train_list6{i} = c;
    covCell{train_n*5+i}=c;
end
%%%7
for i=1:train_n
    n=t7_n(i);
    img = reshape(train7(n,:),width,height);
    c = genCov(img,dim);
    train_list7{i} = c;
    covCell{train_n*6+i}=c;
end
%%%8
for i=1:train_n
    n=t8_n(i);
    img = reshape(train8(n,:),width,height);
    c = genCov(img,dim);
    train_list8{i} = c;
    covCell{train_n*7+i}=c;
end
%%%9
for i=1:train_n
    n=t9_n(i);
    img = reshape(train9(n,:),width,height);
    c = genCov(img,dim);
    train_list9{i} = c;
    covCell{train_n*8+i}=c;
end
%%%0
for i=1:train_n
    n=t0_n(i);
    img = reshape(train0(n,:),width,height);
    c = genCov(img,dim);
    train_list0{i} = c;
    covCell{train_n*9+i}=c;
end

for i=1:10
    log_eu_mean{i} = CovMean(covCell,dim,(i-1)*train_n+1,train_n);
end 
log_eu_all_mean = CovMean(covCell,dim,1,train_n*10);

%in_m1 = CovMean(covCell,dim,1,train_n);
%in_m2 = CovMean(covCell,dim,train_n+1,train_n);
%in_mall = CovMean(covCell,dim,1,train_n*2);



Mi=[];
Mm=[];
%M2=[];

%ker = 'tanh';
sig = 1000000000;
if(strcmp(ker,'polym'))
    sig = d;
end

%%%Mm
for j=1:train_n*10
    sum = 0;
    for i=1:train_n*10
        sum = sum + kernel(ker, cell2mat(covCell(j)), cell2mat(covCell(i)), sig);
    end
    sum = sum / (train_n*train_n);
    Mm(j) = sum;
end

%%%Mi
for kk=1:10
    for j=1:train_n*10
        sum = 0;
        for i=1:train_n
            sum = sum + kernel(ker, cell2mat(covCell(j)), cell2mat(covCell(train_n*(kk-1)+i)), sig);
        end
        sum = sum / train_n;
        Mi(kk,j) = sum;
    end
end

M = 0;
for i=1:10
    Mt = Mi(i,:) - Mm;
    Mt = Mt.';
    M = M + train_n*Mt*Mt.';
end
%disp('adfadf');
%size(M)


Ki=[];
%K2=[];

for kk=1:10
    for l=1:train_n*10
        for m=1:train_n
            Ki(kk,l,m) = kernel(ker, cell2mat(covCell(l)), cell2mat(covCell(train_n*(kk-1)+m)), sig);
        end
    end
end

%%%N
N = zeros(train_n*10,train_n*10);
for kk=1:10
    KKK=reshape(Ki(kk,:,:),train_n*10,train_n);
    N = N + KKK*(eye(train_n)-ones(train_n)/train_n)*KKK.';
end

[V,D]=eig(pinv(N) * M);
a = V(:,1);

%a = pinv(N)*(Mi(1,:)-Mi(2,:)).';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

kmi = [];
for kk=1:10
    kmi(kk)=0;
    for j=1:train_n*10
        kmi(kk) = kmi(kk) + a(j)*kernel(ker, cell2mat(covCell(j)), cell2mat(log_eu_mean(kk)), sig);
    end
end
kmi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%test%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

c_n = 0;
e_n = 0;

t1_n = randperm(size(test1,1));
t2_n = randperm(size(test2,1));
t3_n = randperm(size(test3,1));
t4_n = randperm(size(test4,1));
t5_n = randperm(size(test5,1));
t6_n = randperm(size(test6,1));
t7_n = randperm(size(test7,1));
t8_n = randperm(size(test8,1));
t9_n = randperm(size(test9,1));
t0_n = randperm(size(test0,1));

%%%1
for i=1:test_n
    proj = 0;
    for j=1:train_n*10
        img = reshape(test1(t1_n(i),:),width,height);
        c = genCov(img,dim);
        proj = proj + a(j)*kernel(ker, cell2mat(covCell(j)), c, sig);
    end
    min_d = inf;
    nearest_index = -1;
    for kk=1:10
        dist = abs(kmi(kk)-proj);
        if(min_d > dist)
            min_d = dist;
            nearest_index = kk;
        end
    end
    if(nearest_index == 1)
        c_n = c_n + 1;
    else
        e_n = e_n + 1;
    end
end

%%%2
for i=1:test_n
    proj = 0;
    for j=1:train_n*10
        img = reshape(test2(t2_n(i),:),width,height);
        c = genCov(img,dim);
        proj = proj + a(j)*kernel(ker, cell2mat(covCell(j)), c, sig);
    end
    min_d = inf;
    nearest_index = -1;
    for kk=1:10
        dist = abs(kmi(kk)-proj);
        if(min_d > dist)
            min_d = dist;
            nearest_index = kk;
        end
    end
    if(nearest_index == 2)
        c_n = c_n + 1;
    else
        e_n = e_n + 1;
    end
end

acc = c_n/(c_n+e_n);
s = sprintf('\tKLieDA: accuracy is %0.2f%%',c_n/(c_n+e_n)*100);
disp (s);


toc
