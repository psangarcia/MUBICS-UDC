# Fundamentos de Bioinformática
# Pedro Sánchez García

# Lab6: Predicción de localización subcelular de proteínas

# Se parte de un conjunto de datos con las secuencias de 3.134 proteínas,
# clasificadas en 14 localizaciones subcelulares. 
# Las dos clases contienen 325 proteínas extracelulares y 307 mitocondriales.
# En primer lugar, se carga el paquete Rcpi y se leen las secuencias de las proteínas
# en formato FASTA ubicadas en ficheros independientes.
library("Rcpi")
extracell <- readFASTA(system.file(
  "vignettedata/extracell.fasta",
  package = "Rcpi"
))
mitonchon <- readFASTA(system.file(
  "vignettedata/mitochondrion.fasta",
  package = "Rcpi"
))

# Comprobamos el número de secuencias existentes en la lista para cada tipo de proteína:
length(extracell)
length(mitonchon)

# Dado que Rcpi presenta la limitación de que no trabaja con aminoácidos no estándar,
# es preciso llevar a cabo un filtrado para eliminar aquellas proteínas con estos aminoácidos.
# Para ello, empleamos la función CheckProt() sobre las secuencias:
extracell <- extracell[(sapply(extracell, checkProt))]
mitonchon <- mitonchon[(sapply(mitonchon, checkProt))]

# Comprobamos, de nuevo, el número de secuencias existentes en cada tipo de proteína:
length(extracell)
length(mitonchon)
# Los resultados obtenidos muestran que se han eliminado 2 secuencias de cada clase.

# Sobre las secuencias actuales, se calculan los descriptores APAAC, que evalúan la
# composición anfifílica de cada aminoácido en la secuencia. 
# Se aplica la función extract con sapply, mediante la cual se extraen los decriptores APAAC de las proteínas.
# Estos descriptores se han asignado como x1 y x2 para los 2 tipos de proteínas.
x1 <- t(sapply(extracell, extractProtAPAAC))
x2 <- t(sapply(mitonchon, extractProtAPAAC))

# Posteriormente, se genera la unión de x1 y x2 en una variable, lo que nos genera un conjunto de filas para x1 y otro para x2:
x <- rbind(x1, x2)

# Para comprobar que el conjunto de datos generado es correcto, introducimos el nombre en consola:
x

# Ahora, se generan las etiquetas para realizar el modelo de clasificación random forest:
labels <- as.factor(c(rep(0, length(extracell)), rep(1, length(mitonchon))))
# Estas etiquetas nos permiten llevar a cabo la posterior clasificación de las proteínas

# A partir del conjunto generado, se destina un 75% para el entreno y 25% para test.
# Se rompe el conjunto de datos de forma aleatoria, tomando 75% para training y 25% de test. 
# Cabe destacar, que el seed establecido nos permite reproducir el cálculo más adelante en la realización de otro proyecto científico.
set.seed(1001)

tr.idx <- c(
  sample(1:nrow(x1), round(nrow(x1) * 0.75)),
  sample(nrow(x1) + 1:nrow(x2), round(nrow(x2) * 0.75))
)
te.idx <- setdiff(1:nrow(x), tr.idx)

x.tr <- x[tr.idx, ]
x.te <- x[te.idx, ]
y.tr <- labels[tr.idx]
y.te <- labels[te.idx]

# Se elige random forest como el modelo de clasificación versátil y se efectúa el entrenamiento.
# El cross-validation interno presenta 5 repeticiones, de forma que se generan 
# 5 modelos con 5 conjuntos de datos fragmentados del conjunto original.
library("randomForest")
rf.fit <- randomForest(x.tr, y.tr, cv.fold = 5)
print(rf.fit)
# Comprobamos el resultado del entrenamiento con la tasa de error y matriz de confusión.
# La interpretación del resultado obtenido al ejecutarlo es una tasa de error ligeramente elevada (26,38%).
# Para comprender lo que sucede, observamos en la matriz de confusión un número algo elevado de clasificaciones erróneas.

# Una vez que el modelo se ha entrenado, se lleva a cabo una predicción:
rf.pred <- predict(rf.fit, newdata = x.te, type = "prob")[, 1]

# Se elabora una curva ROC que enfrenta sensibilidad y especificidad de la predicción efectuada:
library("pROC")
plot.roc(y.te, rf.pred, grid = TRUE, print.auc = TRUE)
# En ML resulta fundamental conocer el rendimiento de las clasificaciones.
# Por tanto, debemos tener en cuenta la sensibilidad (proporción de proteínas identificadas correctamente)
# Además, analizamos la especificidad (proporción de proteínas identificadas correctamente sobre total de proteínas de la clase en cuestión) )
# Visualizamos el gráfico en el que se enfrentan ambas y observamos el área bajo la curva de ROC.
# Cuanto más próximo a 1 sea el valor de la AUC, mejor será la clasificación del modelo, ya que separar las clases de forma perfecta.
# En este caso, el valor obtenido es de 0.870. 
# Este valor nos indica que existe una probabilidad del 87% de que el modelo nos clasifique correctamente una proteína que nos interese. 

