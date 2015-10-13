
x_values = linspace(30,70,101);
y_val= mean(rand(101),2)* 100;

pd = fitdist(y_val,'GeneralizedExtremeValue');
y = pdf(pd,x_values);

%pd.mu=40;
%pd.sigma= 20;

figure
plot(x_values,y,'LineWidth',2)


