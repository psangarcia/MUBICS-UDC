# EJERCICIO 4 BOLETÍN 4
# Función para llevar a cabo una comparación de dos cadenas de bases de misma longitud en ciertas posiciones

def comparación_cadenas(cad1, cad2, *posiciones):
    '''
    Generación de una cadena con símbolos * y = en caso de existir diferencia o no para cada posición
    Requiere dos cadenas de bases de la misma longitud y un número variable de parámetros
    que corresponden con las posiciones a analizar
    Devuelve una cadena de salida con el resultado de la comparación en las posiciones
    '''
    cadena_resultante = ''
    for n in posiciones:
            if cad1[n-1] == cad2[n-1]:
                cadena_resultante+='='
            else:
                cadena_resultante+='*'
    return(cadena_resultante)
    
    
    
# Cuerpo del programa principal
cad1 = 'AATTAA'
cad2 = 'AAATTT'
assert (comparación_cadenas(cad1, cad2, 1) == '=')

cad1 = 'ATGTCA'
cad2 = 'AAGTCT'
assert (comparación_cadenas(cad1, cad2, 2, 4, 6) == '*=*')

cad1 = 'TGTATC'
cad2 = 'TAGTCC'
assert (comparación_cadenas(cad1, cad2, 1, 6) == '==')

cad1 = 'TATACG'
cad2 = 'ATGGCA'
assert (comparación_cadenas(cad1, cad2, 3) != '=')

cad1 = 'AAAAAA' # En este caso se comprueba que no devuelve este resultado
cad2 = 'TTTTTA'
assert (comparación_cadenas(cad1, cad2, 1, 3, 5) == '===')

