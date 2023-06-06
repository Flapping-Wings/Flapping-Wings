t=linspace(0,2);
s5=tableB(t,5,0);
s10=tableB(t,10,0);
s100=tableB(t,100,0);
plot(t,s5,t,s10,t,s100);
legend('p=5','p=10','p=100');
axis([-0.1,2.1, -1.1,1.1]);
axis on;
grid on
