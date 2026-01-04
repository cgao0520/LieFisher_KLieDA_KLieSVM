function detectface(testpic,faces,nonfaces,width,height,train_n,dim)
tic

%dim = 8;
max_its = 500;
epsilon = 0.001;

t1_n = randperm(size(faces,1));
t2_n = randperm(size(nonfaces,1));

for i=1:train_n
    n=t1_n(i);%ceil(rand*size(train1,1));
    img = reshape(faces(n,:),width,height);
    c = genCov(img,dim);
    train_list1{i} = c;
    covCell{i}=c;
end


for i=1:train_n
    n=t2_n(i);%ceil(rand*size(train2,1));
    img = reshape(nonfaces(n,:),width,height);
    c = genCov(img,dim);
    train_list2{i} = c;
    covCell{train_n+i}=c;
end

%intrinsic mean
in_m1 = intrinsic_mean(covCell,dim,1,train_n,max_its,epsilon);
in_m2 = intrinsic_mean(covCell,dim,train_n+1,train_n,max_its,epsilon);
in_mall = intrinsic_mean(covCell,dim,1,train_n*2,max_its,epsilon);

%lie algebra
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

%{
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

s = sprintf('\tLie-Mean: accuracy is %0.2f%%',c_n/(c_n+e_n)*100);
disp (s);
%}

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

if(length(size(testpic)) > 2)
    testpic = rgb2gray(testpic);
end
[row, col] = size(testpic);
step = 5;
ss = 4;
imshow(testpic);
hold on;

for i=1:step:row-step*ss
    for j=1:step:col-step*ss
        subimg = getSubImage(testpic,i,j,step*ss,step*ss);
        %imshow(subimg)
        c = genCov(subimg,dim);
        x = logm(c);
        n1 = norm(v'*x - p_l_m1);
        n2 = norm(v'*x - p_l_m2);
        if(n1 <= n2)
            c_n = c_n + 1;% is a face!
            xx = [j,j+step*ss,j+step*ss,j,j];
            yy = [i,i,i+step*ss,i+step*ss,i];
            line(xx,yy);
            hold on;
        else
            e_n = e_n + 1;% not a face!!
        end
    end
end

hold off;

s = sprintf('\tLie-Fisher: faces is %d(%d/%d)',c_n,c_n,c_n+e_n);
disp (s);
%{
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
    t = inv(expm(v'*logm(cell2mat(test1_list(i)))));
    n1 = norm(logm(t*expm(v'*in_m1_la)));
    n2 = norm(logm(t*expm(v'*in_m2_la)));
    if(n1<=n2)
        c_n = c_n + 1;
    else
        e_n = e_n + 1;
    end
end
for i=1:test_n
    t = inv(expm(v'*logm(cell2mat(test2_list(i)))));
    n1 = norm(logm(t*expm(v'*in_m1_la)));
    n2 = norm(logm(t*expm(v'*in_m2_la)));
    if(n2<=n1)
        c_n = c_n + 1;
    else
        e_n = e_n + 1;
    end
end

s = sprintf('\tLie-Fisher(2): accuracy is %0.2f%%',c_n/(c_n+e_n)*100);
disp (s);
%}
toc