function plotMKLieDA2


Y1=[0.8967,0.9033,0.92,0.8633,0.9,0.8933,0.8967,0.8667,0.89,0.9];%rbf
Y2=[0.9067,0.9033,0.9,0.8833,0.9167,0.88,0.92,0.88,0.8867,0.9033];%polym
Y3=[0.86,0.87,0.84,0.855,0.8733,0.8733,0.9067,0.8567,0.9033,0.8967];%linear
Y4=[0.88,0.8967,0.9067,0.89,0.91,0.93,0.91,0.9133,0.8733,0.8133];%tanh
Y5=[0.8867,0.91,0.8333,0.9,0.9133,0.8567,0.8567,0.87,0.8367,0.81];%sig

X=1:1:10;

hold off

plot(X,Y1,'-r*');hold on
plot(X,Y2,'-g^');hold on
plot(X,Y3,'-b+');hold on
plot(X,Y4,'-y.');hold on
plot(X,Y5,'-mo');hold on

l1=sprintf('rbf: %0.3f',mean(Y1));
l2=sprintf('poly: %0.3f',mean(Y2));
l3=sprintf('linear: %0.3f',mean(Y3));
l4=sprintf('tanh: %0.3f',mean(Y4));
l5=sprintf('sig: %0.3f',mean(Y5));

legend(l1,l2,l3,l4,l5);