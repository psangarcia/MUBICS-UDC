# Módulo EJERCICIO 5 BOLETÍN 4
# Contiene 4 funciones para introducir una cadena de ADN, realizar mutación aleatoria, calcular frecuencias de bases e imprimirlas

def introducción_cadena():
    '''
    Introducción de una cadena correcta de ADN
    Requiere una cadena que contenga letras del conjunto {'A','T','C','G'}
    Devuelve la cadena para llevar a cabo las posteriores mutaciones
    '''
    while True:
        cadena = input('Introduzca una secuencia de ADN: ').upper()
        caracteres_extraños = len(cadena)-(cadena.count('A')+cadena.count('C')+cadena.count('G')+cadena.count('T'))
        if caracteres_extraños == 0:
            break
    return cadena

def mutación_cadena(cadena, posición):
    '''
    Realización de una mutación en la cadena correcta de ADN
    Requiere la cadena solicitada anteriormente al usuario y el número de la posición a mutar
    Devuelve una nueva cadena que contiene las mutaciones realizadas
    '''
    import random
    lista = ['A','T','C','G']
    a = random.choice(lista)
    cadena_en_lista = list(cadena)
    cadena_en_lista[posición] = a
    cadena = ''.join(cadena_en_lista)
    return cadena

def frecuencia_bases(cadena):
    '''
    Cálculo de la frecuencia de bases en la cadena
    Requiere la cadena original y la cadena mutada
    Devuelve los resultados correspondientes a las frecuencias de bases en la cadena
    '''
    cálculos_bases = {                        
        'A': (cadena.count('A')/len(cadena)*100),
        'T': (cadena.count('T')/len(cadena)*100),
        'C': (cadena.count('C')/len(cadena)*100),
        'G': (cadena.count('G')/len(cadena)*100),
        }
    return cálculos_bases

def impresión_frecuencia_bases(cálculos_bases):
    '''
    Imprime las frecuencias de bases obtenidas en la cadena original y la cadena que presenta mutaciones
    Requiere los valores de las frecuencias calculadas para ambas cadenas
    Devuelve los resultados correspondientes de las frecuencias de bases
    '''
    for i in cálculos_bases:
     print(i +'= {0:5.2f}%'.format(cálculos_bases[i]))
     
