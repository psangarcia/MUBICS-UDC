################################################################################
##                                                                             #
##                                CASO PRÁCTICO                                #
##                                                                             #
##                Métodos Estadísticos Avanzados en Bioinformática             #
##                                                                             #
##          Máster en Bioinformática para Ciencias de la Salud (MUBICS)        #
##                                                                             #
##                    Curso 2021-2022 | Pedro Sánchez García                   #
##                                                                             #
################################################################################


################################################################################
## ----Pregunta 2a--------------------------------------------------------------
library(affy)

## Generación de la ruta a los microarrays
getwd()

dirdat <- '/Users/pedrosanchezgarcia/Desktop/MUBICS_UDC/MEAB/TRABAJO_MEAB/GSE132575'

## Ruta a los datos fenotipicos:
archfeno <- '/Users/pedrosanchezgarcia/Desktop/MUBICS_UDC/MEAB/TRABAJO_MEAB/GSE132575/phenoGSE132575.txt'

## Es preciso el campo 'compress = TRUE' dado que los archivos CEL están comprimidos:
gse132575 <- ReadAffy(celfile.path = dirdat, phenoData = archfeno, compress = TRUE)

## Comprobación de la clase del objeto:
class(gse132575)

## Verificación del tipo de clase:
isS4(gse132575)

## Slots presentes en la clase:
getSlots("AffyBatch")

## ----Pregunta 2b--------------------------------------------------------------
phenoData(gse132575) 
cdfName(gse132575)
nrow(gse132575)
ncol(gse132575)
assayData(gse132575) 
featureData(gse132575) 
experimentData(gse132575) 
annotation(gse132575) 
protocolData(gse132575) 
classVersion(gse132575) 

## ----Pregunta 2c--------------------------------------------------------------
gse132575@phenoData ## Acceso mediante el operador @ al slot phenoData
phenoData(gse132575) ## Acceso a través de la función de acceso homónima al slot phenoData

sampleNames(gse132575) ## Acceso a sampleNames por la función de acceso homónima
sampleNames(phenoData(gse132575)) # Acceso con una sintaxis menos conveniente

## ----Pregunta 2d--------------------------------------------------------------
assayData(gse132575)
gse132575@assayData

ls(assayData(gse132575)) # Contenido del environment analizado de assayData
head(assayData(gse132575)[["exprs"]]) # Cabecera de matriz con intensidades de fluorescencia del microarray

## ----Pregunta 2e--------------------------------------------------------------
getMethod("exprs", signature = "AffyBatch")

extends("AffyBatch", "eSet") # Verificamos la extensión de esET
showMethods("phenoData") # Obtenemos que son métodos que se heredan de eSet

getMethod("phenoData", signature = "AffyBatch") # Conduce a error
getMethod("phenoData", signature = "eSet")

################################################################################
## ----Pregunta 3a--------------------------------------------------------------
nrow(assayData(gse132575)[["exprs"]]) 
nrow(intensity(gse132575)) # Acceso alternativo a las intensidades

## ----Pregunta 3b--------------------------------------------------------------
length(probeNames(gse132575)) ## Número de pares de sondas
length(probeNames(gse132575))*2 ## Número de sondas

## ----Pregunta 3c--------------------------------------------------------------
## El número de sondas es inferior al de lecturas de intensidad en los microarrays.
## Esto se debe principalmente a que existen sondas destinadas a otras funciones,
## tales el control de ruido e hibridaciones inespecíficas en el microarray.

## ----Pregunta 3d--------------------------------------------------------------
library(ath1121501cdf) # Carga necesaria del paquete ath1121501cdf
ath1121501cdf
length(featureNames(gse132575)) ## Uso de featureNames para responder al número de conjuntos de pares de sondas

################################################################################
## ----Pregunta 4---------------------------------------------------------------

pm <- pmindex(gse132575)[["1415670_at"]]
mm <- mmindex(gse132575)[["1415670_at"]]
dePosicionATipoDeSonda <- function(a, b) {
  if(b %in% pm) {
    print('PM')
  } else if(b %in% mm) {
    print('MM')
  } else {
    print('Ninguno')}}

## ----Pregunta 4 REFERENCIA----------------------------------------------------

