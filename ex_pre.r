# prova da far correre

# # script_def
#### da mettere su github con titolo: R.code.exam.r

# Considerati alcuni incendi avvenuti in British Columbia (Canada) nel 2021 tra fine Giugno e Agosto

# Richiamare pacchetti
library(raster)
library(ggplot2)
library(RStoolbox)
library(patchwork)
library(viridis)

# Impostare working directory
setwd("/Users/emma/Desktop/progetto_telerilevamento")


# Importare le immagini scaricate da landsat e unire le bande in uno stacK

# immagine del 10/05/2020: un anno prima degli incendi
list_20o <- list.files(pattern="047024_20200510")
imp_20o <- lapply(list_20o, raster)
imm20o <- stack(imp_20o)
imm20o

# immagine del 02/09/2021: dopo gli incendi
list_21o <- list.files(pattern="047024_20210902")
imp_21o <- lapply(list_21o, raster)
imm21o <- stack(imp_21o)
imm21o

# immagini del 27/07/2022: un anno dopo gli incendi
list_22o <- list.files(pattern="047024_20220727")
imp_22o <- lapply(list_22o, raster)
imm22o <- stack(imp_22o)
imm22o

# Bande 
# blu : primo elemento (file B2)
# verde: secondo elemento (file B3)
# rosso: terzo elemento (file B4)
# nir: quarto elemento (file B5)

# Immagini a 16 bit

# Visualizzare le immagini naturali
ggRGB(imm20o, 3, 2, 1)
ggRGB(imm21o, 3, 2, 1)
ggRGB(imm22o, 3, 2, 1)



# plot per verificare il risultato 
par(mfrow=c(1,3))
plotRGB(imm20, 3, 2, 1, stretch="lin")
plotRGB(imm21, 3, 2, 1, stretch="lin")
plotRGB(imm22, 3, 2, 1, stretch="lin")
#### non sò perchè ma appaiono con colori diversi -> e imm20 è un pò brulla !!!

# Plot bande -> ??????
clp <- colorRampPalette(c('red','orange','yellow'))(100)
plot(imm20, col=clp)

# Visualizzare nir e confrontare visivamente le immagini
par(mfrow=c(1,3))
plotRGB(imm20, 4, 3, 2, stretch="lin")
plotRGB(imm21, 4, 3, 2, stretch="lin")
plotRGB(imm22, 4, 3, 2, stretch="lin")

# vedere nir come verde per definire meglio la vegetazione
plotRGB(imm20, 3, 4, 2, stretch="lin")
plotRGB(imm21, 3, 4, 2, stretch="lin")
plotRGB(imm22, 3, 4, 2, stretch="lin")

# stretch="hist" per definire meglio zone incendiate 
plotRGB(imm20, 3, 4, 2, stretch="hist")
plotRGB(imm21, 3, 4, 2, stretch="hist")
plotRGB(imm22, 3, 4, 2, stretch="hist")
dev.off()


# Calcolare indice di vegetazione NDVI
# DVI e NDVI per ogni immagine
dvi20 = imm20[[4]] - imm20[[3]]
dvi20
cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100)
plot(dvi20, col=cl)

dvi21 = imm21[[4]] - imm21[[3]]
plot(dvi21, col=cl)

# DVI differenza tra 2020 e 2021 (prima e dopo gli incendi)
dvi_dif = dvi20 - dvi21
cld <- colorRampPalette(c('green','white','red'))(100) # non è colorblind friendly
plot(dvi_dif, col=cld)

# NDVI
ndvi20 =  dvi20 / (imm20[[4]] + imm20[[3]])
plot(ndvi20, col=cl)

# multiframe
par(mfrow=c(2, 1))
plotRGB(imm20, r=4, g=3, b=2, stretch="lin")
plot(ndvi20, col=cl)
#### decidere se inserire

ndvi21 =  dvi21 / (imm21[[4]] + imm21[[3]])

# multiframe 
par(mfrow=c(2, 1))
plot(ndvi20, col=cl)
plot(ndvi21, col=cl)

dvi22 = imm22[[4]] - imm22[[3]]
plot(dvi22, col=cl)

# NDVI 22
ndvi22 =  dvi22 / (imm22[[4]] + imm22[[3]])
plot(ndvi22, col=cl)

# multiframe con NDVI dei 3 anni
par(mfrow=c(1, 3))
plot(ndvi20, col=cl)
plot(ndvi21, col=cl)
plot(ndvi22, col=cl)

# differenza nel tempo
dvi_dif_20_22 = dvi20 - dvi22
plot(dvi_dif_20_22, col=cld)

par(mfrow=c(1,3))
plot(div_dif, col=cld)
plot(div_dif_21_22, col=cld)
plot(div_dif_20_22, col=cld)


# Focalizzarsi sugli incendi presenti
# definire extent e tagliare le immagini 
ext <- as(extent(540000, 668000, 5643000, 5750000), 'SpatialPolygons')
crs(ext) <- "+proj=utm +zone=10 +datum=WGS84 +units=m +no_defs"

imm20 <- crop(imm20o, ext)
imm21 <- crop(imm21o, ext)
imm22 <- crop(imm22o, ext)


# Time series con le bande nir delle immagini
grup_nir <- stack(imm20[[4]], imm21[[4]], imm22[[4]])
plot(grup_nir, col=cl)

# da immagine più vecchia a  più recente
plotRGB(grup_nir, 1, 2, 3, stretch="lin") 

