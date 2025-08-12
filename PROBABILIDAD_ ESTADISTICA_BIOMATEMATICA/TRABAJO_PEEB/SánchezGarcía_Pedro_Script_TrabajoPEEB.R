# Probabilidad, Estadística y Elementos de Biomatemática
# Máster en Bioinformática para Ciencias de la Salud (MUBICS)
# Curso 2021-2022 | Pedro Sánchez García

# Trabajo 2. ¿Influye la dieta en el peso de los pollos?

################################################################################
# ANÁLISIS EXPLORATORIO GENERAL 

# Obtenemos información del conjunto de datos correspondiente (ChickWeight):
ChickWeight

# Abreviamos la notación a lo largo de los análisis
weight <- ChickWeight$weight
time <- ChickWeight$Time
diet <- ChickWeight$Diet

# Obtenemos un resumen del conjunto de datos
summary(ChickWeight)

# Evaluamos otros estadísticos básicos para el peso corporal de los pollos
library(e1071)
sd(weight)
skewness(weight)
kurtosis(weight)

# Llevamos a cabo un análisis gráfico del peso corporal en gramos de los pollos:

# Diagrama de dispersión
plot(time, weight)
# Histograma
hist(weight)
# Gráfica de la función de densidad
plot(density(weight))
# Diagrama de cajas y bigotes
boxplot(weight)

# Analizamos si los datos del peso corporal de pollos siguen distribución normal:
shapiro.test(weight)

################################################################################
# ANÁLISIS EXPLORATORIO POR DIETAS 

# Se cargan los siguientes paquetes:
library(foreign)
library(car)
library(gplots)
library(agricolae)
library(asbio)
library(multcomp)
library(multcompView)
library(nortest)
library(tseries)

# Se lleva a cabo un resumen numérico con los principales descriptivos según dietas:
tapply(weight,diet,summary)		# cuantiles por dietas
tapply(weight,diet,mean)			# medias por dietas
tapply(weight,diet,sd)			# desviaciones estándar por dietas

# Diagramas de cajas y de medias por dietas con librería gplot:
Boxplot(weight~diet)			# Diagrama de cajas
x11()
plotmeans(weight~diet,p=0.95)		# Diagrama de medias con intervalos de confianza al 95%

################## Inferencia sobre el modelo ANOVA I:##########################
LM.1 <- lm(weight~diet)	 # Se lleva a cabo un planteamiento en formato de regresión con las variables indicadoras
summary(LM.1)
confint(LM.1,level=0.95) # Obtención de intervalos de confianza al nivel de confianza del 95%

# Para llevar a cabo determinadas funciones, es preciso generar el siguiente objeto:
objeto<-aov(weight~diet)		

# Obtención de las medias estimadas y los efectos con respecto a la media general
model.tables(objeto, type = "means", se = TRUE)		# Medias estimadas
model.tables(objeto, type = "effects", se = TRUE)		# Efectos

# Análisis de la varianza:
Anova(LM.1)

###################### Comparaciones múltiples: ################################
 
# Se lleva a cabo el test de Tukey con la siguiente función:
out1.tuk <- TukeyHSD(objeto, which="diet", conf.level = 0.95, ordered = TRUE)
out1.tuk
plot(out1.tuk)

###################### Diagnosis del modelo: ###################################

# Obtención de los residuos estandarizados con la función stdres() del paquete MASS:
library(MASS) ; residuos <- stdres(LM.1)

# Obtención de los gráficos de diagnóstico de los residuos en una ventana con 4 paneles:
# x11()
par(mfrow=c(2,2)) 					# División de la ventana gráfica en 4 paneles  
plot(LM.1)					# Obtención de los gráficos correspondientes

# Obtención de un histograma con los residuos estandarizados para el análisis de la normalidad:
h<- hist(residuos,plot=FALSE)	 ; M <- max(h$density)	
plot(h,freq=FALSE, ylim=c(0,max(M,0.45)))		# Histograma de los residuos estandarizados
curve( dnorm, col="red", add=TRUE)			# Se superpone la densidad de una normal estándar

######## Realización de pruebas analíticas sobre normalidad, homocedasticidad, aleatoriedad y datos atípicos:

# Normalidad: Prueba de Shapiro-Wilk
shapiro.test(residuos)				

# Homoscedasticidad (varianza constante):
leveneTest(LM.1)   # Prueba de Levene

# Aleatoriedad 
Box.test(residuos, lag = 5, type = "Ljung-Box")		# Prueba de Ljung-Box 

# Datos atípicos con la prueba de Bonferroni:
outlierTest(LM.1)					

################### Contraste no paramétrico: Kruskal-Wallis: ##################
kruskal.test(weight~diet)

