% calculate a coviariance matrix of given image
function c = genCov(img,dim)

if(nargin < 2)
    dim = 8;
end

if(length(size(img))>2)
    img = rgb2gray(img);
end

img = double(img);

bb = 1;
if bb==1
    [ii,jj]=find(img~=0);
    imin = min(ii);
    imax = max(ii);
    jmin = min(jj);
    jmax = max(jj);
    img=img(imin:imax,jmin:jmax);
end

[Fx, Fy] = gradient(img);
[Fxx, Fxy] = gradient(Fx);
[Fyx, Fyy] = gradient(Fy);

aFx = abs(Fx);
aFy = abs(Fy);
aFxx = abs(Fxx);
aFxy = abs(Fxy);
aFyx = abs(Fyx);
aFyy = abs(Fyy);

[row, col] = size(img);
m=[];
for y=1:row
    for x=1:col
        if(dim == 9)
            v=[y, x, img(y,x), aFx(y,x), aFy(y,x), sqrt(aFx(y,x)*aFx(y,x)+aFy(y,x)*aFy(y,x)), aFxx(y,x), aFyy(y,x), atan(max(aFx(y,x),0.00000001)/max(aFy(y,x),0.00000001))];
        elseif (dim == 8)
            v=[y, x, img(y,x), aFx(y,x), aFy(y,x), aFxx(y,x), aFyy(y,x), atan(max(aFx(y,x),0.00000001)/max(aFy(y,x),0.00000001))];
        elseif (dim == 7)
            v=[y, x, img(y,x), aFx(y,x), aFy(y,x), aFxx(y,x), aFyy(y,x)];
        elseif (dim == 6)
            v=[y, x, img(y,x), aFx(y,x), aFy(y,x), sqrt(aFx(y,x)*aFx(y,x)+aFy(y,x)*aFy(y,x))];
        elseif (dim == 5)
            v=[y, x, img(y,x), aFx(y,x), aFy(y,x)];
        else
            v=[y, x, img(y,x)];
        end
        m=[m;v];
    end
end
%size(m)
c = cov(m);
c = c;
        