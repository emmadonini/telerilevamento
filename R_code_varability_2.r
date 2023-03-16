library(raster)
library(RStoolbox)
library(ggplot2)
library(patchwork)

setwd("/Users/emma/Desktop/lab/")

siml <- brick("sentinel.png")
siml

# NIR 1
# red
# green

ggRGB(siml, 1, 2, 3)
ggRGB(siml, 3, 1, 2)

simlpca <- rasterPCA(siml)
simlpca

# $call
# $model
# $map

summary(simlpca$model)

g1 <- ggplot() +
geom_raster(simlpca$map, mapping =aes(x=x, y=y, fill=PC1)) +
scale_fill_viridis(option = "inferno") +
ggtitle("PC1")

g3 <- ggplot() +
geom_raster(simlpca$map, mapping =aes(x=x, y=y, fill=PC3)) +
scale_fill_viridis(option = "inferno") +
ggtitle("PC3")

g1+g3

g2 <- ggplot() +
geom_raster(simlpca$map, mapping =aes(x=x, y=y, fill=PC2)) +
scale_fill_viridis(option = "inferno") +
ggtitle("PC2")

g1+g2+g3

pc1 <- simlpca$map[[1]]
# delle mappe disponibili prendo la prima che è con la componente principale

sd3 <- focal(pc1, matrix(1/9, 3, 3), fun=sd)

ggplot() +
geom_raster(sd3, mapping =aes(x=x, y=y, fill=layer)) +
scale_fill_viridis(option = "inferno") +
ggtitle("Standard deviation of PC1")






