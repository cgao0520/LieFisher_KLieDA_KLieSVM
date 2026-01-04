function MKLieDA2(train1,train2,train3,train4,train5,train6,train7,train8,train9,train0,train_n,test1,test2,test3,test4,test5,test6,test7,test8,test9,test0,test_n,dim,width,height,ker,d)
tic
global train_n width height dim ker;
t1_n = randperm(size(train1,1));trn1=train1(t1_n(1:train_n),:);
t2_n = randperm(size(train2,1));trn2=train2(t2_n(1:train_n),:);
t3_n = randperm(size(train3,1));trn3=train3(t3_n(1:train_n),:);
t4_n = randperm(size(train4,1));trn4=train4(t4_n(1:train_n),:);
t5_n = randperm(size(train5,1));trn5=train5(t5_n(1:train_n),:);
t6_n = randperm(size(train6,1));trn6=train6(t6_n(1:train_n),:);
t7_n = randperm(size(train7,1));trn7=train7(t7_n(1:train_n),:);
t8_n = randperm(size(train8,1));trn8=train8(t8_n(1:train_n),:);
t9_n = randperm(size(train9,1));trn9=train9(t9_n(1:train_n),:);
t0_n = randperm(size(train0,1));trn0=train0(t0_n(1:train_n),:);

t1_n = randperm(size(test1,1));tst1=test1(t1_n(1:test_n),:);
t2_n = randperm(size(test2,1));tst2=test2(t2_n(1:test_n),:);
t3_n = randperm(size(test3,1));tst3=test3(t3_n(1:test_n),:);
t4_n = randperm(size(test4,1));tst4=test4(t4_n(1:test_n),:);
t5_n = randperm(size(test5,1));tst5=test5(t5_n(1:test_n),:);
t6_n = randperm(size(test6,1));tst6=test6(t6_n(1:test_n),:);
t7_n = randperm(size(test7,1));tst7=test7(t7_n(1:test_n),:);
t8_n = randperm(size(test8,1));tst8=test8(t8_n(1:test_n),:);
t9_n = randperm(size(test9,1));tst9=test9(t9_n(1:test_n),:);
t0_n = randperm(size(test0,1));tst0=test0(t0_n(1:test_n),:);

trn1_rest = [trn2;trn3;trn4;trn5;trn6;trn7;trn8;trn9;trn0];
trn2_rest = [trn1;trn3;trn4;trn5;trn6;trn7;trn8;trn9;trn0];
trn3_rest = [trn1;trn2;trn4;trn5;trn6;trn7;trn8;trn9;trn0];
trn4_rest = [trn1;trn2;trn3;trn5;trn6;trn7;trn8;trn9;trn0];
trn5_rest = [trn1;trn2;trn3;trn4;trn6;trn7;trn8;trn9;trn0];
trn6_rest = [trn1;trn2;trn3;trn4;trn5;trn7;trn8;trn9;trn0];
trn7_rest = [trn1;trn2;trn3;trn4;trn5;trn6;trn8;trn9;trn0];
trn8_rest = [trn1;trn2;trn3;trn4;trn5;trn6;trn7;trn9;trn0];
trn9_rest = [trn1;trn2;trn3;trn4;trn5;trn6;trn7;trn8;trn0];
trn0_rest = [trn1;trn2;trn3;trn4;trn5;trn6;trn7;trn8;trn9];

w=width;
h=height;
global a1 a2 a3 a4 a5 a6 a7 a8 a9 a0 km1 km2 km3 km4 km5 km6 km7 km8 km9 km0;
global km1_rest km2_rest km3_rest km4_rest km5_rest km6_rest km7_rest km8_rest km9_rest km0_rest;
global covCell1 covCell2 covCell3 covCell4 covCell5 covCell6 covCell7 covCell8 covCell9 covCell0;
[a1, km1, km1_rest, covCell1] = KLieDA2(trn1,trn1_rest,train_n,dim,w,h,ker,d);
[a2, km2, km2_rest, covCell2] = KLieDA2(trn2,trn2_rest,train_n,dim,w,h,ker,d);
[a3, km3, km3_rest, covCell3] = KLieDA2(trn3,trn3_rest,train_n,dim,w,h,ker,d);
[a4, km4, km4_rest, covCell4] = KLieDA2(trn4,trn4_rest,train_n,dim,w,h,ker,d);
[a5, km5, km5_rest, covCell5] = KLieDA2(trn5,trn5_rest,train_n,dim,w,h,ker,d);
[a6, km6, km6_rest, covCell6] = KLieDA2(trn6,trn6_rest,train_n,dim,w,h,ker,d);
[a7, km7, km7_rest, covCell7] = KLieDA2(trn7,trn7_rest,train_n,dim,w,h,ker,d);
[a8, km8, km8_rest, covCell8] = KLieDA2(trn8,trn8_rest,train_n,dim,w,h,ker,d);
[a9, km9, km9_rest, covCell9] = KLieDA2(trn9,trn9_rest,train_n,dim,w,h,ker,d);
[a0, km0, km0_rest, covCell0] = KLieDA2(trn0,trn0_rest,train_n,dim,w,h,ker,d);

