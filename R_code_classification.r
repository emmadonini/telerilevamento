library(raster)
library(RStoolbox)

setwd("/Users/emma/Desktop/lab/")

so <- brick("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")
so

plotRGB(so, 1,2,3, stretch="lin")

soc <- unsuperClass(so, nClasses=3)
plot(soc$map)

soc20 <- unsuperClass(so, nClasses=20)

cl <- colorRampPalette(c('yellow','black','red'))(100)
plot(soc20$map,col=cl)

# day 2 Grand Canyon

gc <- brick("dolansprings_oli_2013088_canyon_lrg.jpg")
gc

# rosso = 1
# verde = 2
# blu = 3

plotRGB(gc, r=1, g=2, b=3, stretch="lin")

# change stretch to histogram stretching
plotRGB(gc, r=1, g=2, b=3, stretch="hist")

# classification in 2 classi
gcclass2 <- unsuperClass(gc, nClasses=2)
gcclass2

plot(gcclass2$map)

# classificare la mappa con 4 classi
gcclass4 <- unsuperClass(gc, nClasses=4)
gcclass4

plot(gcclass4$map)

clc <- colorRampPalette(c('yellow','red','blue','black'))(100)
plot(gcclass4$map, col=clc)

par(mfrow=c(2,1))
plot(gcclass4$map, col=clc)
plotRGB(gc, r=1, g=2, b=3, stretch="hist")

# st <- stack(gc, gcclass4$map)
# plot(st)
