#!/usr/bin/env python
#coding=UTF8
"""mapper.py"""

import sys

# MODIFICA SOLO ESTA FUNCIÓN
def funcion_map(elemento):
    '''
    Esta función recibe como entrada una cadena de texto y devuelve una tupla
    La salida de esta función se pasará al agrupador para posteriormente hacer el paso reduce
    '''
    linea=elemento
    if linea.startswith('#'):
        return (None, 1)
    else:
        linea_procesada = linea.strip().split()                    
        clave = linea_procesada[0] 
        valor = 1
        return (clave, valor)

############################
## NO HAGAS MODIFICACIONES A PARTIR DE AQUÍ
############################

# Cuerpo principal del script. Lee la entrada, la procesa para separar los elementos, a los que aplica la función map, cuyo resultado se vuelca a la salida.
# la entrada proviene de STDIN (standard input)
for line in sys.stdin:
    # se eliminan los espacios al principio y final
    line = line.strip()

    mapped = funcion_map(line)

    if mapped[0]: # Las tuplas con clave None no se emiten
        # Para emitir la tupla por STDOUT debemos transformarla en string. Usaremos un separador que, esperemos, no aparezca nunca en las claves ni en los valores
        print('%s😁🙅%s'%(str(mapped[0]), str(mapped[1])))
