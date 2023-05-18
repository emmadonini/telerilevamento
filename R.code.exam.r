####### Titolo del progetto e della presentazione

#### ARGOMENTO 
# Interesse sui molteplici incendi avvenuti in British Columbia (Canada) nell'estate del 2021 tra fine Giugno e metà Agosto, sintomi anche dei cambiamenti climatici.
# Il progetto prende in esame un'area tra il distretto regionale di Thompson-Nicola e il distretto regionale di Cariboo.
# L'area analizzata comprende diversi incendi tra cui lo Sparks Lake Fire che è stato il più grande incendio per area bruciata in British Columbia in quei mesi. 
# Links utilizzati per l'identificazione degli incendi:
# https://cwfis.cfs.nrcan.gc.ca/interactive-map
# https://en.wikipedia.org/wiki/2021_British_Columbia_wildfires

# Utilizzo di immagini landsat scaricate dal link https://earthexplorer.usgs.gov/


#### SVILUPPO

# Richiamare pacchetti necessari
library(raster)
library(ggplot2)
library(RStoolbox) # per usare funzioni come rasterPCA e unsuperClass
library(patchwork)
library(viridis)

# Impostare la working directory
setwd("/Users/emma/Desktop/progetto_telerilevamento")


#### IMPORTARE

# Importate le 3 immagini che saranno utilizzate.
# Avendo scaricato le singole bande, usare la funzione list.files per creare la lista dei file da importare per ogni immagine.
# Usare la funzione lapply per importare i componenti della lista.
# Creare uno stack che contenga tutte le bande di un'immagine.

# Immagine del 10/05/2020: un anno prima degli incendi
list_20 <- list.files(pattern="047024_20200510")
imp_20 <- lapply(list_20, raster)
imm20 <- stack(imp_20)
imm20

# Immagine del 02/09/2021: subito dopo gli incendi
list_21 <- list.files(pattern="047024_20210902")
imp_21 <- lapply(list_21, raster)
imm21 <- stack(imp_21)
imm21

# Immagini del 27/07/2022: un anno dopo gli incendi
list_22 <- list.files(pattern="047024_20220727")
imp_22 <- lapply(list_22, raster)
imm22 <- stack(imp_22)
imm22

# Bande 
# blu : primo elemento (file B2)
# verde: secondo elemento (file B3)
# rosso: terzo elemento (file B4)
# nir: quarto elemento (file B5)

# Immagini a 16 bit e con risoluzione 30m


#### VISUALIZZARE LE IMMAGINI

# Plot bande 
clp <- colorRampPalette(c("blacK", "red","orange","yellow"))(100)
plot(imm20, col=clp) 
plot(imm21, col=clp) 
plot(imm22, col=clp) 
# Solo per vederle, ma non inserisco nella presentazione

# Visualizzare le immagini 
# Montare le bande per vedere l'immagine naturale: B4 sul rosso, B3 sul verde e B2 sul blu
# Applicare stretch="lin" per una migliore visione dell'immagine
g1 <- ggRGB(imm20, r=3, g=2, b=1, stretch="lin") + ggtitle("Immagine del 2020")
g2 <- ggRGB(imm21, r=3, g=2, b=1, stretch="lin") + ggtitle("Immagine del 2021")
g3 <- ggRGB(imm22, r=3, g=2, b=1, stretch="lin") + ggtitle("Immagine del 2022")
g1 + g2 + g3

# Visualizzare le immagini con banda del nir(B5) 
# B5 sul rosso, B4 sul verde e B3 sul blu
p1 <- ggRGB(imm20, r= 4, g=3, b=2, stretch="lin") + ggtitle("Immagine del 2020")
p2 <- ggRGB(imm21, r=4, g=3, b=2, stretch="lin") + ggtitle("Immagine del 2021")
p3 <- ggRGB(imm22, r=4, g=3, b=2, stretch="lin") + ggtitle("Immagine del 2022")
p1 + p2 + p3

# vedere nir come verde per definire meglio la vegetazione
#par(mfrow=c(1,3))
#plotRGB(imm20, 3, 4, 2, stretch="lin")
#plotRGB(imm21, 3, 4, 2, stretch="lin")
#plotRGB(imm22, 3, 4, 2, stretch="lin")
# Non inserisco nella presentazione

# confronto con stretch="hist" 
#par(mfrow=c(1,2))
#plotRGB(imm21, 4, 3, 2, stretch="lin")
#plotRGB(imm21, 4, 3, 2, stretch="hist")
# Non inserisco nella presentazione


#### INDICI SPETTRALI

# Calcolare DVI e NDVI per ogni immagine utilizzando le bande del nir e del rosso

## DVI: banda nir - banda rosso
dvi20 = imm20[[4]] - imm20[[3]]
dvi20

dvi21 = imm21[[4]] - imm21[[3]]
dvi21

dvi22 = imm22[[4]] - imm22[[3]]
dvi22

# Multiframe con i DVI per le tre immagini
# creare prima la palette
cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100) 

