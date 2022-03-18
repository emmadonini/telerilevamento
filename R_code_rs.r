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