pm <- pmindex(gse132575)[["1415670_at"]]
mm <- mmindex(gse132575)[["1415670_at"]]
dePosicionATipoDeSonda <- function (affybatch, posicion) {
  PM <- pmindex(affybatch)
  MM <- mmindex(affybatch)
  resultado <- 'Ninguno'
  for (n in 1:length(PM)) {
    if (is.element(posicion, PM[[n]])) {
      resultado <- 'PM'
      return(resultado)}}
  for (n in 1:length(MM)) {
    if (is.element(posicion, MM[[n]])) {
      resultado <- 'MM'
      return(resultado)}}
  return(resultado)
}

dePosicionATipoDeSonda(gse132575, 471259)

################################################################################
## ----Pregunta 5a--------------------------------------------------------------
RNGkind(kind = "Mersenne-Twister", normal.kind = "Inversion", sample.kind = "Rejection")

dni <- 49333073

set.seed(dni)
id5 <- sample(length(featureNames(gse132575)), size = 1)
featureNames(gse132575)[id5]
## --En el presente proyecto, se alcanza "1433854_at" --------------------------
pm(gse132575, "1433854_at")
probeset(gse132575, "1433854_at") # Búsqueda mediante el método probeset

## --En el presente proyecto, realmente, se alcanza "1455065_x_at" -------------
pm(gse132575, "1455065_x_at")
probeset(gse132575, "1455065_x_at") # Búsqueda mediante el método probeset

## ----Pregunta 5b--------------------------------------------------------------
pm(gse132575[, "GSM3876426.CEL.gz"], "1433854_at")

## ----Pregunta 5b--------------------------------------------------------------
pm(gse132575[, "GSM3876426.CEL.gz"], "1455065_x_at")

## ----Pregunta 5c--------------------------------------------------------------
mm(gse132575[, "GSM3876426.CEL.gz"], "1433854_at")

## ----Pregunta 5c--------------------------------------------------------------
mm(gse132575[, "GSM3876426.CEL.gz"], "1455065_x_at")

## ----Pregunta 5d--------------------------------------------------------------
plot(pm(gse132575[, 1], "1433854_at"), type = "b", col = "red", xlab = "Sonda nº",
      ylab = "Intensidad", ylim = c(0, 2000), lab = c(10, 10, 7),
      main = "Conjunto de sondas 1433854_at")
 lines(mm(gse132575[, 1], "1433854_at"), type = "b", lty = 2, col = "blue")
 legend("topleft", legend = c("PM", "MM"), lty = 1:2, col = c("red", "blue"))
 
 ## ----Pregunta 5d-------------------------------------------------------------
 plot(pm(gse132575[, 1], "1455065_x_at"), type = "b", col = "red", xlab = "Sonda nº",
      ylab = "Intensidad", ylim = c(0, 2000), lab = c(10, 10, 7),
      main = "Conjunto de sondas 1455065_x_at")
 lines(mm(gse132575[, 1], "1455065_x_at"), type = "b", lty = 2, col = "blue")
 legend("topleft", legend = c("PM", "MM"), lty = 1:2, col = c("red", "blue"))

 ## ----Pregunta 5e-------------------------------------------------------------
 pmindex(gse132575)
 
 ###############################################################################
 ## ----Pregunta 6a-------------------------------------------------------------
 dni <- 49333073
 set.seed(dni)
 
 id6 <- sample(c("Espontáneo", "Tratamiento"), size = 1)
 id6
 ## --En el presente proyecto, se alcanza id6 de "Espontáneo" ------------------
 
 ## Nos centramos en los tratamientos "espontáneo", que hemos definido en el archivo 
 ## phenoGSE132575.txt como spnt:
 par(mfrow = c(6, 6), mar= c(1, 1 , 1, 1), oma = c(2, 2, 0, 0))
 for (i in 7:12) {
     for(j in 7:12) {
         if (j <= i) {
             plot(1, 1, type = "n", axes = FALSE)
             if (i == j) {
                 box()
                 text(1, 1, labels = paste("Microarray", i, paste("\n(", sampleNames(gse132575)[i], ")", sep = "")), cex = 1.1)
             }
         }
         else {
             ma.plot(A = (log2(pm(gse132575[, i])) + log2(pm(gse132575[, j])))/2, M = log2(pm(gse132575[, i])) - log2(pm(gse132575[, j])), 
                     add.loess = FALSE, plot.method = "smoothScatter", 
                     cex = 0.9, cex.main = 0.9, xlab = "", ylab = "", tcl = NA, mgp = c(3, 0.2, 0))
         }
     }
 }
 mtext("A", side = 1, line = 1.1, outer = TRUE, cex = 2)
 mtext("M", side = 2, line = 0.1, outer = TRUE, cex = 2, las = 1)
 box("inner")

 ## ----Pregunta 6b-------------------------------------------------------------
 ## Pares de microarrays 7 y 9, con valor de mediana en valor absoluto de 0.263.
 
 ## ----Pregunta 6c-------------------------------------------------------------