# plottare 
par(mfrow=c(1,3))
plot(dvi20, col=cl) + title(main="DVI 2020")
plot(dvi21, col=cl) + title(main="DVI 2021")
plot(dvi22, col=cl) + title(main="DVI 2022")


# DVI differenza tra 2020 e 2021 (prima e dopo gli incendi)
dvi_dif = dvi20 - dvi21
cld <- colorRampPalette(c('blue','white','red'))(100) 
plot(dvi_dif, col=cld) + title(main="Differenza DVI 2020 - 2021")

# DVI differenza nel tempo 
dvi_dif_20_22 = dvi20 - dvi22
dvi_dif_21_22 = dvi21 - dvi22

par(mfrow=c(1,3))
plot(dvi_dif, col=cld)
plot(dvi_dif_21_22, col=cld)
plot(dvi_dif_20_22, col=cld)
# Differenza DVI tra 2021 e 2022 situazione abbastanza costante,con alcuni punti che sembrano indicare miglioramento nelle zone bruciate.
# Differenza DVI tra 2020 e 2022 simile alla situazione di comparazione tra 2020 e 2021
# Non inserisco nella presentazione

## NDVI: (banda nir - banda rosso) / ( banda nir + banda rosso)
ndvi20 =  dvi20 / (imm20[[4]] + imm20[[3]])
ndvi20

ndvi21 =  dvi21 / (imm21[[4]] + imm21[[3]])
ndvi21

ndvi22 =  dvi22 / (imm22[[4]] + imm22[[3]])
ndvi22

# Multiframe con NDVI dei 3 anni
par(mfrow=c(1, 3))
plot(ndvi20, col=cl) + title(main="NDVI 2020")
plot(ndvi21, col=cl) + title(main="NDVI 2021")
plot(ndvi22, col=cl) + title(main="NDVI 2022")


#### Time series con le bande nir delle immagini

# Applicare le stesse extent affinchè sia possibile creare lo stack
n_imm20 <- projectRaster(imm20, imm21)
n_imm22 <- projectRaster(imm22, imm21)

# Creazione dello stack con le bande nir delle tre immagini
grup_nir <- stack(n_imm20[[4]], n_imm21[[4]], n_imm22[[4]])

ggRGB(grup_nir, 1, 2, 3, stretch="lin") + title(main="Nir time series")
#### non sò se posso farlo con solo banda nir
#### volendo provare con ndvi  ### vedere quale anno ha valori maggiori
# n_ndvi20 <- projectRaster(ndvi20, ndvi21)
# n_ndvi22 <- projectRaster(ndvi22, ndvi21)
# group_ndvi <- stack(n_ndvi20, ndvi21, n_ndvi22)
# ggRGB(group_ndvi, 1, 2, 3, stretch="lin") 
#### si potrebbe mettere con immagini intere
### oppure lo metto sul codice ma non sulla presentazione
#######################

# Scelgo d'ora in poi di usare le solo due immagini. Escludo l'immagine del 2022 vista la situazione simile al 2021

#### LAND COVER: Classificazione

###### set.seed(100)

## Classificare con quattro classi le immagini del 2020 e 2021
clas20 <- unsuperClass(imm20, nClasses=4)
clas21 <- unsuperClass(imm21, nClasses=4)

# creare la palette da usare nel plot delle immagini classificate
clc <- colorRampPalette(c("white", "darkorchid", "blue", "green"))(100)

# plottare le immagini ottenute
par(mfrow=c(1,2))
plot(clas20$map, col=clc) + title(main="Copertura del suolo 2020")
plot(clas21$map, col=clc) + title(main="Copertura del suolo 2021")

# Le 4 classi ottenute comprendono diversi soggetti per cui le frequenze delle classi non saranno strettamente comparabili. 

## Calcolare le frequenze per ogni immagine
freq(clas20$map)
freq(clas21$map)
# Sono presenti NA, che in seguito saranno ignorati nel calcolo delle frequenze

# Immagine del 2020, pre-incendi
# classe 1: foresta e acqua con 28436378 pixels
# classe 2: terra con 9695538 pixels
# classe 3: neve e nuvole con 817985 pixels
# classe 4: neve e nuvole con 1660725 pixels
# (NA: 21654755 pixels)

# totale pixels 2020 (NA esclusi)
tot20 <- 40610626

# percentuale delle classi del 2020
perc20_for_acq <- 28436378 * 100 / tot20
perc20_ter <- 9695538 * 100 / tot20
perc20_nev <- 817985 * 100 / tot20
perc20_nev2 <- 1660725 * 100 / tot20

# percentuali del 2020
# foresta e acqua: 70.02201% 
# terra: 23.87439%
# neve e nuvole: 2.014214% e 4.089385% = 6.103599%


# Immagine del 2021, post-incendi
# classe 1: terra con 11152946 pixels
# classe 2: foresta con 22795040 pixels
# classe 3: zone bruciate e acqua con 6291578 pixels
# classe 4: neve con 386089 pixels
# (NA: 21560318 pixels)

# totale pixels (NA esclusi)
tot21 <- 40625653

