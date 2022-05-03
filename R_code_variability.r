library(raster)
library(RStoolbox)
library(ggplot2)
library(patchwork)
# install.packages("viridis")
library(viridis)

setwd("/Users/emma/Desktop/lab/")

sen <- brick("sentinel.png")
sen

# band1 = NIR
# band2 = red
# band3 = green

# ggRGB(sen, r=1, g=2, b=3, stretch="lin") si può fare senza stretch
ggRGB(sen, 1, 2, 3)
ggRGB(sen, 2, 1, 3)

# Plot the two graphs one beside the other
g1 <- ggRGB(sen, 1, 2, 3)
g2 <- ggRGB(sen, 2, 1, 3)

g1+g2

# calculation of variability over NIR
nir <- sen[[1]]

sd3 <- focal(nir, matrix(1/9, 3, 3), fun=sd)

clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100)
plot(sd3, col=clsd)

# plot con ggplot
ggplot() + geom_raster(sd3, mapping=aes(x=x, y=y, fill=layer))

# con viridis
ggplot() + 
geom_raster(sd3, mapping=aes(x=x, y=y, fill=layer)) +
scale_fill_viridis() +
ggtitle("Standard deviation by viridis package")

# esempio con cividis 
ggplot() + 
geom_raster(sd3, mapping=aes(x=x, y=y, fill=layer)) +
scale_fill_viridis(option="cividis") +
ggtitle("Standard deviation by viridis package")


