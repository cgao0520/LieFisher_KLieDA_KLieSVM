function [faces, nonfaces] = genMITfaces
cd MITExfaces;

cd faces;

res = dir();
res = res(4:size(res,1));
n = size(res,1);

faces = [];

for i=1:n
    x = imread(res(i).name);
    if(length(size(x)) > 2)
        x = rgb2gray(x);
    end
    x = reshape(x,1,400);
    faces = [faces; x];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%

cd ..;
cd nonfaces;
res = dir();
res = res(4:size(res,1));
n = size(res,1);
nonfaces = [];

for i=1:n
    x = imread(res(i).name);
    if(length(size(x)) > 2)
        x = rgb2gray(x);
    end
    x = reshape(x,1,400);
    nonfaces = [nonfaces; x];
end
cd ..;
cd ..;