c_n = 0;
e_n = 0;

for i=1:train_n
    p = classify(tst1(i,:),1);
    if( p>= 0)
        c_n = c_n + 1;
    else
        e_n = e_n + 1;
    end
end

for i=1:train_n
    p = classify(tst2(i,:),2);
    if( p>= 0)
        c_n = c_n + 1;
    else
        e_n = e_n + 1;
    end
end
for i=1:train_n
    p = classify(tst3(i,:),3);
    if( p>= 0)
        c_n = c_n + 1;
    else
        e_n = e_n + 1;
    end
end

for i=1:train_n
    p = classify(tst4(i,:),4);
    if( p>= 0)
        c_n = c_n + 1;
    else
        e_n = e_n + 1;
    end
end

for i=1:train_n
    p = classify(tst5(i,:),5);
    if( p>= 0)
        c_n = c_n + 1;
    else
        e_n = e_n + 1;
    end
end

for i=1:train_n
    p = classify(tst6(i,:),6);
    if( p>= 0)
        c_n = c_n + 1;
    else
        e_n = e_n + 1;
    end
end

for i=1:train_n
    p = classify(tst7(i,:),7);
    if( p>= 0)
        c_n = c_n + 1;
    else
        e_n = e_n + 1;
    end
end

for i=1:train_n
    p = classify(tst8(i,:),8);
    if( p>= 0)
        c_n = c_n + 1;
    else
        e_n = e_n + 1;
    end
end

for i=1:train_n
    p = classify(tst9(i,:),9);
    if( p>= 0)
        c_n = c_n + 1;
    else
        e_n = e_n + 1;
    end
end

for i=1:train_n
    p = classify(tst0(i,:),0);
    if( p>= 0)
        c_n = c_n + 1;
    else
        e_n = e_n + 1;
    end
end


acc = c_n/(c_n+e_n);
s = sprintf('\tKLieDA: accuracy is %0.2f%%',c_n/(c_n+e_n)*100);
disp (s);
toc

function c_n = classify(test_sample,label)
global a1 a2 a3 a4 a5 a6 a7 a8 a9 a0 km1 km2 km3 km4 km5 km6 km7 km8 km9 km0;
global km1_rest km2_rest km3_rest km4_rest km5_rest km6_rest km7_rest km8_rest km9_rest km0_rest;
global covCell1 covCell2 covCell3 covCell4 covCell5 covCell6 covCell7 covCell8 covCell9 covCell0;
c_n = 0;

    proj = projection(test_sample,a1,covCell1);
    if(abs(km1-proj) < abs(km1_rest-proj) & label == 1)
        c_n = c_n + 1;
    else
        proj = projection(test_sample,a2,covCell2);
        if(abs(km2-proj) < abs(km2_rest-proj) & label == 2)
            c_n = c_n + 1;
        else
            proj = projection(test_sample,a3,covCell3);
            if(abs(km3-proj) < abs(km3_rest-proj) & label == 3)
                c_n = c_n + 1;
            else            
                proj = projection(test_sample,a4,covCell4);
                if(abs(km4-proj) < abs(km4_rest-proj) & label == 4)
                    c_n = c_n + 1;
                else
                    proj = projection(test_sample,a5,covCell5);
                    if(abs(km5-proj) < abs(km5_rest-proj) & label == 5)
                        c_n = c_n + 1;
                    else
                        proj = projection(test_sample,a6,covCell6);
                        if(abs(km6-proj) < abs(km6_rest-proj) & label == 6)
                            c_n = c_n + 1;
                        else   
                            proj = projection(test_sample,a7,covCell7);
                            if(abs(km7-proj) < abs(km7_rest-proj) & label == 7)
                                c_n = c_n + 1;
                            else     
                                proj = projection(test_sample,a8,covCell8);
                                if(abs(km8-proj) < abs(km8_rest-proj) & label == 8)
                                    c_n = c_n + 1;
                                else
                                    proj = projection(test_sample,a9,covCell9);
                                    if(abs(km9-proj) < abs(km9_rest-proj) & label == 9)
                                        c_n = c_n + 1;
                                    else
                                        proj = projection(test_sample,a0,covCell0);
                                        if(abs(km0-proj) < abs(km0_rest-proj) & label == 0)
                                            c_n = c_n + 1;
                                        else                                        
                                            c_n = -1;
                                            return;
                                        end%0
                                    end%9
                                end%8
                            end%7
                        end%6
                    end%5
                end%4
            end%3
        end%2
    end%1


function proj=projection(test_sample,a,covCell)
global train_n width height dim ker sig;
proj = 0;
    for j=1:train_n*2
        img = reshape(test_sample,width,height);
        c = genCov(img,dim);
        proj = proj + a(j)*kernel(ker, cell2mat(covCell(j)), c, 1000000000);
    end