# visione dall'immagine più recente a più vecchia 
# plotRGB(grup_nir, 3, 2, 1, stretch="lin") 


# Classificazione
clas20 <- unsuperClass(imm20, nClasses=3)
plot(clas20$map)

clas21 <- unsuperClass(imm21, nClasses=3)
plot(clas21$map)

### dò i colori che voglio io alle classi oppure lascio quelli di default???

# le 3 classi ottenute nelle due immagini comprendono diversi soggetti per cui le frequenze delle classi delle immagini non saranno comparabili 

# Calcolo delle frequenze per ogni immagine
freq(clas20$map)
freq(clas21$map)
# sono presenti NA, che in seguito saranno ignorati

# Immagine del 2020, pre-incendi
# classe 1: zone terrose: 5526646 pixels
# classe 2: nuvole e neve: 110040 pixels
# classe 3: foresta e acqua: 9575093 pixels
# (NA: 777 pixels)

# totale pixels (NA esclusi)
tot20 <- 15211779

# percentuale delle classi 
perc20_terr <- 5526646 * 100 / tot20
perc20_for_acq <- 9575093 * 100 / tot20
perc20_nev <- 110040 * 100 / tot20

# percentuali 
# zone terrose: 36.33% 
# foresta e acqua: 62.94%
# neve e nuvole: 0.72%

# Immagine del 2021, post-incendi
# classe 1: zone bruciate e acqua: 2653752 pixels
# classe 2: zone terrose: 4261279 pixels
# classe 3: foresta: 8297225 pixels
# (NA: 300 pixels)

# totale pixels (NA esclusi)
tot21 <- 15212256

# percentuale delle classi 
perc21_bruc_acq <- 2653752 * 100 / tot21
perc21_terr <- 4261279 * 100 / tot21
perc21_for <- 8297225 * 100 / tot21

# percentuali 
# zone bruciate e acqua: 17.44% 
# zone terrose: 28.01%
# foresta: 54.54%


##### Dataframe 
#### non sò se farlo o se è troppo uguale a quello fatto a lezione
## Valutare se ha senso metterlo
#classi_20 <- c("Zone terrose", "Foresta e acqua", "Neve e nuvole")
#perc20 <- c(36.33, 62.94, 0.72)
#classi_21 <- c("Zone bruciate e acqua", "Zone terrose", "Foresta")
#perc21 <- c(17.44, 28.01, 54.54)

#df_20 <- data.frame(nomclass20, perc20)
#df_21 <- data.frame(nomclass21, perc21)

#ggplot(df_20, aes(x=nomclass20, y=perc20, color=classi_20)) +
#  geom_bar(stat="identity", fill="white")
#ggplot(df_21, aes(x=nomclass21, y=perc21, color=classi_21)) +
#  geom_bar(stat="identity", fill="white")


# Analisi delle componenti principali
# prima ricampionare per facilitare la pca
### farlo PER LE DUE immagini o solo per una????

# Ricampionamento dell'immagine
ric21 <- aggregate(imm21, fact=10)

# plottare l'immagine ricampionata e confrontarla con l'immagine originale
par(mfrow=c(1,2))
plotRGB(imm21, 4, 3, 2, stretch="lin")
plotRGB(ric21, 4, 3, 2, stretch="lin")

# Pca con l'immagine ricampionata
pca_ric21 <- rasterPCA(ric21)
pca_ric21

# plottare la pca 
plot(pca_ric21$map, col=cl)

summary(pca_ric21$model)
# le prime due componenti rappresentano il 99,5% della variabilità

# Plottare le prime due componenti
gp1 <- ggplot() +
       geom_raster(pca_ric21$map, mapping =aes(x=x, y=y, fill=PC1)) +
       scale_fill_viridis(option = "inferno") +
       ggtitle("PC1")
gp2 <- ggplot() +
       geom_raster(pca_ric21$map, mapping =aes(x=x, y=y, fill=PC2)) +
       scale_fill_viridis(option = "inferno") +
       ggtitle("PC2")
gp1+gp2

# Mappa con la componente principale
# PC1 rappresenta il 75% della variabilità
pc1_21 <- pca_ric21$map[[1]]

# Deviazione standard per PC1
sd_pc1_21 <- focal(pc1_21, matrix(1/9, 3, 3), fun=sd)

# plottare la deviazione standard di PC1
ggplot() +
  geom_raster(sd_pc1_21, mapping =aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis(option = "inferno") +
  ggtitle("Deviazione standard di PC1")

# Plottare le prime tre componenti principali con plotRGB
plotRGB(pca_ric21$map, 1, 2, 3, stretch="lin")

# Confrontare le immagini del 2020 e 2021
#### voglio fare il confronto???? ### nel caso inverto l'ordine (prima 2020, poi 2022)???
ric20 <- aggregate(imm20, fact=10)
pca_ric20 <- rasterPCA(ric20)

plot(pca_ric20$map, col=cl)
summary(pca_ric20$model)
# PC1 rappresenta l'82,5% della varianza, mentre le prime due componenti il 98,9%

#par(mfrow=c(1,2))
plotRGB(pca_ric20$map, 1, 2, 3, stretch="lin")
#plotRGB(pca_ric21$map, 1, 2, 3, stretch="lin")
### a senso farlo???
### a senso fare il confronto oppure posso metterlo solo per vedere pca 
# anche dell'altra immagine??



