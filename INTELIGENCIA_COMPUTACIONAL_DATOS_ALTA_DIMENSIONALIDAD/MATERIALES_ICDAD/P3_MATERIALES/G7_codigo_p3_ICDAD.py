# coding: utf-8
# PRÁCTICA 3 - INTELIGENCIA COMPUTACIONAL PARA DATOS DE ALTA DIMENSIONALIDAD
# G7 - CRISTIAN MORILLO LOSADA | PEDRO SÁNCHEZ GARCÍA

##################################################################################################################
############################################ PREGUNTA 1 ##########################################################
##################################################################################################################

# Cargamos el correspondiente DataFrame a partir del fichero csv proporcionado:
df = spark.read.csv('/media/sf_PR_ICDAD/Materiales_parte3/RLS.csv', header=True)

# 1.) ¿Cuántas especies (Taxon) distintas se han identificado?

especies = df.groupBy('Taxon').count()

print('Se han identificado {0} especies distintas'.format(especies.count()))

# 2.) ¿Cuáles son las 10 familias con mayor recuento (Total)?

# Creamos una tabla (RLS) a partir del dataFrame. Planteamos la consulta, ordenando por recuento:
df.createOrReplaceTempView('RLS')

spark.sql('select Family as familias, count(*) as recuento from RLS group by familias order by recuento desc').show(10)

# 3.) ¿En qué “eco regiones” de España se han realizado mediciones? 

spark.sql('select Ecoregion as eco_regiones from RLS where Country = "Spain" group by eco_regiones order by eco_regiones asc').show()

# 4.) ¿Cuántas familias tienen recuentos totales inferiores a 10?

familias_10 = df.filter(df.Total < 10).select('Family').distinct().count()

print('Se han identificado {0} familias con recuentos inferiores a 10'.format(familias_10))

# 5.) ¿Cuántos individuos se encontraron en la survey que más individuos encontró en una región española?

spark.sql('select SurveyID, Country, sum(Total) as individuos from RLS where Country = "Spain" group by SurveyID, Country order by individuos desc').show(1)

##################################################################################################################
############################################ PREGUNTA 2 ##########################################################
##################################################################################################################

## 1.) De cada medición, quédate con las variables SurveyID, SiteLat, SiteLong,Family y Total:
df_original = spark.read.csv('/media/sf_PR_ICDAD/Materiales_parte3/RLS.csv', header=True)

df = df_original['SurveyID', 'SiteLat', 'SiteLong', 'Family', 'Total']

## 2.) Usando el API de RDDs, agrupa las mediciones por survey para obtener, para cada survey, un 
## listado de tuplas (Family, Total) que representan cuántos individuos de esa familia se encontraron.

### 2.1) Conversión df -> RDD, agrupación por survey y comprobación del listado de tuplas (Family, Total):

rdd1 = df.rdd.map(lambda x:[x[0],float(x[1]),float(x[2]), x[3],x[4]])

rdd2 = rdd1.map(lambda x: ((x[0],x[1],x[2]), (x[3],x[4]))).groupByKey().mapValues(list)

## 3.) Utiliza la función toVector suministrada para transformar esa lista de tuplas
## en un vector (lista de Python) que registre en qué proporción aparecen
## representadas en ese survey cada una de las familias que se registran en este conjunto de datos.

# Listado de familias contenidas en el conjunto de datos:
familias=[linea.rstrip() for linea in open("/media/sf_PR_ICDAD/Materiales_parte3/familias.txt",'r').readlines()]

# Listado de 10 familias (Random Forest Regressor) más relevantes en predcciones dentro del conjunto de datos:
# familias=[linea.rstrip() for linea in open("/media/sf_PR_ICDAD/Materiales_parte3/10_familias_rf.txt",'r').readlines()]

# Listado de 10 familias (Decission Tree Regressor) más relevantes en predcciones dentro del conjunto de datos:
# familias=[linea.rstrip() for linea in open("/media/sf_PR_ICDAD/Materiales_parte3/10_familias_dt.txt",'r').readlines()]

import numpy as np

