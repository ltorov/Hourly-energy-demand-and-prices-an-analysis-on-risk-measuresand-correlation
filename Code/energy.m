%organizar datos (datos cada hora)
produccion = data((1:720),(1:14))
produccion_total=zeros(720,1)
for i = 1:14
produccion_total = produccion(:,i) + produccion_total
end
demanda = data((1:720),(18))
predicciones_demanda = data((1:720),(17))
error_prediccion = demanda-predicciones_demanda
error_produccion = produccion_total-demanda
prediccion_precio=data(:,19)
precio= data(:,(20))
%%
%organizar datos (datos mensuales)
data=energia_produccion_fin_mes;
[r c]=size(data);
produccion=data(:,(1:14));
produccion_total=zeros(r,1);
for i=1:14
    produccion_total=produccion(:,i) + produccion_total;
end
demanda=data(:,15);
precio=data(:,16);
%%
%organizar datos (datos diarios)
data2=[carta2 carta1 carta3];
produccion_total=carta2;
demanda= carta1;
precio=carta3;
%%
%graficos
hist(predicciones_demanda)
plot(predicciones_demanda)
hold on
plot(demanda)
hold off
plot(produccion_total)
hold on
plot(demanda)
hold off
plot(error_produccion)
media = yline(mean(error_produccion))
plot(error_prediccion)
%%
hist(produccion_total)
title("Histogram for energy generation")
%%
plot(precio,'r') %Aquí usar el dataset por meses
title ("Historical daily energy price")
%%
%Identification of distribution
qqplot(produccion_total)
title("QQ Plot of energy generation versus Standard Normal")
%%
%Ventanas de volatilidad
data=produccion_total %esto se cambia según lo que se quiere ver
d=[]
v=100 %tamaño de ventana
l=length(data)
for j=1:l-v
    dataj=data(j:j+v-1);
    d(j)=std(dataj);
end
subplot(2,1,1)
plot(d)
title("Window volatility for energy generation")

%%
%hallar distancias de mahalanobis
%X=[demanda produccion_total]
X=[produccion_total precio]

d=mahal(X,X)
%para encontrar que datos recortar
I1=prctile(d,90)
I2=find(d<=I1)
%datos recortados
newX=X(I2,:)
%Hallar R^2 con datos recortados según mahalanobis
C=cov(newX)
CI=inv(C)
d1=diag(C)
d2=diag(CI)
R2mahalanobis=1-1./(d1.*d2)

plot(X(:,1),X(:,2),'or')
hold on
plot(X(I2,1),X(I2,2),'ob')
legend("Outliers","Nonoutliers")
xlabel("Daily Energy Generation")
ylabel("Daily Energy Price")
title("Mahalanobis distance to the mean of daily energy generation versus price")
%%
%copula
X=demanda
Y=precio %dependencia con ruido
Z=produccion_total
A=prediccion_precio
plot (X,Y,'o')
lx=length(X)
for i=1:lx
    for j=1:lx
        I(j)=(X(j)<=X(i));
    end
    fhatx(i)=mean(I); %empirica en cada dato
    I=[];
end
Xc=fhatx;
ly=length(Y)
for i=1:ly
    for j=1:ly
        I(j)=(Y(j)<=Y(i));
    end
    fhaty(i)=mean(I); %empirica en cada dato
    I=[];
end
Yc=fhaty;
lz=length(Z)
for i=1:lz
    for j=1:lz
        I(j)=(Z(j)<=Z(i));
    end
    fhatz(i)=mean(I); %empirica en cada dato
    I=[];
end
Zc=fhatz;
la=length(A)
for i=1:la
    for j=1:la
        I(j)=(A(j)<=A(i));
    end
    fhata(i)=mean(I); %empirica en cada dato
    I=[];
end
Ac=fhata;
plot(Ac,Yc,'o') %copula
%plot3(Xc,Yc,Zc,'o') %copula entre 3
title("Copula of energy price versus energy price prediction")
%%
%%
%indice explicativo de una variable en terminos de las otras
C=robustcov([produccion_total weather])
CI=inv(C) %calcular la inversa, pero es muy malo este metodo 
d1=diag(C)
d2=diag(CI)
R2=1-1./(d1.*d2) %porcentaje explicado de la variable en terminos de las otras
%Table = "Correlation coeficient between variables (R2)"
%TotalEnergyGeneration = R2(1)
%EnergyDemandPrediction=R2(2)
%EnergyPrice=R2(3)
%T=table(Table, TotalEnergyGeneration, EnergyDemandPrediction)
%%
%proyeccion
C=cov(data);
[vector valor]=eig(C);
valor=diag(valor);
vectormax=vector(:,end);
pro=data*vectormax
varpro=var(pro)
%%
[nf nc]=size(data);
for j=1:nc
    for i=1:nc
        rho1=corr(data(:,i),data(:,j),'type','spearman');
        rho2=rho1;
        cov1(i,j)=rho2*mad(data(:,i))*mad(data(:,j)); %mad es desviacion robusta
    end
end
cov1


%%
%peaks over threshold (POT) Analisis de picos
X=demanda
Threshold= prctile(X,90)

findpeaks(X,'MinPeakHeight',Threshold)
hold on
plot(1:1)
h = yline(Threshold, 'r--', 'LineWidth',2);
legend("Energy Demand","Outliers","","Threshold (percentile 90)")
title("Peaks over Threshold for Energy Demand")
xlabel("Time")
ylabel("Energy Demand")

%%
%Autocorrelation function ACF
%autocorr(produccion_total) %autocorrelacion simple
%title("Simple Autocorrelation Function for Energy Generation")

parcorr(demanda) %autocorrelacion parcial
title("Partial Autocorrelation Function for Energy Demand")
ylabel("Energy Demand")

%%
%Exponential smoothing
smooth = smoothdata(produccion_total)
plot(smooth)
hold on
plot(produccion_total)
legend("Smoothed Energy Generation","Original Energy Generation")
title("Exponential smoothing for Energy Generation")
xlabel("Time")

%%
%Extreme Value Distribution 
X=demanda
blocksize = 1000;
nblocks = size(X);
rng default  % For reproducibility
t = X;
x = max(t); % 250 column maxima
paramEsts = gevfit(x)
histogram(x,2:20,'FaceColor',[.8 .8 1]);
xgrid = linspace(2,20,1000);
line(xgrid,nblocks*...
     gevpdf(xgrid,paramEsts(1),paramEsts(2),paramEsts(3)));
