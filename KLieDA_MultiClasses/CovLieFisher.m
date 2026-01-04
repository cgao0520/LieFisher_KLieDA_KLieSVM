%
function [alg,acc,errsmpls1,errsmpls2] = CovLieFisher(train1,train2,train_n,test1,test2,test_n,dim,width,height,bReverse)
tic

if(nargin<10)
    bReverse = 1;
end
%dim = 8;
max_its = 50;
epsilon = 0.001;
index = 0;

t1_n = randperm(size(train1,1));
t2_n = randperm(size(train2,1));

for i=1:train_n
    n=t1_n(i);%ceil(rand*size(train1,1));
    img = reshape(train1(n,:),width,height);
    %if(bReverse)
    %    img = img';
    %end
    c = genCov(img);
    train_list1{i} = c;
    covCell{i}=c;
end


for i=1:train_n
    n=t2_n(i);%ceil(rand*size(train2,1));
    img = reshape(train2(n,:),width,height);
    %if(bReverse)
    %    img = img';
    %end
    c = genCov(img);
    train_list2{i} = c;
    covCell{train_n+i}=c;
end

%innn = plot_intrinsic_mean(covCell,dim,1,train_n,max_its,epsilon);

%???
%in_m1 = intrinsic_mean(covCell,dim,1,train_n,max_its,epsilon);%??????
in_m1 = CovMean(covCell,dim,1,train_n);
%in_m2 = intrinsic_mean(covCell,dim,train_n+1,train_n,max_its,epsilon);%??????
in_m2 = CovMean(covCell,dim,train_n+1,train_n);
%in_mall = intrinsic_mean(covCell,dim,1,train_n*2,max_its,epsilon);%?????
in_mall = CovMean(covCell,dim,1,train_n*2);

%???
for i=1:train_n
    train_list1_la{i} = logm(cell2mat(train_list1(1,i)));
    train_list2_la{i} = logm(cell2mat(train_list2(1,i)));
end

l_m1 = linear_mean(train_list1_la,dim,train_n);%??????
l_m2 = linear_mean(train_list2_la,dim,train_n);%??????

for i=1:train_n
    train_listall_la{i} = logm(cell2mat(train_list1(1,i)));
    train_listall_la{train_n+i} = logm(cell2mat(train_list2(1,i)));
end
l_mall = linear_mean(train_listall_la,dim,train_n*2);%?????


%---------------Lie-Mean
t1_n = randperm(size(test1,1));
t2_n = randperm(size(test2,1));

c_n = 0;
e_n = 0;
for i=1:test_n
    n=t1_n(i);%ceil(rand*size(test1,1));
    img = reshape(test1(n,:),width,height);
    c = genCov(img);
    test1_list{i} = c;
    n1 = norm(logm(inv(in_m1)*c));
    n2 = norm(logm(inv(in_m2)*c));
    if(n1 <= n2)
        c_n = c_n + 1;
    else
        e_n = e_n + 1;
    end
end

for i=1:test_n
    n=t2_n(i);%ceil(rand*size(test2,1));
    img = reshape(test2(n,:),width,height);
    c = genCov(img);
    test2_list{i} = c;
    n1 = norm(logm(inv(in_m1)*c));
    n2 = norm(logm(inv(in_m2)*c));
    if(n1 > n2)
        c_n = c_n + 1;
    else
        e_n = e_n + 1;
    end
end

acy = c_n/(c_n+e_n)*100;

s = sprintf('\tLie-Mean: accuracy is %0.2f%%', acy);
disp (s);

index = index + 1;
alg{index} = 'LieMean';
acc(index) = acy;

%---------------MatFisher
mean_lG1 = linear_mean(train_list1, dim, train_n);
mean_lG2 = linear_mean(train_list2, dim, train_n);
mean_lGAll = linear_mean(covCell, dim, train_n*2);
inv_mean_lGAll = inv(mean_lGAll);
Sb_l = (mean_lG1 - mean_lG2)*(mean_lG1 - mean_lG2)';
Sw_l = zeros(dim,dim);
for i=1:train_n
    x_1_l = cell2mat(train_list1(i))-mean_lG1;
    x_2_l = cell2mat(train_list2(i))-mean_lG2;
    Sw_l = Sw_l + x_1_l * x_1_l';
    Sw_l = Sw_l + x_2_l * x_2_l';
end
w_l = pinv(Sw_l)*(mean_lG1-mean_lG2);

