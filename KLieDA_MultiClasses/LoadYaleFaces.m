function yalefaces = LoadYaleFaces
yalefaces = [];
cd yalefaces

for i=1:15
    if(i<10)
        subfolder = sprintf('0%d',i);
    else
        subfolder = sprintf('%d',i);
    end
    cd(subfolder);
    for i=1:11
        s = sprintf('s%d.bmp',i);
        x = imread(s);
        x = reshape(x,1,10000);
        yalefaces = [yalefaces;x];
    end
    cd ..;
end
    
cd ..;

yalefaces = yalefaces';