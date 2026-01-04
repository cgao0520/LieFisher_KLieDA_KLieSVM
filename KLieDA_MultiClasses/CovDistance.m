% calculate the distance of two covariance matrices
% C1 and C2 are both covariance matrices
function d = CovDistance(C1,C2)
v=eig(C1,C2);
n=size(v,1);
sum = 0;
for i=1:n
    ln = log(v(i,1));
    sum = sum + ln^2;
end
d=sqrt(sum);