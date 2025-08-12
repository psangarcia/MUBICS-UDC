#!/usr/bin/env python
#coding=UTF8
"""reducer.py"""

from functools import reduce
import sys

# MODIFICA SOLO ESTA FUNCIÓN
def funcion_reduce(elem1, elem2):
    '''
    Esta función recibe como entrada una dos cadenas de texto, que se corresponde a dos valores asociados a una misma clave. Devuelve un único valor, como cadena de texto.
    Esta función se aplicará sucesivamente a los elementos la lista de valores asociados a una misma clave para obtener un solo valor asociado a dicha clave
    '''
    return int(elem1) + int(elem2)



############################
## NO HAGAS MODIFICACIONES A PARTIR DE AQUÍ
############################

# Cuerpo principal del script. Lee la entrada, que trae todas las tuplas (clave, valor) ordenadas por clave. Agrupa los valores de la misma clave y aplica reduce a dichos grupos, obteniendo pares (clave, resultado), que vuelca a la salida.

current_clave = None
clave = 1
current_list = []
word = None

# la entrada proviene de STDIN (standard input)
for line in sys.stdin:
    # se eliminan los espacios al principio y final
    line = line.strip()

    # partimos la tupla usando el separador utilizado en mapper.py
    clave, valor = line.split('😁🙅', 1) # Si hubiese más elementos que 2 en la tupla hay un error. Optamos por quedarnos con los 2 primeros.

    # este IF funciona porque las tuplas vienen ordenadas por clave
    # mientras es
    if current_clave == clave:
        current_list.append(valor)
    else: # Hay cambio de clave
        if current_clave:
            # Si teníamos algo, aplicamos reduce a la lista y volcamos el resultado a la salida con un formato legible
            resultado = reduce(funcion_reduce, current_list)
            print('%s ----> %s' % (current_clave, resultado))
        # Reseteamos la lista
        current_list = [valor]
        # Actualizamos la clave actual
        current_clave = clave

# El bucle no emite la última clave! Si tenemos algo, lo reducimos y emitimos
if current_clave == clave:
    resultado = reduce(funcion_reduce, current_list)
    print('%s ----> %s' % (current_clave, resultado))
