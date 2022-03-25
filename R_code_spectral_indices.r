library(raster)

setwd("/Users/emma/Desktop/lab/")

# import file defor1_.jpeg
l1992 <- brick("defor1_.jpeg")

plotRGB(l1992, r=1, g=2, b=3, stretch="lin")
# scopro qual è la banda che porta la vegetazione. Sul rosso è montato l'infrarosso -> la banda numero 1 è quella dell'infrarosso
# quindi probabilmento la 2 è il rosso e la 3 il verde perchè di solito le bande si montano in sequenza

# layer 1 = NIR
# layer 2 = red
# layer 3 = green

# import file defor1_.jpeg
l2006 <- brick("defor2_.jpeg")

plotRGB(l2006, r=1, g=2, b=3, stretch="lin")

# multiframe
par(mfrow=c(2, 1))
plotRGB(l1992, r=1, g=2, b=3, stretch="lin")
plotRGB(l2006, r=1, g=2, b=3, stretch="lin")

# DVI = Difference Vegetation Index
dvi1992 = l1992[[1]] - l1992[[2]]
# oppure dvi1992 <- l1992[[1]] - l1992[[2]]
# oppure dvi1992 = l1992$defor1_.1 - l1992$defor1_.2 
dvi1992

cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100)
plot(dvi1992, col=cl)

dvi2006 = l2006[[1]] - l2006[[2]]
dvi2006
plot(dvi2006, col=cl)

# DVI difference in time
dvi_dif = dvi1992 - dvi2006
cld <- colorRampPalette(c('blue','white','red'))(100)
dev.off()
plot(dvi_dif, col=cld)

