# EJERCICIO 5 BOLETÍN 4

# Cuerpo principal del programa

import utilsADN

cadena = utilsADN.introducción_cadena()

print('La cadena original es:', cadena)


cálculos_bases = utilsADN.frecuencia_bases(cadena)

print('La frecuencia de bases en la cadena original es:')

utilsADN.impresión_frecuencia_bases(cálculos_bases)






cadena_mutada = utilsADN.mutación_cadena(cadena=cadena, posición = 2)

print('La cadena mutada es:', cadena_mutada)

cálculos_bases_mutada = utilsADN.frecuencia_bases(cadena=cadena_mutada)

print('La frecuencia de bases en la cadena mutada es:')

utilsADN.impresión_frecuencia_bases(cálculos_bases_mutada)