# Se procede a la generación de un vector donde se añade, en cada iteración realizada, 
# el valor absoluto de la mediana de M, mostrando finalmente el resultado alcanzado:
vector_final = c()
for (i in 7:12) {
  for(j in 7:12) {
      M  <- abs(median(log2(pm(gse132575[, i])) - log2(pm(gse132575[, j]))))
      vector_final <- c(vector_final, M)
    }
  }
print(max(vector_final))

 ###############################################################################
 ## ----Pregunta 7a-------------------------------------------------------------
 dni <- 49333073
 set.seed(dni)
 
 nombres.id <- c("1415789_a_at", "1415861_at", 
                 "1416240_at", "1417612_at", 
                 "1421320_a_at", "1421899_a_at", 
                 "1423997_at", "1425128_at",
                 "1428553_at", "1428689_at", 
                 "1429840_at", "1430649_at", 
                 "1434268_at", "1435718_at", 
                 "1437060_at", "1439922_at", 
                 "1440278_at", "1440867_at", 
                 "1441604_at", "1441876_x_at", 
                 "1442171_at", "1452055_at", 
                 "1455720_at", "1456500_at", 
                 "1456753_at", "1457629_at", 
                 "1459034_at", "1459825_x_at")
 id7 <- sample(nombres.id, size = 1)
 id7
 ## --En el presente proyecto, se alcanza el conjunto de sondas "1456753_at" ---
 annotation(gse132575)
 library(mouse4302.db)
 library(annotate)
 
## Empleamos which para tener conocimiento de la posición del conjunto de sondas:
 which(featureNames(gse132575) == "1456753_at")
 
## Se trata de la posición 41048 en el presente caso
 featureNames(gse132575)
 get(featureNames(gse132575)[41048], envir = mouse4302SYMBOL)
## Nos conduce al gen "Foxo4"
 
## Otro modo de obtención del gen es mediante:
 getSYMBOL(featureNames(gse132575)[41048], "mouse4302")
 
## Para alcanzar el identificador de Entrez Gene:
 get(featureNames(gse132575)[41048], envir = mouse4302ENTREZID) ## ENTREZID: 54601
 
## ----Pregunta 7b--------------------------------------------------------------
 ## Consultas en el NCBI con los recursos de anotación de Bioconductor:
 get(featureNames(gse132575)[41048], envir = mouse4302CHR) # Cromosoma X
 get(featureNames(gse132575)[41048], envir = mouse4302CHRLOC) # Posición inicial en Cromosoma X: 101254527
 get(featureNames(gse132575)[41048], envir = mouse4302CHRLOCEND) # Posición final en Cromosoma X: 101260873
 get(featureNames(gse132575)[41048], envir = mouse4302GENENAME) # Nombre del gen: forkhead box O4
 
 ###############################################################################
 ## ----Pregunta 8a-------------------------------------------------------------
 gse132575.sub <- gse132575[,1:12]
 gse132575.sub
 gse132575.sub@phenoData
 head(assayData(gse132575.sub)[['exprs']])
 gse132575.cor <- bg.correct(gse132575.sub, method = 'rma') 
 
## ----Pregunta 8b--------------------------------------------------------------
gse132575.normcuant <- normalize(gse132575.cor, method = "quantiles", type = "pmonly")

## ----Pregunta 8c--------------------------------------------------------------
## Gráficos de densidad de los datos brutos, con corrección de fondo y normalizados:
x11()
par(mfrow = c(2,2))
hist(gse132575.sub, which = "pm", xlab = expression(paste(log[2], "Intensidad")),
     ylab = "Densidad", main = "Datos brutos")
