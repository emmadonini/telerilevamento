# R code for species distribution modelling

library(raster)
# predictors -> variabili ambientali per prevedere la distribuzione della specie
library(sdm)
library(rgdal)
# species

file <- system.file("external/species.shp", package="sdm")

species <- shapefile(file)
species

plot(species, pch=19)
# pch=19 è il tipo di carattere -> è punto

# per vedere assenze e presenze in ogni punto dello spazio
species$Occurrence

# [] per fare un subste, una selezione
plot(species[specie$Occurrence == 1,]

occ <- species$Occurrence

# per plottare con colori diversi i punti che indicano presenza e assenza
plot(species[occ == 1,], col="blue", pch=19)
points(species[occ == 0,], col="red", pch=19)
# funzione points per mettere i punti

# predictors: gurardare il path (percorso della funzione system.file)
path <- system.file("external", package="sdm")
path

# lista di predictors
lst <- list.files(path=path, pattern='asc', full.names=T)
# full.names=T -> conserva il percorso
lst

preds <- stack(lst)

cl <- colorRampPalette(c('blue','orange','red','yellow')) (100)

plot(preds, col=cl)

# plot dei predictors con le presenze
elev <- preds$elevation
prec <- preds$precipitation
temp <- preds$temperature
vege <- preds$vegetation

plot(elev, col=cl)
points(species[occ == 1,], pch=19)

plot(prec, col=cl)
points(species[occ == 1,], pch=19)

plot(temp, col=cl)
points(species[occ == 1,], pch=19)

plot(vege, col=cl)
points(species[occ == 1,], pch=19)

# sdmData è funzione per richiamare i dati
# model
datasdm <- sdmData(train=species, predictors=preds)
datasdm

m1 <- sdm(Occurrence ~ elevation + precipitation + temperature + vegetation, data=datasdm, methods="glm")
m1
summary(m1)

# predict funzione -> crea un layer raster 
# fatto previsione sulla maggiore probabilità di presenza di una certa specie 
p1 <- predict(m1, newdata=preds)
p1 

# output
plot(p1, col=cl)
points(species[occ == 1,], pch=19)

par(mfrow=c(2,3))
plot(p1, col=cl)
plot(elev, col=cl)
plot(prec, col=cl)
plot(temp, col=cl)
plot(vege, col=cl)

# oppure
final <- stack(preds, p1)
plot(final, col=cl)











