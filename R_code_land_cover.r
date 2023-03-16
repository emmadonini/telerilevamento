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

tot92 <- 341292

# proporzione delle classi
prop_forest_92 <- 307066 / tot92

# percentuale delle classi
perc_forest_92 <- 307066 * 100 / tot92 

# percentuale di aree agricole
perc_agr_92 <- 34226 * 100 / tot92 
# oppure 
# perc_agr_92 <- 100 - perc_forest_92

# perc_forest_92 : 89.97164
# perc_agr_92 : 10.02836


freq(l06c$map)
# classe 1 con 177913 pixels (foresta)
# classe 2 con 164813 pixels (aree agricole)

tot_06 <- 342726
percent_forest_06 <- 177913 * 100 / tot_06
percent_agr_06 <- 100 - percent_forest_06

# percent_forest_06 : 51.91115
# percent_agr_06 : 48.08885

# Dati finali:

# perc_forest_92 : 89.97164
# perc_agr_92 : 10.02836
# percent_forest_06 : 51.91115
# percent_agr_06 : 48.08885



