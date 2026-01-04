function FaceCovLieFisher(faces,n1,n2,train_n,ever_n,width,height)
%faces is face dataset, every number in column is the face's index;
%n1 is the class one face's index
%n2 is the class two face's index
%train_n is the count of training samples;
%ever_n is the count of faces in every type of face, 11 in yalefaces and 10
%   in ORL faces
%width is the image's width
%height is the image's height

sz = size(faces,2)/ever_n;

if(n1>sz || n1<1 || n2>sz || n2<1)
    disp('    !!!error index of faces\n');
    return;
end

samp1 = uint8(faces(:,(n1-1)*ever_n+1:n1*ever_n));
samp2 = uint8(faces(:,(n2-1)*ever_n+1:n2*ever_n));
samp1 = samp1';
samp2 = samp2';

train1 = samp1(1:train_n,:);
test1 = samp1(train_n+1:ever_n,:);
train2 = samp2(1:train_n,:);
test2 = samp2(train_n+1:ever_n,:);

CovLieFisher(train1,train2,train_n,test1,test2,ever_n-train_n,8,width,height)

