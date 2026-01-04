function testpic(pic)

imshow(pic);
hold on;

[r,c] = size(pic);

step = 10;

for i=1:step:c
    x=[i,i];
    y=[0,r];
    line(x,y,'Color','r');
    hold on;
end

for i=1:step:r
    x=[0,c];
    y=[i,i];
    line(x,y);
    hold on;
end
hold off;