# percentuale delle classi 
perc21_ter <- 11152946 * 100 / tot21
perc21_for <- 22795040 * 100 / tot21
perc21_bruc_acq <- 6291578 * 100 / tot21
perc21_nev <- 386089 * 100 / tot21

# percentuali 
# terra: 27.45296% 
# foresta: 56.10997%
# zone bruciate e acqua: 15.48671%
# neve: 0.9503576%


## Creazione di istogrammi per rappresentare le classi e le loro frequenze

# Creare i dataframe per gli istogrammi
class0 <- c("Zone terrose", "Neve e nuvole", "Foresta e acqua")
perc20 <- c(23.87, 6.10, 70.03)
class1 <- c("Zone terrose", "Neve", "Zone bruciate e acqua", "Foresta")
perc21 <- c(27.45, 0.95, 15.49, 56.11)

df0 <- data.frame(class0, perc20)
df1 <- data.frame(class1, perc21)

# Grafici dei due anni
is1 <- ggplot(df0, aes(x=class0, y=perc20, color=class0)) +
     geom_bar(stat="identity", fill="white") +
     ggtitle("Copertura del suolo in % nel 2020") +
     labs(color="Classi", x="Classi", y="%")

is2 <- ggplot(df1, aes(x=class1, y=perc21, color=class1)) +
  geom_bar(stat="identity", fill="white") +
  ggtitle("Copertura del suolo in % nel 2021") + 
  labs(color="Classi", x="Classi", y="%")

is1 + is2


#### ANALISI DELLE COMPONENTI PRINCIPALI

# Per facilitare la pca ricampionare le immagini così da renderle più leggere e facilmente elaborabili

## Ricampionamento delle immagini del 2020 e 2021
ric20 <- aggregate(imm20, fact=10)
ric21 <- aggregate(imm21, fact=10)

# Plottare un'immagine ricampionata e confrontarla con l'immagine originale
# par(mfrow=c(1,2))
# plotRGB(imm21, 4, 3, 2, stretch="lin")
# plotRGB(ric21, 4, 3, 2, stretch="lin")

## Eseguire l'analisi delle componenti principali sulle immagini ricampionate
pca_ric20 <- rasterPCA(ric20)
pca_ric20
pca_ric21 <- rasterPCA(ric21)
pca_ric21

# Plottare le componenti principali
plot(pca_ric20$map, col=cl) 
plot(pca_ric21$map, col=cl)

# Visualizzare con la variabilità delle componenti principali
summary(pca_ric20$model)
summary(pca_ric21$model)
# In entrambi i casi l'insieme delle prime due componenti (Cumulative Proportion), rappresentano più del 99% della variabilità
# La PC1 dell'immagine del 2020 spiega il 97,2% della variabilità, la PC1 dell'immagine del 2021 invece l'84,1%

# Plottare le prime due componenti per l'immagine del 2020
# uso di viridis 
gp1 <- ggplot() +
  geom_raster(pca_ric20$map, mapping =aes(x=x, y=y, fill=PC1)) +
  scale_fill_viridis(option = "inferno") +
  ggtitle("PC1 2020")
gp2 <- ggplot() +
  geom_raster(pca_ric20$map, mapping =aes(x=x, y=y, fill=PC2)) +
  scale_fill_viridis(option = "inferno") +
  ggtitle("PC2 2020")
gp1+gp2

# Plottare le prime due componenti per l'immagine del 2021
gr1 <- ggplot() +
  geom_raster(pca_ric21$map, mapping =aes(x=x, y=y, fill=PC1)) +
  scale_fill_viridis(option = "inferno") +
  ggtitle("PC1 2021")
gr2 <- ggplot() +
  geom_raster(pca_ric21$map, mapping =aes(x=x, y=y, fill=PC2)) +
  scale_fill_viridis(option = "inferno") +
  ggtitle("PC2 2021")

gr1+gr2


# VARIABILITA' # Non inserire nella presentazione, non molto significativo

# Calcolare la deviazione standard per la PC1 delle immagini
# usare una matrice 3 x 3
sd_pc1_20 <- focal(pca_ric20$map[[1]], matrix(1/9, 3, 3), fun=sd)
sd_pc1_21 <- focal(pca_ric21$map[[1]], matrix(1/9, 3, 3), fun=sd)

# Plottare la deviazione standard di PC1
ps1 <- ggplot() +
  geom_raster(sd_pc1_20, mapping =aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis(option = "inferno") +
  ggtitle("Deviazione standard di PC1 2020")
ps2 <- ggplot() +
  geom_raster(sd_pc1_21, mapping =aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis(option = "inferno") +
  ggtitle("Deviazione standard di PC1 2021")

ps1 + ps2


# Plottare le prime tre componenti principali con plotRGB
#plotRGB(pca_ric20$map, 1, 2, 3, stretch="lin")
#plotRGB(pca_ric21$map, 1, 2, 3, stretch="lin")
##### molto bello ma non sò a che serve quindi potrei non metterlo manco nel codice





