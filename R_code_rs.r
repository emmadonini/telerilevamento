# Questo è il primo script che useremo a lezione

library(raster)
# Questo è il primo script che useremo a lezione

# install.packages("raster")
library(raster)
library(sp)

# settaggio cartella di lavoro
setwd("/Users/emma/Desktop/lab")

# inserire pacchetto dati
l2011 <- brick("p224r63_2011.grd")
l2011

# plot
plot(l2011)

# legenda da nero valori più bassi a grigio chiaro con valori più alti
cl <- colorRampPalette(c("black", "grey", "light grey")) (100)

plot(l2011, col=cl)

# Land
# banda 1 -> b1 = blu
# b2 = verde
# b3 = rosso
# b4 = infrarosso vicino NIR

# plot della banda del blu -> B1_sre
plot(l2011$B1_sre)
# oppure altro modo per fare il plot della banda del blu
plot(l2011[[1]])

# cambiare legenda da nero a grigio chiaro
 plot(l2011$B1_sre, col=cl)

# plot b1 da un blu scuro a blu chiaro
clb <- colorRampPalette(c("dark blue", "blue", "light blue")) (100)
plot(l2011$B1_sre, col=clb)

# esportare immagine e farla apparire in cartella lab. La salva in lab perchè fatto riferimento prima alla cartella
pdf("banda1.pdf")
plot(l2011$B1_sre, col=clb)
dev.off()
# oppure con png
png("banda1.png")
plot(l2011$B1_sre, col=clb)
dev.off()

# plot b2 da verde scuro a verde chiaro
clg <- colorRampPalette(c("dark green", "green", "light green")) (100)
plot(l2011$B2_sre, col=clg)

# multiframe plottare insieme banda del blu e del verde
par(mfrow=c(1, 2))
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)

# per chiudere il grafico
dev.off()

par(mfrow=c(1, 2))
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)

# esportare il multiframe
pdf("multiframe.pdf")
par(mfrow=c(1, 2))
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)

par(mfrow=c(1, 2))
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)
dev.off()

# reverte multiframe
par(mfrow=c(2, 1))
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)

# red
clr <- colorRampPalette(c("violet", "red", "pink")) (100)

# NIR
clnir <- colorRampPalette(c("red", "orange", "yellow")) (100)

par(mfrow=c(2, 2))
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)
plot(l2011$B3_sre, col=clr)
plot(l2011$B4_sre, col=clnir)

# Day 3

# plot di NIR
plot(l2011$B4_sre)
# oppure
# plot(l2011[[4]])

clnir <- colorRampPalette(c("red", "orange", "yellow")) (100)
plot(l2011$B4_sre, col=clnir)

# plot RGB layers -> associare le bande al rosso, verde, blu
plotRGB(l2011, r=3, g=2, b=1, stretch="lin")
# infrarosso che vegetazione riflette molto
plotRGB(l2011, r=4, g=3, b=2, stretch="lin")
# vedere la vegetazione in verde
plotRGB(l2011, r=3, g=4, b=2, stretch="lin")
# in giallo il suolo nudo
plotRGB(l2011, r=3, g=2, b=4, stretch="lin")

# con stretch hist
plotRGB(l2011, r=3, g=4, b=2, stretch="hist")

# multiframe con visibile RGB (linear stretch) su colori falsi (histogram stretch)
par(mfrow=c(2, 1))
plotRGB(l2011, r=3, g=2, b=1, stretch="lin")
plotRGB(l2011, r=3, g=4, b=2, stretch="hist")

# upload the image from 1988
l1988 <- brick("p224r63_1988.grd")
l1988

par(mfrow=c(2,1))
plotRGB(l1988, r=4, g=3, b=2, stretch="lin")
plotRGB(l2011, r=4, g=3, b=2, stretch="lin")