def toVector(familyCountList: list) -> list:
    '''
    Transforma una lista de tuplas (nombre_familia, recuento) a un vector que
    indica en qué proporción aparece cada una de las familias de interés
    '''
    counts=np.zeros(len(familias))
    for (f,c) in familyCountList:
        if f in familias:
            counts[familias.index(f)]=float(c)
    total=np.sum(counts)
    if total==0:
        return counts
    return (counts/total).tolist()

rdd3 = rdd2.map(lambda x: (x[0], toVector(x[1]))) 

## 4.) Obtén el DataFrame requerido transformando cada elemento del RDD en una Row con la función pasaFilaARow suministrada.
from pyspark.sql.types import Row
from pyspark.ml.linalg import Vectors

def pasaFilaARow(x:any) -> Row:
    '''
    Recibe un elemento de cualquier tipo y lo transforma en un Row de pyspark
    '''
    # Utilizaremos este diccionario para definir los campos de la Row y sus valores
    d = {}
    # TODO - Definimos los campos correspondientes
    d["SurveyID"] = x[0][0] 
    d["SiteLat"] = x[0][1]
    d["SiteLong"] = x[0][2]
    d["Vector"] = Vectors.dense(x[1])
    return Row(**d)

pasafilarow = rdd3.map(lambda x: pasaFilaARow(x))

dataframe_p2 = pasafilarow.toDF()

##################################################################################################################
############################################ PREGUNTA 3 ##########################################################
##################################################################################################################

## Entrena un modelo Random Forest Regression y calcula su precisión, en términos del error cuadrático medio, a la 
## hora de predecir la latitud de cada survey atendiendo a los recuentos de especies.
dataframe_p3 = dataframe_p2['Vector','SiteLat']

from pyspark.ml.regression import RandomForestRegressor
from pyspark.ml.evaluation import RegressionEvaluator

# Separamos el dataframe en conjuntos de entrenamiento (70%) y test (30%):
(trainingData, testData) = dataframe_p3.randomSplit([0.7, 0.3])

# Comprobamos la cantidad de datos manejados en cada caso:
print(trainingData.count()) # 9383
print(testData.count()) # 4070

## Planteamiento del modelo bajo parámetros estándar:
rf = RandomForestRegressor(labelCol="SiteLat", featuresCol="Vector",numTrees=2, maxDepth=2, seed=42) # 16.08

## Pruebas realizadas para ajustas parámetros y reducir el rmse:

# Con maxDepth = 5:
rf = RandomForestRegressor(labelCol="SiteLat", featuresCol="Vector",numTrees=20, maxDepth=5, seed=42)  # 11.52
rf = RandomForestRegressor(labelCol="SiteLat", featuresCol="Vector",numTrees=30, maxDepth=5, seed=42)  # 11.27
rf = RandomForestRegressor(labelCol="SiteLat", featuresCol="Vector",numTrees=50, maxDepth=5, seed=42)  # 11.23

# Con maxDepth = 10:
rf = RandomForestRegressor(labelCol="SiteLat", featuresCol="Vector",numTrees=30, maxDepth=10, seed=42) # 8.06

# Con maxDepth = 15:
rf = RandomForestRegressor(labelCol="SiteLat", featuresCol="Vector",numTrees=40, maxDepth=15, seed=42) # 6.87
rf = RandomForestRegressor(labelCol="SiteLat", featuresCol="Vector",numTrees=45, maxDepth=15, seed=42) # 7.01
rf = RandomForestRegressor(labelCol="SiteLat", featuresCol="Vector",numTrees=50, maxDepth=15, seed=42) # 6.98

# Con maxDepth = 20:
rf = RandomForestRegressor(labelCol="SiteLat", featuresCol="Vector",numTrees=40, maxDepth=20, seed=42) # 6.61
rf = RandomForestRegressor(labelCol="SiteLat", featuresCol="Vector",numTrees=45, maxDepth=20, seed=42) # 6.67
rf = RandomForestRegressor(labelCol="SiteLat", featuresCol="Vector",numTrees=50, maxDepth=20, seed=42) # 6.68

