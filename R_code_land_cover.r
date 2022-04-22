# code for generating land cover maps from satellite

library(raster)
library(RStoolbox)
# install.packages("ggplot2")
library(ggplot2)
# install.packages("patchwork") 
library(patchwork)

setwd("/Users/emma/Desktop/lab/")

# NIR 1
# r 2
# g 3

l92 <- brick("defor1_.jpeg")
plotRGB(l92, 1, 2, 3, stretch="lin")

# import defor2 e plot insieme

l06 <- brick("defor2_.jpeg")

par(mfrow=c(2,1))
plotRGB(l92, 1, 2, 3, stretch="lin")
plotRGB(l06, 1, 2, 3, stretch="lin")

# multiframe con ggplot2 e gridExtra
ggRGB(l92, 1, 2, 3, stretch="lin")
ggRGB(l06, 1, 2, 3, stretch="lin")

p1 <- ggRGB(l92, 1, 2, 3, stretch="lin")
p2 <- ggRGB(l06, 1, 2, 3, stretch="lin")
p1+p2 
p1/p2

#classification
l92c <-unsuperClass(l92, nClasses=2)
l92c
plot(l92c$map)
# classe 1 aree agricole (+ acqua), classe 2 foresta

# classificare l'immagine del 2006
l06c <-unsuperClass(l06, nClasses=2)
l06c
plot(l06c$map)
# classe 2 aree agricole (+ acqua), classe 1 foresta

# frequenze
freq(l92c$map)
# classe 1 con 34226 pixels (aree agricole)
# classe 2 con 307066 pixels (foresta)

freq(l06c$map)
# classe 1 con 177913 pixels (foresta)
# classe 2 con 164813 pixels (aree agricole)






