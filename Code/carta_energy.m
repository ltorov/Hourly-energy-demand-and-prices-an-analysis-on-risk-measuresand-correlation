carta = carta1
cartaP = carta2
cartaPr = carta3
for i=1:length(carta)/7
    for j=1:7
        c(i,j) = carta((i-1)*7+j)
        cP(i,j) = cartaP((i-1)*7+j)
        cPr(i,j) = cartaPr((i-1)*7+j)
    end
end
rango = range(c, 2)
rangoP = range(cP, 2)
rangoPr = range(cPr, 2)
medias = mean(c, 2)
mediasP = mean(cP, 2)
mediasPr = mean(cPr, 2)
A2 = 0.419
R = mean(rango)
RP = mean(rangoP)
RPr = mean(rangoPr)
mu = mean(medias)
muP = mean(mediasP)
muPr = mean(mediasPr)
LCS = mu+(A2*R)
LCI = mu-(A2*R)
LCSr = R*1.9242
LCIr = R*0.0758
LCSP = muP+(A2*RP)
LCIP = muP-(A2*RP)
LCSrP = RP*1.9242
LCIrP = RP*0.0758
LCSPr = muPr+(A2*RPr)
LCIPr = muPr-(A2*RPr)
LCSrPr = RPr*1.9242
LCIrPr = RPr*0.0758

plot(medias)
h1=yline(LCS)
h2=yline(mu)
h3=yline(LCI)

plot(rango)
h1=yline(LCSr)
h2=yline(R)
h3=yline(LCIr)

plot(mediasP)
h1=yline(LCSP)
h2=yline(muP)
h3=yline(LCIP)

plot(rangoP)
h1=yline(LCSrP)
h2=yline(RP)
h3=yline(LCIrP)

plot(mediasPr)
h1=yline(LCSPr)
h2=yline(muPr)
h3=yline(LCIPr)

plot(rangoPr)
h1=yline(LCSrPr)
h2=yline(RPr)
h3=yline(LCIrPr)
