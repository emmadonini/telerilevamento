# R code variability 2

library(raster)
library(RStoolbox)
library(ggplot2)
library(patchwork)
library(viridis)

setwd("/Users/emma/Desktop/lab/")

sen <- brick("sentinel.png")
sen

# NIR = banda 1
# red = banda 2
# green = banda 3

ggRGB(sen, r=1, g=2, b=3)
# oppure ggRGB(sen, 1, 2, 3)

# visualise the image such as vegetation becomes green
ggRGB(sen, r=2, g=1, b=3)

# analisi multivariata
sen_pca <- rasterPCA(sen)
sen_pca

summary(sen_pca$model)

plot(sen_pca$map)

pc1 <- sen_pca$map$PC1
pc2 <- sen_pca$map$PC2
pc3 <- sen_pca$map$PC3

g1 <- ggplot() +
geom_raster(pc1, mapping=aes(x=x, y=y, fill=PC1))

g2 <- ggplot() +
geom_raster(pc2, mapping =aes(x=x, y=y, fill=PC2))

g3 <- ggplot() +
geom_raster(pc3, mapping =aes(x=x, y=y, fill=PC3))

g1 + g2 + g3

# standard deviation of PC1
sd3 <- focal(pc1, matrix(1/9, 3, 3), fun=sd)
sd3
# fun=sd -> funzione da applicare è standard deviation

# mappare con ggplot la deviazione standard di PC1
ggplot() +
geom_raster(sd3, mapping=aes(x=x, y=y, fill=layer))

ggplot() +
geom_raster(sd3, mapping=aes(x=x, y=y, fill=layer)) +
scale_fill_viridis()

ggplot() +
geom_raster(sd3, mapping=aes(x=x, y=y, fill=layer)) +
scale_fill_viridis(option="cividis")

ggplot() +
geom_raster(sd3, mapping=aes(x=x, y=y, fill=layer)) +
scale_fill_viridis(option="inferno")

im1 <- ggRGB(sen, 2, 1, 3)
 
im2 <- ggplot() +
geom_raster(pc1, mapping=aes(x=x, y=y, fill=PC1))
 
im3 <- ggplot() +
geom_raster(sd3, mapping=aes(x=x, y=y, fill=layer)) +
scale_fill_viridis(option="inferno")

im1 + im2 + im3

# calcolare eterogeneità in una finestra 5x5
sd5 <- focal(pc1, matrix(1/25, 5, 5), fun=sd)
sd5

im4 <- ggplot() +
geom_raster(sd5, mapping=aes(x=x, y=y, fill=layer)) +
scale_fill_viridis(option="inferno")

im3 + im4

sd7 <- focal(pc1, matrix(1/49, 7, 7), fun=sd)
im5 <- ggplot() +
geom_raster(sd7, mapping=aes(x=x, y=y, fill=layer)) +
scale_fill_viridis(option="inferno")

im3 + im4 + im5