%calculate the mean of projected samples
miu_1_l = mean_l(train_list1, dim, train_n, w_l');
miu_2_l = mean_l(train_list2, dim, train_n, w_l');

c_n=0;
e_n=0;
errsmpls1=[];
errsmpls2=[];
for i=1:test_n
    T=cell2mat(test1_list(i));
    ptx = w_l' * T;
    norm_1=norm(ptx-miu_1_l);
    norm_2=norm(ptx-miu_2_l);
    
    if norm_1 <= norm_2
        c_n=c_n+1;
    else
        e_n=e_n+1;
        %%%%%%
        %errsmpls1=[errsmpls1;t1_n(i)];
    end
    
    T=cell2mat(test2_list(i));
    ptx = w_l' * T;
    norm_1=norm(ptx-miu_1_l);
    norm_2=norm(ptx-miu_2_l);
    
    if norm_2 <= norm_1
        c_n=c_n+1;
    else
        e_n=e_n+1;
        %errsmpls2=[errsmpls2;t2_n(i)];
    end
end

acy = c_n/(c_n+e_n)*100;

s = sprintf('\tMatFisher: accuracy=%.2f%%', acy);
disp(s);

index = index + 1;
alg{index} = 'MatFisher';
acc(index) = acy;

%---------------Lie-Fisher
%train_list1_la
%l_m1
%return;
Sw=zeros(dim,dim);
for i=1:train_n
    x = cell2mat(train_list1_la(i)) - l_m1;
    Sw = Sw + x*x';
    x = cell2mat(train_list2_la(i)) - l_m2;
    Sw = Sw + x*x';
end

v = inv(Sw)*(l_m1-l_m2);

p_l_m1 = v' * l_m1;
p_l_m2 = v' * l_m2;

c_n = 0;
e_n = 0;

for i=1:test_n
    x = logm(cell2mat(test1_list(i)));
    n1 = norm(v'*x - p_l_m1);
    n2 = norm(v'*x - p_l_m2);
    if(n1 <= n2)
        c_n = c_n + 1;
    else
        e_n = e_n + 1;
    end
end


for i=1:test_n
    x = logm(cell2mat(test2_list(i)));
    n1 = norm(v'*x - p_l_m1);
    n2 = norm(v'*x - p_l_m2);
    if(n2 <= n1)
        c_n = c_n + 1;
    else
        e_n = e_n + 1;
    end
end

acy = c_n/(c_n+e_n)*100;

s = sprintf('\tLie-Fisher: accuracy is %0.2f%%', acy);
disp (s);

index = index + 1;
alg{index} = 'Lie-Fisher';
acc(index) = acy;

%------------------Lie-Fisher(2)

Sw = zeros(dim,dim);
inv_in_m1 = inv(in_m1);
inv_in_m2 = inv(in_m2);
for i=1:train_n
    x = logm(inv_in_m1*cell2mat(covCell(i)));
    Sw = Sw + x*x';
end
for i=1:train_n
    x = logm(inv_in_m2*cell2mat(covCell(train_n+i)));
    Sw = Sw + x*x';
end

v = inv(Sw) * logm(inv_in_m1*in_m2);
in_m1_la = logm(in_m1);
in_m2_la = logm(in_m2);
c_n = 0;
e_n = 0;
for i=1:test_n
    %t = inv(expm(v'*logm(cell2mat(test1_list(i)))));
    %n1 = norm(logm(t*expm(v'*in_m1_la)));
    %n2 = norm(logm(t*expm(v'*in_m2_la)));
    t = expm(v'*logm(cell2mat(test1_list(i))));
    n1 = CovDistance(t, expm(v'*in_m1_la));
    n2 = CovDistance(t, expm(v'*in_m2_la));
    if(n1<=n2)
        c_n = c_n + 1;
    else
        e_n = e_n + 1;
        errsmpls1=[errsmpls1;t1_n(i)];
    end
end
for i=1:test_n
    %t = inv(expm(v'*logm(cell2mat(test2_list(i)))));
    %n1 = norm(logm(t*expm(v'*in_m1_la)));
    %n2 = norm(logm(t*expm(v'*in_m2_la)));
    t = expm(v'*logm(cell2mat(test2_list(i))));
    n1 = CovDistance(t, expm(v'*in_m1_la));
    n2 = CovDistance(t, expm(v'*in_m2_la));
    if(n2<=n1)
        c_n = c_n + 1;
    else
        e_n = e_n + 1;
        errsmpls2=[errsmpls2;t2_n(i)];
    end
end

acy = c_n/(c_n+e_n)*100;

s = sprintf('\tLie-Fisher(2): accuracy is %0.2f%%', acy);
disp (s);

index = index + 1;
alg{index} = 'Lie-Fisher(2)';
acc(index) = acy;

toc

%-----------------------------------------------
%           mean_l
%-----------------------------------------------   
function linear_m=mean_l(ml, dim, n, w)
    avg_m=zeros(dim,dim);
    for i=1:n
        avg_m = avg_m + w * cell2mat(ml(i));
    end
linear_m = avg_m / n;