# Con maxDepth = 30:
rf = RandomForestRegressor(labelCol="SiteLat", featuresCol="Vector",numTrees=40, maxDepth=30, seed=42) # 6.51 ****
rf = RandomForestRegressor(labelCol="SiteLat", featuresCol="Vector",numTrees=45, maxDepth=30, seed=42) # 6.63
rf = RandomForestRegressor(labelCol="SiteLat", featuresCol="Vector",numTrees=50, maxDepth=30, seed=42) # 6.59
rf = RandomForestRegressor(labelCol="SiteLat", featuresCol="Vector",numTrees=60, maxDepth=30, seed=42) # 6.67

model = rf.fit(trainingData)

## Predicciones:
predictions = model.transform(testData)

## Visualizamos 10 primeras filas para apreciar en general las predicciones con respecto a la latitud:
predictions.show(10)

## Evaluación de la raíz del error cuadrático medio (rmse):
rmse = RegressionEvaluator(labelCol="SiteLat", predictionCol="prediction", metricName="rmse")
rmse_evaluado = rmse.evaluate(predictions)

print("La raíz del error cuadrático medio (RMSE) en conjunto de test es: ", rmse_evaluado)

##################################################################################################################
############################################ PREGUNTA 4 ##########################################################
##################################################################################################################

## Entrena algún otro modelo de regresión y compara el rendimiento con el apartado anterior. 
## ¿Es válido para estimar latitud alguno de los modelos que has obtenido? Argumenta tu respuesta.

# Decision tree regression:

from pyspark.ml.regression import DecisionTreeRegressor
from pyspark.ml.evaluation import RegressionEvaluator

dataframe_p3 = dataframe_p2['Vector','SiteLat']

# Separamos el dataframe en conjuntos de entrenamiento (70%) y test (30%):
(trainingData, testData) = dataframe_p3.randomSplit([0.7, 0.3])

dt = DecisionTreeRegressor(labelCol="SiteLat", featuresCol="Vector") ## 12.48

# Configuraciones de modelo ajustando la profundidad máxima en el árbol:
dt = DecisionTreeRegressor(maxDepth=2, labelCol="SiteLat", featuresCol="Vector") ## 16.16

dt = DecisionTreeRegressor(maxDepth=10, labelCol="SiteLat", featuresCol="Vector") ## 9.19

dt = DecisionTreeRegressor(maxDepth=20, labelCol="SiteLat", featuresCol="Vector") ## 9.29

dt = DecisionTreeRegressor(maxDepth=30, labelCol="SiteLat", featuresCol="Vector") ## 9.43

model_dt = dt.fit(trainingData)

## Predicciones:
predictions_dt = model_dt.transform(testData)

## Visualizamos 10 primeras filas para apreciar en general las predicciones con respecto a la latitud:
predictions_dt.show(10)

## Evaluación de la raíz del error cuadrático medio (rmse):
rmse_dt = RegressionEvaluator(labelCol="SiteLat", predictionCol="prediction", metricName="rmse")
rmse_evaluado_dt = rmse_dt.evaluate(predictions_dt)

print("La raíz del error cuadrático medio (RMSE) en conjunto de test es: ", rmse_evaluado_dt)

##################################################################################################################
############################################ PREGUNTA 5 ##########################################################
##################################################################################################################

## ¿Qué 10 familias son las más relevantes a la hora de hacer las predicciones? Atendiendo solo a esas 10 familias, 
## ¿cuánto empeora el modelo?

## Random Forest Regressor:

featureImportances = model.featureImportances.toArray() # model_dt (para Decision Tree Regressor)

a = np.sort(featureImportances)

b = np.featureImportances

indices, = np.where(featureImportances==0.00000000e+00) 

print(indices) 

## Los 10 índices (contando desde 0), donde nos fijamos para seleccionar las familias en el familias.txt son:
## [3  5  24  34  56  62  83  85  99 148]

##################################################################################################################

## Decision Tree Regressor:

## Los 10 índices (contando desde 0), donde nos fijamos para seleccionar las familias en el familias.txt son:
## [ 1   2   4   6   7  10  14  17  21  23]

## Generamos un 10_familias_rf.txt y 10_familias_dt.txt con aquellas familias seleccionadas, que se pasa a las configuraciones de los modelos.

## El rmse para el modelo Random Forest Regressor con 10 familias más relevantes da: 21.23
## El rmse para el modelo Decision Tree Regressor con 10 familias más relevantes da: 20.78