legend("topright", legend = sampleNames(gse132575.sub), col = 1:4, lty = 1:4, cex = 0.7)
hist(gse132575.cor, which = "pm", xlab = expression(paste(log[2], "Intensidad")),
     ylab = "Densidad", main = "Con corrección de fondo")
legend("topright", legend = sampleNames(gse132575.sub), col = 1:4, lty = 1:4, cex = 0.7)
hist(gse132575.normcuant, which = "pm", xlab = expression(paste(log[2], "Intensidad")),
     ylab = "Densidad", main = "Normalizados (cuantiles)")
legend("topright", legend = sampleNames(gse132575.sub), col = 1:4, lty = 1:4, cex = 0.7)

################################################################################
## ----Pregunta 9---------------------------------------------------------------
# Función RMA de 1 sólo paso:
gse132575.rma <- rma(gse132575.sub)

## Mediante el método expresso:
gse132575.expresso <- expresso(gse132575.sub, bgcorrect.method = "rma", normalize.method = "quantiles", 
                               pmcorrect.method = "pmonly", summary.method = "medianpolish")

################################################################################
## ----Pregunta 10--------------------------------------------------------------
## Visualizamos información general del objeto 'gse132575.rma':
gse132575.rma

## Creamos nuevo objeto con muestras control y espontáneo:
control <- which(gse132575.rma$treatment == "control")
espontáneo <- which(gse132575.rma$treatment == "spnt")

## Diagrama de volcán para identificar genes diferencialmente expresados entre espontáneo y control:
x11()
M.media <- apply(exprs(gse132575.rma), 1, function(x) mean(x[espontáneo]) - mean(x[-espontáneo]))
t.student <- apply(exprs(gse132575.rma), 1, function(x) t.test(x[espontáneo], x[-espontáneo])$statistic)
plot(M.media, abs(t.student), xlab = expression(bar(M)[espontáneo] - bar(M)[control]), 
     ylab = expression(italic(t)~de~Student~(valor~absoluto)), pch = ".")
abline(v = c(-1, 1), lty = "dashed")
abline(h = qt(0.975, 10), lty = "dashed")
points(M.media[abs(t.student) >  qt(0.975, 10)], abs(t.student[abs(t.student) > qt(0.975, 10)]), pch = ".", col = "red")

## Uso del paquete genefilter:
library(genefilter)
me1 <- median(apply(exprs(gse132575.rma), 1, IQR))
fun1 <- function(x) IQR(x) > me1
me2 <- median(apply(exprs(gse132575.rma), 1, median))
fun2 <- pOverA(0.1, me2)
funfiltro <- filterfun(fun1, fun2)
filt <- genefilter(exprs(gse132575.rma), funfiltro)
gse132575.rma.filt <- gse132575.rma[filt, ]

## Diagrama de volcán para el nuevo objeto gse132575.rma.filt resultante del filtrado:
x11()
M.media <- apply(exprs(gse132575.rma.filt), 1, function(x) mean(x[espontáneo]) - mean(x[-espontáneo]))
t.student <- apply(exprs(gse132575.rma.filt), 1, function(x) t.test(x[espontáneo], x[-espontáneo])$statistic)
plot(M.media, abs(t.student), xlab = expression(bar(M)[espontáneo] - bar(M)[control]), 
     ylab = expression(italic(t)~de~Student~(valor~absoluto)), pch = ".")
abline(v = c(-1, 1), lty = "dashed")
abline(h = qt(0.975, 10), lty = "dashed")
points(M.media[abs(t.student) >  qt(0.975, 10)], abs(t.student[abs(t.student) > qt(0.975, 10)]), pch = ".", col = "red")

## Variante del diagrama de volcán con -log10(p-valor):
x11()
p.valor <- apply(exprs(gse132575.rma.filt), 1, function(x) t.test(x[espontáneo], x[-espontáneo])$p.value)
plot(M.media, -log10(p.valor), xlab = expression(bar(M)[espontáneo] - bar(M)[control]), 
     ylab = expression(paste(-log[10],"(",italic(p),"-valor)")), pch = ".")
