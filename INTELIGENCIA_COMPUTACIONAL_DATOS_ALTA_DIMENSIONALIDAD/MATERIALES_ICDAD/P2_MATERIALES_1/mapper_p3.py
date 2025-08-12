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
    linea_procesada = linea.strip().split()
    clave = 1
    cromosoma = linea_procesada[0]+ '-'
    valor =  cromosoma+linea_procesada[2]
    if len(cromosoma) < 6:
        crom_mod = cromosoma + '-' # añadimos guión para casos donde longitud del nombre de cromosoma sea inferior a 6.
        valor_mod = crom_mod+linea_procesada[2]
        return (clave,valor_mod)
    else:
        return (clave,valor)

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
