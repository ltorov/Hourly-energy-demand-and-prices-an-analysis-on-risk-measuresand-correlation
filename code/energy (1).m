%datos
data = data
produccion = data((1:720),(1:14))
produccion_total=zeros(720,1)
for i = 1:14
    produccion_total = produccion(:,i) + produccion_total
end
demanda = data((1:720),(18))
predicciones_demanda = data((1:720),(17))
error_prediccion = demanda-predicciones_demanda
error_produccion = produccion_total-demanda
promedio_produccion = produccion_total/14
rango = range(produccion,2)
precio = data((1:720),(20))
prediccion_precio = data((1:720),(19))





%graficos

%prediccion de la demanda vs demanda
histogram(predicciones_demanda)
plot(predicciones_demanda)
hold on
plot(demanda)
hold off

%prediccion precio vs precio
plot(prediccion_precio,'r')
hold on
plot(precio, 'b')
hold off

plot(prediccion_precio-precio)
title("Error between price and price prediction in last month")

%prediccion precio vs precio tiempo
plot(cartaPr)
hold on
plot(Pp)
hold off

plot(cartaPr-Pp)

%oferta vs demanda
plot(produccion_total)
hold on
plot(demanda)
hold off

%oferta vs prediccion demanda
plot(produccion_total)
hold on
plot(predicciones_demanda)
hold off

%colchon oferta
plot(produccion_total - predicciones_demanda)

%cambio produccion de energia
produccion_totald = Pd
produccion_nucleard = Pn
plot(produccion_totald)
hold on
plot(produccion_nucleard)
hold off

%test normalidad produccion
[h p]=jbtest(produccion_total)
qqplot(produccion_total)
hist(produccion_total)



%copulas

%geometria de los datos
plot(produccion_total,precio,'o')
plot(produccion_total,predicciones_demanda,'o')
plot(produccion_total,demanda,'o')
plot(demanda,precio,'o')
plot(prediccion_precio, precio,'o')
plot(Pp, cartaPr, 'o')
for i=1 : 720
    for j=1 :720
        I(j) = (produccion_total(j)<=produccion_total(i));
    end
    fhatx(i)=mean(I);
    I=[];
end
Xc=fhatx


for i=1 : 720
    for j=1 :720
        I(j) = (cartaPr(j)<=cartaPr(i));
    end
    fhatPr(i)=mean(I);
    I=[];
end
Prc=fhatPr


for i=1 : 720
    for j=1 :720
        I(j) = (Pp(j)<=Pp(i));
    end
    fhatPp(i)=mean(I);
    I=[];
end
Ppc=fhatPp


for i=1 : 720
    for j=1 :720
        I(j) = (precio(j)<=precio(i));
    end
    fhaty(i)=mean(I);
    I=[];
end
Yc=fhaty


for i=1 : 720
    for j=1 :720
        I(j) = (demanda(j)<=demanda(i));
    end
    fhatz(i)=mean(I);
    I=[];
end
Zc = fhatz;

for i=1 : 720
    for j=1 :720
        I(j) = (predicciones_demanda(j)<=predicciones_demanda(i));
    end
    fhata(i)=mean(I);
    I=[];
end
Ac = fhata;

for i=1 : 720
    for j=1 :720
        I(j) = (prediccion_precio(j)<=prediccion_precio(i));
    end
    fhatb(i)=mean(I);
    I=[];
end
Bc = fhatb;

%copulas
plot(Xc,Yc,'o')
plot(Yc,Zc,'o')
plot(Xc,Zc,'o')
plot(Xc,Ac,'o')
plot(Yc,Bc,'o')
plot(Ppc,Prc,'o')

%Correlaciones
C = robustcov([produccion_total predicciones_demanda])
CI = inv(C)
d1 = diag(C)
d2 = diag(CI)
R2 = 1-1./(d1.*d2)

C = robustcov([precio prediccion_precio])
CI = inv(C)
d1 = diag(C)
d2 = diag(CI)
R2 = 1-1./(d1.*d2)




