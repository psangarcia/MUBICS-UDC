print ('EJERCICIO 1')

# Constante para la cadena del banco de datos
CADENA = "UDCBB8HALH20"

# Introducción de datos
identificador = int(input('Introduzca el identificador: '))

# Salida de datos
print ('Su código es: {0}'.format(CADENA[(identificador*3)-3:((identificador*3)-3+3)]))
