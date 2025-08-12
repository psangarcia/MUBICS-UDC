# coding: utf-8
# PRÁCTICA LIBRERÍAS - INTELIGENCIA COMPUTACIONAL PARA DATOS DE ALTA DIMENSIONALIDAD
# Funciones auxiliares

# Requiere numpy:
# sudo apt-get install python3-pip
# pip install --user numpy
import numpy as np

# Listado de familias contenidas en el conjunto de datos
familias=[linea.rstrip() for linea in open("familias.txt",'r').readlines()]

#def toVector(familyCountList: list[(str, int)]) -> list[float]:
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

from pyspark.sql.types import Row
from pyspark.ml.linalg import Vectors
def pasaFilaARow(x:any) -> Row:
    '''
    Recibe un elemento de cualquier tipo y lo transforma en un Row de pyspark
    '''
    # Utilizaremos este diccionario para definir los campos de la Row y sus valores
    d = {}

    # TODO - Definir los campos que queramos

    # Ejemplo de definición de campos
    d["campo1"]=7.0
    d["campo2"]='hola'
    d["campo_valores_entrada"]=Vectors.dense([1,-2,3,-4])
    return Row(**d)

if __name__ == '__main__':
    # Ejemplo de uso de toVector
    print(toVector([('Agonidae',40),('Zoarcidae',10)]))
    # Ejemplo de uso de pasaFilaARow. OJO, en el ejemplo se ignoran los valores que se le pasen
    print(pasaFilaARow('nada'))