abline(v = c(-1, 1), lty = "dashed")
abline(h = -log10(0.05), lty = "dashed")
points(M.media[p.valor < 0.05], -log10(p.valor[p.valor < 0.05]), pch = ".", col = "red")
points(M.media[p.valor < 0.001], -log10(p.valor[p.valor < 0.001]), pch = ".", col = "blue")

## Uso del paquete limma de Bioconductor:
pData(gse132575.rma)

## Construcción de la matriz de diseño para los posteriores procedimientos:
matriz.diseño <- model.matrix(~ factor(treatment, levels = c("control", "spnt")),
                              pData(gse132575.rma.filt))
colnames(matriz.diseño) <- c("intercept", "espontáneo")
matriz.diseño

## Ajuste del modelo de regresión lineal con lmfit() del paquete limma:
library(limma)
gse132575.type.lmFit <- lmFit(gse132575.rma.filt, design = matriz.diseño)
gse132575.type.eBayes <- eBayes(gse132575.type.lmFit)

head(gse132575.type.eBayes$t)
head(gse132575.type.eBayes$p.value)

sum(gse132575.type.eBayes$p.value[, "espontáneo"] < 0.05)

head(topTable(gse132575.type.eBayes, coef = "espontáneo",
              number = sum(gse132575.type.eBayes$p.value[, "espontáneo"] < 0.05),
              adjust.method = "none", sort.by = "p"))

## Comparación gráfica de estadísticos t clásico y t moderado:
x11()
par(mfrow = c(1, 2), mar = c(5, 5, 2, 2))
smoothScatter(t.student, gse132575.type.eBayes$t[, "espontáneo"], pch=".", xlab = expression(Estadístico~italic(t)), 
              ylab = expression(Estadístico~italic(t)~~moderado))
abline(a = 0, b = 1, lty = "dashed", col = "red")
smoothScatter(-log10(p.valor), -log10(gse132575.type.eBayes$p.value[, "espontáneo"]), 
              pch=".", xlab = expression(paste(-log[10],"(",italic(p),"-valor) del estadístico ", 
                                               italic(t))), ylab = expression(paste(-log[10],
                                                                                    "(",italic(p),"-valor) del estadístico ", 
                                                                                    italic(t), " moderado")))
abline(a = 0, b = 1, lty = "dashed", col = "red")

## Multiplicidad de contrastes empleando multtest:
library(multtest)
gse132575.type.pval <- mt.rawp2adjp(gse132575.type.eBayes$p.value[,  "espontáneo"], 
                                    proc = c("Bonferroni", "SidakSS", "Holm", "Hochberg", "BH", "BY"))
gse132575.type.pval$adjp[1:11,]
gse132575.type.pval$index[1:11]

## Resumen gráfico con mt.plot de los resultados alcanzados:
x11()
mt.plot(adjp = gse132575.type.pval$adjp, plottype = "pvsr", proc = c("Sin ajustar", "Bonferroni", "Sidak", "Holm", "Hochberg", 
                                                                     "Benjamini-Hochberg", "Benjamini-Yekutieli"), 
        leg = c(4500, 0.5), col = c(1:6, 8), lty = 1:7, cex = 0.5)
abline(h = 0.05, lty = "dotted")

## Determinación de la identidad de los genes que se expresan diferencialmente:

## Directamente, con topTable():
rownames(topTable(gse132575.type.eBayes, coef = "espontáneo", number = Inf, p.value = 0.05, adjust.method = "BH", sort.by = "p"))

## Indirectamente, procesando el objeto creado por mt.rawp2adjp():
featureNames(gse132575.rma.filt[gse132575.type.pval$index[gse132575.type.pval$adjp[, "BH"] < 0.05],])
annotation(gse132575.rma.filt)
library(mouse4302.db)
library(annotate)
getSYMBOL(featureNames(gse132575.rma.filt[gse132575.type.pval$index[gse132575.type.pval$adjp[, "BH"] < 0.05], ]), "mouse4302")

## Muestra de la cabecera correspondiente al resultado anterior:
head(getSYMBOL(featureNames(gse132575.rma.filt[gse132575.type.pval$index[gse132575.type.pval$adjp[, "BH"] < 0.05], ]), "mouse4302"))
